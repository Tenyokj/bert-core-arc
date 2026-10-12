import { expect, hre } from "../setup.js";
import { deployTransparentUpgradeable } from "../helpers.js";

describe("V3.1 CommunityHub production wiring", function () {
  it("deploys modules below the Hub initcode limit and binds their narrow Treasury authorities once", async function () {
    const { ethers, networkHelpers } = await hre.network.connect();
    const [creator, validator, member, voter] = await ethers.getSigners();
    const token = await (await ethers.getContractFactory("MockUSDC", creator)).deploy();
    const reserve = await (await ethers.getContractFactory("MockV3GlobalBertReserve", creator)).deploy(await token.getAddress());
    const verifier = await (await ethers.getContractFactory("MockHumanVerifier", creator)).deploy();

    const treasuryDeployer = await (await ethers.getContractFactory("CommunityTreasuryDeployer", creator)).deploy();
    const membershipDeployer = await (await ethers.getContractFactory("CommunityMembershipModuleDeployer", creator)).deploy();
    const proposalDeployer = await (await ethers.getContractFactory("CommunityProposalModuleDeployer", creator)).deploy();
    const votingDeployer = await (await ethers.getContractFactory("CommunityVotingModuleDeployer", creator)).deploy();
    const milestoneDeployer = await (await ethers.getContractFactory("CommunityMilestoneModuleDeployer", creator)).deploy();
    const factory = await deployTransparentUpgradeable(ethers, creator, "CommunityFactory", [
      await treasuryDeployer.getAddress(),
      await verifier.getAddress(),
      await membershipDeployer.getAddress(),
      await proposalDeployer.getAddress(),
      await votingDeployer.getAddress(),
      await milestoneDeployer.getAddress(),
    ], creator.address);

    const config = {
      name: "V3.1 test community",
      metadataURI: "ipfs://bert/v3.1",
      usdc: await token.getAddress(),
      globalBertReserve: await reserve.getAddress(),
      initialAdmins: [creator.address],
      initialValidators: [validator.address],
      entryStakeUSDC: 10n,
      proposalBondUSDC: 5n,
      voteMinStakeUSDC: 1n,
      membershipExitCooldown: 1n,
      validatorApprovalThreshold: 1n,
      adminApprovalThreshold: 1n,
      binaryRejectionFeeBps: 0n,
      validatorRewardShareBps: 0n,
      validationWindow: 1n,
      binaryVotingDuration: 1n * 60n * 60n,
      roundVotingDuration: 1n * 60n * 60n,
      validatorRewardEpoch: 1n,
      validatorActiveThresholdBps: 5_000n,
      validatorProposalPointsThreshold: 1n,
      executionRecipient: creator.address,
      milestoneReviewDuration: 3n * 24n * 60n * 60n,
      milestoneProofDuration: 14n * 24n * 60n * 60n,
    };
    await expect(factory.createCommunity(config)).to.be.revertedWithCustomError(factory, "HumanVerificationRequired");
    await verifier.setVerified(creator.address, true);
    await verifier.setVerified(member.address, true);
    await expect(factory.getCommunity(0n)).to.be.revertedWithCustomError(factory, "InvalidId");
    await expect(factory.createCommunity({ ...config, usdc: ethers.ZeroAddress }))
      .to.be.revertedWithCustomError(factory, "ZeroAddress");
    await expect(factory.createCommunity({ ...config, globalBertReserve: ethers.ZeroAddress }))
      .to.be.revertedWithCustomError(factory, "ZeroAddress");
    const [communityId, treasuryAddress] = await factory.createCommunity.staticCall(config);
    await factory.createCommunity(config);
    expect(await factory.isActiveCommunityTreasury(treasuryAddress)).to.equal(false);
    expect((await factory.getCreatorCommunityIds(creator.address))[0]).to.equal(communityId);

    const adminActions = await (await ethers.getContractFactory("CommunityAdminActions", creator)).deploy();
    const Hub = await ethers.getContractFactory("CommunityHub", {
      libraries: { CommunityAdminActions: await adminActions.getAddress() },
    });
    const hub = await Hub.deploy(config, treasuryAddress, creator.address);
    await expect(factory.activateCommunity(communityId, ethers.ZeroAddress))
      .to.be.revertedWithCustomError(factory, "InvalidCommunityHub");
    await factory.activateCommunity(communityId, await hub.getAddress());
    await expect(factory.activateCommunity(communityId, await hub.getAddress()))
      .to.be.revertedWithCustomError(factory, "CommunityAlreadyActivated");
    expect(await factory.isActiveCommunityTreasury(treasuryAddress)).to.equal(true);

    const treasury = await ethers.getContractAt("CommunityTreasury", treasuryAddress);
    const membership = await ethers.getContractAt("CommunityMembershipModule", await hub.membershipModule());
    expect(await treasury.communityHub()).to.equal(await hub.getAddress());
    expect(await treasury.membershipModule()).to.equal(await hub.membershipModule());
    expect(await treasury.proposalModule()).to.equal(await hub.proposalModule());
    expect(await treasury.votingModule()).to.equal(await hub.votingModule());
    expect(await treasury.milestoneManager()).to.equal(await hub.milestoneManager());

    const milestones = await ethers.getContractAt("CommunityMilestoneManager", await hub.milestoneManager());
    await expect(milestones.failExpiredPlan(1n, 1n)).to.be.revertedWith("only hub");
    await expect(hub.executeAdminAction(0, ethers.ZeroAddress, 0n))
      .to.be.revertedWithCustomError(hub, "NotCommunityHub");
    await expect(hub.connect(member).createAdminProposal("No role", "Cannot create this", "ipfs://no-role"))
      .to.be.revertedWithCustomError(hub, "NotCommunityAdmin");
    await expect(hub.connect(member).createMemberProposal("No membership", "Cannot create this", "ipfs://no-member"))
      .to.be.revertedWithCustomError(hub, "NotCommunityMember");

    await token.mint(member.address, 30n);
    await token.connect(member).approve(treasuryAddress, 30n);
    await hub.connect(member).joinCommunity();
    expect((await hub.getMember(member.address)).active).to.equal(true);
    expect(await treasury.totalMembershipLocked()).to.equal(10n);
    await expect(hub.connect(member).joinCommunity())
      .to.be.revertedWithCustomError(membership, "AlreadyCommunityMember");
    await hub.connect(member).requestMembershipExit();
    await expect(hub.connect(member).castBinaryVote(1n, 1, 1n))
      .to.be.revertedWithCustomError(membership, "NotCommunityMember");

    await hub.createAdminProposal("Build", "Ship the approved work", "ipfs://build");
    await hub.openBinaryVoting(1n);
    // Rejoin is intentionally impossible until the requested exit is finalized;
    // use a fresh verified member for the vote path.
    await verifier.setVerified(voter.address, true);
    await token.mint(voter.address, 20n);
    await token.connect(voter).approve(treasuryAddress, 20n);
    await hub.connect(voter).joinCommunity();
    await hub.connect(voter).castBinaryVote(1n, 1, 10n); // YES
    await networkHelpers.time.increase(1n * 60n * 60n + 1n);
    await networkHelpers.mine();
    await hub.settleBinaryProposal(1n);

    const plan = await milestones.getPlan(1n);
    expect(plan.totalBudget).to.equal(10n);
    expect(plan.releasedAmount).to.equal(2n);
    expect(await token.balanceOf(creator.address)).to.equal(2n);
  });
});
