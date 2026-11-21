import { createRequire } from "node:module";
import { expect } from "./setup.js";
import { createIdeas, deploySystem, deployTransparentUpgradeable, getConnection } from "./helpers.js";

describe("Economic and authority boundaries", function () {
  async function backerRound() {
    const system = await deploySystem();
    const { admin, user1: author, user2, user3, user4, user5: outsider,
      ethers, ideaRegistry, fundingPool, votingSystem, grantManager } = system;
    await fundingPool.unpause();
    await votingSystem.unpause();
    await grantManager.unpause();
    await votingSystem.setIdeaPerRound(5);
    const verifier = await ethers.deployContract("MockHumanVerifier");
    const backers = [user2, user3, user4];
    for (const account of [...backers, outsider]) await verifier.setVerified(account.address, true);
    await votingSystem.setHumanVerifier(await verifier.getAddress());
    await votingSystem.setHumanOnlyVoting(true);
    await votingSystem.setBackerMilestonesEnabled(true);
    await createIdeas(ideaRegistry, author, 5);
    for (let id = 1; id <= 5; id++) {
      await ideaRegistry.connect(author).commitFundingMilestonePlan(id, `ipfs://plan-${id}`, ethers.id(`plan-${id}`));
    }
    await votingSystem.startFundingRound();
    return { ...system, admin, author, backers, outsider };
  }

  it("keeps a last-block V2.3 winning pledge in custody instead of allowing an immediate round-end refund", async function () {
    const { admin, author, backers, outsider, votingSystem, fundingPool, grantManager,
      usdc, networkHelpers, ethers } = await backerRound();
    const poolAddress = await fundingPool.getAddress();
    const pledge = ethers.parseUnits("20", 6);
    const donation = ethers.parseUnits("1000", 6);
    await fundingPool.connect(admin).deposit(donation);
    const poolBefore = await usdc.balanceOf(poolAddress);
    const lateBackerBefore = await usdc.balanceOf(backers[2].address);
    for (const backer of backers.slice(0, 2)) await votingSystem.connect(backer).vote(1n, 1n, pledge);
    await votingSystem.connect(outsider).vote(1n, 2n, pledge);

    const round = await votingSystem.getRoundInfo(1n);
    await networkHelpers.time.setNextBlockTimestamp(round[3]);
    await votingSystem.connect(backers[2]).vote(1n, 1n, pledge);
    expect(await usdc.balanceOf(backers[2].address)).to.equal(lateBackerBefore - pledge);
    expect(await usdc.balanceOf(poolAddress)).to.equal(poolBefore + pledge * 4n);

    // At the same timestamp a pledge is accepted, but settlement/refund is not.
    await expect(votingSystem.endVotingRound.staticCall(1n))
      .to.be.revertedWithCustomError(votingSystem, "RoundNotEnded");
    await expect(fundingPool.connect(backers[2]).claimPledgeRefund.staticCall(1n))
      .to.be.revertedWithCustomError(fundingPool, "PledgeRefundUnavailable");
    await networkHelpers.time.increaseTo(round[3] + 1n);
    await votingSystem.endVotingRound(1n);
    expect((await votingSystem.getRoundWinner(1n))[0]).to.equal(1n);
    await expect(fundingPool.connect(backers[2]).claimPledgeRefund(1n))
      .to.be.revertedWithCustomError(fundingPool, "PledgeRefundUnavailable");

    const loserBefore = await usdc.balanceOf(outsider.address);
    await fundingPool.connect(outsider).claimPledgeRefund(1n);
    expect(await usdc.balanceOf(outsider.address)).to.equal(loserBefore + pledge);
    await expect(fundingPool.connect(outsider).claimPledgeRefund(1n))
      .to.be.revertedWithCustomError(fundingPool, "PledgeRefundAlreadyClaimed");

    const gross = pledge * 3n;
    const fee = gross * await fundingPool.fundingRoundFeeBps(1n) / 10_000n;
    const initial = (gross - fee) * 20n / 100n;
    const bond = await fundingPool.authorStakeByIdea(1n);
    const authorBefore = await usdc.balanceOf(author.address);
    const custodyBeforeClaim = await usdc.balanceOf(poolAddress);
    await grantManager.connect(author).claimGrant(1n);
    expect(await usdc.balanceOf(author.address)).to.equal(authorBefore + bond + initial);
    expect(await usdc.balanceOf(poolAddress)).to.equal(custodyBeforeClaim - bond - initial);
    expect(await fundingPool.donorBalances(admin.address)).to.equal(donation);
    expect(await usdc.balanceOf(poolAddress)).to.be.greaterThanOrEqual(donation);
    await expect(fundingPool.connect(backers[2]).claimPledgeRefund(1n))
      .to.be.revertedWithCustomError(fundingPool, "PledgeRefundUnavailable");
    expect(await usdc.balanceOf(backers[2].address)).to.equal(lateBackerBefore - pledge);
    expect(await fundingPool.totalPoolBalance()).to.equal(await usdc.balanceOf(poolAddress));
  });

  it("cannot replace a snapshotted V2.3 review with legacy reviewer authority after toggling the global mode", async function () {
    const { author, backers, outsider, roles, votingSystem, fundingPool, grantManager,
      ethers, networkHelpers } = await backerRound();
    const pledge = await votingSystem.minStake();
    for (const backer of backers) await votingSystem.connect(backer).vote(1n, 1n, pledge);
    const round = await votingSystem.getRoundInfo(1n);
    await networkHelpers.time.increaseTo(round[3] + 1n);
    await votingSystem.endVotingRound(1n);
    await grantManager.connect(author).claimGrant(1n);
    await roles.grantRole(await roles.REVIEWER_ROLE(), outsider.address);
    await votingSystem.setBackerMilestonesEnabled(false);
    await votingSystem.setHumanOnlyVoting(false);
    expect(await votingSystem.isBackerMilestoneRound(1n)).to.equal(true);

    await grantManager.connect(author).submitBackerMilestoneProof(
      1n, 1, "ipfs://proof", "Delivered stage one", ethers.id("proof"),
    );
    const releasedBefore = (await grantManager.getGrantPayout(1n))[3];
    await expect(grantManager.connect(outsider).reviewMilestoneProof(1n, 1, true))
      .to.be.revertedWithCustomError(grantManager, "BackerMilestoneVotingRequired");
    await expect(grantManager.connect(outsider).castBackerMilestoneVote(1n, 1, true))
      .to.be.revertedWithCustomError(grantManager, "BackerMilestoneVoteUnavailable");
    for (const backer of backers) await grantManager.connect(backer).castBackerMilestoneVote(1n, 1, true);
    await expect(grantManager.connect(outsider).finalizeBackerMilestone(1n, 1))
      .to.be.revertedWithCustomError(grantManager, "BackerMilestoneFinalizationTooEarly");
    expect((await grantManager.getGrantPayout(1n))[3]).to.equal(releasedBefore);

    const request = await grantManager.getMilestoneRequest(1n, 1);
    await networkHelpers.time.increaseTo(request[3] + await grantManager.MILESTONE_REVIEW_WINDOW());
    await grantManager.connect(outsider).finalizeBackerMilestone(1n, 1);
    const net = pledge * 3n - pledge * 3n * await fundingPool.fundingRoundFeeBps(1n) / 10_000n;
    expect((await grantManager.getGrantPayout(1n))[3]).to.equal(releasedBefore + net * 40n / 100n);
  });

  it("does not transfer DEFAULT_ADMIN_ROLE when RolesRegistry Ownable ownership changes", async function () {
    const { roles, fundingPool, admin, user1 } = await deploySystem();
    const defaultAdmin = await roles.DEFAULT_ADMIN_ROLE();
    await roles.transferOwnership(user1.address);
    expect(await roles.owner()).to.equal(user1.address);
    expect(await roles.hasRole(defaultAdmin, user1.address)).to.equal(false);
    expect(await roles.hasRole(defaultAdmin, admin.address)).to.equal(true);
    await expect(fundingPool.connect(user1).setPledgeFeeBps(600n))
      .to.be.revertedWithCustomError(fundingPool, "NotAdmin");
    await fundingPool.connect(admin).setPledgeFeeBps(600n);
    await roles.connect(admin).grantRole(defaultAdmin, user1.address);
    await roles.connect(admin).renounceRole(defaultAdmin, admin.address);
    await expect(fundingPool.connect(admin).setPledgeFeeBps(700n))
      .to.be.revertedWithCustomError(fundingPool, "NotAdmin");
    await fundingPool.connect(user1).setPledgeFeeBps(700n);
    expect(await fundingPool.pledgeFeeBps()).to.equal(700n);
  });

  it("separates Transparent ProxyAdmin ownership from both RolesRegistry ownership and DEFAULT_ADMIN_ROLE", async function () {
    const { ethers } = await getConnection();
    const [protocolAdmin, upgradeOwner, nextUpgradeOwner] = await ethers.getSigners();
    const roles = await deployTransparentUpgradeable(
      ethers, protocolAdmin, "RolesRegistryUpgradeable", [], upgradeOwner.address,
    );
    const adminSlot = ethers.toBeHex(BigInt(ethers.id("eip1967.proxy.admin")) - 1n, 32);
    const adminWord = await ethers.provider.getStorage(await roles.getAddress(), adminSlot);
    const proxyAdminAddress = ethers.getAddress(`0x${adminWord.slice(-40)}`);
    const require = createRequire(import.meta.url);
    const proxyAdminArtifact = require("@openzeppelin/contracts/build/contracts/ProxyAdmin.json");
    const proxyAdmin = new ethers.Contract(proxyAdminAddress, proxyAdminArtifact.abi, upgradeOwner);
    const defaultAdmin = await roles.DEFAULT_ADMIN_ROLE();
    expect(await proxyAdmin.owner()).to.equal(upgradeOwner.address);
    expect(await roles.owner()).to.equal(protocolAdmin.address);
    expect(await roles.hasRole(defaultAdmin, upgradeOwner.address)).to.equal(false);
    await expect(roles.connect(upgradeOwner).grantRole(defaultAdmin, upgradeOwner.address))
      .to.be.revertedWithCustomError(roles, "AccessControlUnauthorizedAccount");

    const replacement = await ethers.deployContract("RolesRegistryUpgradeable");
    await expect(proxyAdmin.connect(protocolAdmin).upgradeAndCall(
      await roles.getAddress(), await replacement.getAddress(), "0x",
    )).to.be.revertedWithCustomError(proxyAdmin, "OwnableUnauthorizedAccount");
    await proxyAdmin.transferOwnership(nextUpgradeOwner.address);
    await expect(proxyAdmin.upgradeAndCall(await roles.getAddress(), await replacement.getAddress(), "0x"))
      .to.be.revertedWithCustomError(proxyAdmin, "OwnableUnauthorizedAccount");
    await proxyAdmin.connect(nextUpgradeOwner).upgradeAndCall(
      await roles.getAddress(), await replacement.getAddress(), "0x",
    );
    const implSlot = ethers.toBeHex(BigInt(ethers.id("eip1967.proxy.implementation")) - 1n, 32);
    const implWord = await ethers.provider.getStorage(await roles.getAddress(), implSlot);
    expect(ethers.getAddress(`0x${implWord.slice(-40)}`)).to.equal(await replacement.getAddress());
    expect(await roles.owner()).to.equal(protocolAdmin.address);
    expect(await roles.hasRole(defaultAdmin, protocolAdmin.address)).to.equal(true);
    expect(await roles.hasRole(defaultAdmin, nextUpgradeOwner.address)).to.equal(false);
  });
});
