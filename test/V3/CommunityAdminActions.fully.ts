import { expect, hre } from "../setup.js";
import { deployTransparentUpgradeable } from "../helpers.js";

describe("V3.1 Community admin quorum", function () {
  async function deployCommunity() {
    const { ethers } = await hre.network.connect();
    const [adminOne, adminTwo, validator, newAdmin] = await ethers.getSigners();
    const token = await (await ethers.getContractFactory("MockUSDC", adminOne)).deploy();
    const reserve = await (await ethers.getContractFactory("MockV3GlobalBertReserve", adminOne)).deploy(await token.getAddress());
    const verifier = await (await ethers.getContractFactory("MockHumanVerifier", adminOne)).deploy();
    await verifier.setVerified(adminOne.address, true);
    const treasuryDeployer = await (await ethers.getContractFactory("CommunityTreasuryDeployer", adminOne)).deploy();
    const membershipDeployer = await (await ethers.getContractFactory("CommunityMembershipModuleDeployer", adminOne)).deploy();
    const proposalDeployer = await (await ethers.getContractFactory("CommunityProposalModuleDeployer", adminOne)).deploy();
    const votingDeployer = await (await ethers.getContractFactory("CommunityVotingModuleDeployer", adminOne)).deploy();
    const milestoneDeployer = await (await ethers.getContractFactory("CommunityMilestoneModuleDeployer", adminOne)).deploy();
    const factory = await deployTransparentUpgradeable(ethers, adminOne, "CommunityFactory", [
      await treasuryDeployer.getAddress(), await verifier.getAddress(), await membershipDeployer.getAddress(),
      await proposalDeployer.getAddress(), await votingDeployer.getAddress(), await milestoneDeployer.getAddress(),
    ], adminOne.address);
    const config = {
      name: "Admin quorum test", metadataURI: "ipfs://bert/admin", usdc: await token.getAddress(),
      globalBertReserve: await reserve.getAddress(), initialAdmins: [adminOne.address, adminTwo.address],
      initialValidators: [validator.address], entryStakeUSDC: 10n, proposalBondUSDC: 5n, voteMinStakeUSDC: 1n,
      membershipExitCooldown: 1n, validatorApprovalThreshold: 1n, adminApprovalThreshold: 2n,
      binaryRejectionFeeBps: 0n, validatorRewardShareBps: 0n, validationWindow: 1n,
      binaryVotingDuration: 1n, roundVotingDuration: 1n, validatorRewardEpoch: 1n,
      validatorActiveThresholdBps: 5_000n, validatorProposalPointsThreshold: 1n,
      executionRecipient: adminOne.address, milestoneReviewDuration: 3n * 24n * 60n * 60n,
      milestoneProofDuration: 14n * 24n * 60n * 60n,
    };
    const [communityId, treasury] = await factory.createCommunity.staticCall(config);
    await factory.createCommunity(config);
    const actions = await (await ethers.getContractFactory("CommunityAdminActions", adminOne)).deploy();
    const Hub = await ethers.getContractFactory("CommunityHub", { libraries: { CommunityAdminActions: await actions.getAddress() } });
    const hub = await Hub.connect(adminOne).deploy(config, treasury, adminOne.address);
    await factory.activateCommunity(communityId, await hub.getAddress());
    return { adminOne, adminTwo, newAdmin, hub, actions };
  }

  it("requires the configured quorum before pausing and unpausing", async function () {
    const { ethers } = await hre.network.connect();
    const { adminOne, adminTwo, hub } = await deployCommunity();
    await hub.connect(adminOne).createAdminActionRequest(0, ethers.ZeroAddress, 0n); // Pause
    let rejectedForMissingQuorum = false;
    try {
      await hub.connect(adminOne).executeAdminActionRequest(1n);
    } catch {
      rejectedForMissingQuorum = true;
    }
    expect(rejectedForMissingQuorum).to.equal(true);
    await hub.connect(adminTwo).approveAdminActionRequest(1n);
    await hub.connect(adminTwo).executeAdminActionRequest(1n);
    expect(await hub.communityStatus()).to.equal(1n);

    await hub.connect(adminOne).createAdminActionRequest(1, ethers.ZeroAddress, 0n); // Unpause
    await hub.connect(adminTwo).approveAdminActionRequest(2n);
    await hub.connect(adminOne).executeAdminActionRequest(2n);
    expect(await hub.communityStatus()).to.equal(0n);
  });

  it("changes the administrator roster only through a separately quorum-approved request", async function () {
    const { adminOne, adminTwo, newAdmin, hub } = await deployCommunity();
    await hub.connect(adminOne).createAdminActionRequest(3, newAdmin.address, 0n); // AddAdmin
    await hub.connect(adminTwo).approveAdminActionRequest(1n);
    await hub.connect(adminOne).executeAdminActionRequest(1n);
    expect(await hub.isAdminAccount(newAdmin.address)).to.equal(true);
  });

  it("rejects malformed, duplicate, and lifecycle-incompatible quorum actions", async function () {
    const { ethers } = await hre.network.connect();
    const { adminOne, adminTwo, hub, actions } = await deployCommunity();

    await expect(hub.connect(adminOne).createAdminActionRequest(1, ethers.ZeroAddress, 0n))
      .to.be.revertedWithCustomError(hub, "CommunityNotActive");
    await expect(hub.connect(adminOne).createAdminActionRequest(0, adminTwo.address, 0n))
      .to.be.revertedWithCustomError(hub, "InvalidAdminActionParameters");
    await expect(hub.connect(adminOne).approveAdminActionRequest(99n))
      .to.be.revertedWithCustomError(actions, "AdminActionRequestNotFound");

    await hub.connect(adminOne).createAdminActionRequest(0, ethers.ZeroAddress, 0n);
    await expect(hub.connect(adminOne).approveAdminActionRequest(1n))
      .to.be.revertedWithCustomError(actions, "AdminActionAlreadyApproved");
    await hub.connect(adminTwo).approveAdminActionRequest(1n);
    await hub.connect(adminOne).executeAdminActionRequest(1n);

    await expect(hub.connect(adminOne).createAdminActionRequest(0, ethers.ZeroAddress, 0n))
      .to.be.revertedWithCustomError(hub, "CommunityIsPaused");
    await hub.connect(adminOne).createAdminActionRequest(1, ethers.ZeroAddress, 0n);
    await hub.connect(adminTwo).approveAdminActionRequest(2n);
    await hub.connect(adminOne).executeAdminActionRequest(2n);

    await expect(hub.connect(adminOne).createAdminActionRequest(6, ethers.ZeroAddress, 0n))
      .to.be.revertedWithCustomError(hub, "InvalidAdminActionParameters");
  });
});
