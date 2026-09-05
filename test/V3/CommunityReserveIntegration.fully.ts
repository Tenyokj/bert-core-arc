/**
 * @file CommunityReserveIntegration.fully.ts
 * @notice End-to-end test for V3 reserve routing into the upgraded V2 FundingPool proxy.
 * @dev Verifies the production adapter boundary rather than only its isolated mocks.
 */

import { expect } from "../setup.js";
import { deploySystem, deployTransparentUpgradeable } from "../helpers.js";

/** @notice describe: V3 Community reserve integration */
describe("V3 Community reserve integration", function () {
  /** @notice it: routes a validator-rejected member bond into V2 reserve with complete accounting */
  it("accounts for a real V3 Treasury reserve inflow through the V2 FundingPool proxy", async function () {
    const { ethers, admin, user1, user2, user3, user4, fundingPool, usdc } =
      await deploySystem();
    const treasuryDeployer = await (
      await ethers.getContractFactory("CommunityTreasuryDeployer", admin)
    ).deploy();
    const factory = await deployTransparentUpgradeable(
      ethers,
      admin,
      "CommunityFactory",
      [await treasuryDeployer.getAddress()],
      admin.address
    );

    const config = {
      name: "Reserve Integration Community",
      metadataURI: "ipfs://bert-v3/community/reserve-integration",
      usdc: await usdc.getAddress(),
      globalBertReserve: await fundingPool.getAddress(),
      initialAdmins: [admin.address],
      initialValidators: [user2.address, user3.address, user4.address],
      entryStakeUSDC: 100_000n,
      proposalBondUSDC: 50_000n,
      voteMinStakeUSDC: 10_000n,
      membershipExitCooldown: 3_600n,
      validatorApprovalThreshold: 2n,
      adminApprovalThreshold: 1n,
      binaryRejectionFeeBps: 300n,
      validatorRewardShareBps: 1_500n,
      validationWindow: 86_400n,
      binaryVotingDuration: 172_800n,
      roundVotingDuration: 172_800n,
      validatorRewardEpoch: 604_800n,
      validatorActiveThresholdBps: 6_000n,
    };

    const [communityId, treasuryAddress] = await factory.createCommunity.staticCall(config);
    await factory.createCommunity(config);

    const hub = await (await ethers.getContractFactory("CommunityHub", admin)).deploy(
      config,
      treasuryAddress,
      admin.address
    );
    await factory.activateCommunity(communityId, await hub.getAddress());
    await fundingPool.connect(admin).setCommunityFactory(await factory.getAddress());
    await fundingPool.connect(admin).unpause();

    await usdc.connect(user1).approve(treasuryAddress, 1_000_000n);
    await hub.connect(user1).joinCommunity();
    await hub
      .connect(user1)
      .createMemberProposal("Rejected", "A proposal that validators reject.", "ipfs://bert-v3/rejected");

    await hub.connect(user2).castValidationDecision(1, false);
    await expect(hub.connect(user3).castValidationDecision(1, false))
      .to.emit(fundingPool, "CommunityReserveReceived")
      .withArgs(treasuryAddress, 50_000n);

    expect(await fundingPool.totalPoolBalance()).to.equal(50_000n);
    expect(await fundingPool.protocolReserve()).to.equal(50_000n);
    expect(await fundingPool.donorBalances(treasuryAddress)).to.equal(0n);
    expect(await usdc.balanceOf(await fundingPool.getAddress())).to.equal(50_000n);
  });
});
