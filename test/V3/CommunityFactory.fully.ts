/**
 * @file CommunityFactory.fully.ts
 * @notice Unit tests for BERT V3 community reservation, activation, and registry indexing.
 * @dev V3 tests live under test/V3 so judges can distinguish them from the established V2 suite.
 */

import { expect } from "../setup.js";
import { deployTransparentUpgradeable, getConnection } from "../helpers.js";

/** @notice describe: CommunityFactory */
describe("CommunityFactory", function () {
  /** @notice Builds a valid immutable config for one independently governed community. */
  async function buildConfig(ethers: any) {
    const [creator, validatorOne, validatorTwo, validatorThree] =
      await ethers.getSigners();
    const usdc = await (await ethers.getContractFactory("MockUSDC", creator)).deploy();
    const reserve = await (
      await ethers.getContractFactory("MockGlobalBertReserve", creator)
    ).deploy(await usdc.getAddress());
    const humanVerifier = await (await ethers.getContractFactory("MockHumanVerifier", creator)).deploy();
    await humanVerifier.setVerified(creator.address, true);

    return {
      creator,
      validatorOne,
      validatorTwo,
      validatorThree,
      reserve,
      usdc,
      humanVerifier,
      config: {
        name: "Minecraft Community",
        metadataURI: "ipfs://bert-v3/community/minecraft",
        usdc: await usdc.getAddress(),
        globalBertReserve: await reserve.getAddress(),
        initialAdmins: [creator.address],
        initialValidators: [validatorOne.address, validatorTwo.address, validatorThree.address],
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
        validatorProposalPointsThreshold: 15n,
      },
    };
  }

  /** @notice it: locks the implementation and permits Factory initialization only once through its proxy */
  it("locks the implementation and prevents proxy reinitialization", async function () {
    const { ethers } = await getConnection();
    const [creator] = await ethers.getSigners();
    const treasuryDeployer = await (
      await ethers.getContractFactory("CommunityTreasuryDeployer", creator)
    ).deploy();
    const implementation = await (
      await ethers.getContractFactory("CommunityFactory", creator)
    ).deploy();
    const humanVerifier = await (await ethers.getContractFactory("MockHumanVerifier", creator)).deploy();

    await expect(implementation.initialize(await treasuryDeployer.getAddress(), await humanVerifier.getAddress()))
      .to.be.revertedWithCustomError(implementation, "InvalidInitialization");

    const factory = await deployTransparentUpgradeable(
      ethers,
      creator,
      "CommunityFactory",
      [await treasuryDeployer.getAddress(), await humanVerifier.getAddress()],
      creator.address
    );

    await expect(factory.initialize(await treasuryDeployer.getAddress(), await humanVerifier.getAddress()))
      .to.be.revertedWithCustomError(factory, "InvalidInitialization");
  });

  /** @notice it: reserves a Treasury then safely activates the creator's direct Hub deployment */
  it("reserves, verifies, links, and indexes a community", async function () {
    const { ethers } = await getConnection();
    const { creator, usdc, config, humanVerifier } = await buildConfig(ethers);
    const treasuryDeployer = await (
      await ethers.getContractFactory("CommunityTreasuryDeployer", creator)
    ).deploy();
    const factory = await deployTransparentUpgradeable(
      ethers,
      creator,
      "CommunityFactory",
      [await treasuryDeployer.getAddress(), await humanVerifier.getAddress()],
      creator.address
    );

    const [communityId, treasuryAddress] = await factory.createCommunity.staticCall(config);
    await expect(factory.createCommunity(config)).to.emit(factory, "CommunityTreasuryCreated");

    const pendingDeployment = await factory.getCommunity(communityId);
    expect(pendingDeployment.hub).to.equal(ethers.ZeroAddress);
    expect(pendingDeployment.treasury).to.equal(treasuryAddress);
    expect(await factory.isActiveCommunityTreasury(treasuryAddress)).to.equal(false);

    const adminActions = await (await ethers.getContractFactory("CommunityAdminActions", creator)).deploy();
    const CommunityHub = await ethers.getContractFactory("CommunityHub", {
      libraries: { CommunityAdminActions: await adminActions.getAddress() },
    });
    const hub = await CommunityHub.connect(creator).deploy(
      config,
      treasuryAddress,
      creator.address
    );
    await expect(factory.activateCommunity(communityId, await hub.getAddress())).to.emit(
      factory,
      "CommunityCreated"
    );

    const deployment = await factory.getCommunity(communityId);
    const treasury = await ethers.getContractAt("CommunityTreasury", deployment.treasury);

    expect(await factory.communityCount()).to.equal(1n);
    expect(deployment.creator).to.equal(creator.address);
    expect(await factory.getCreatorCommunityIds(creator.address)).to.deep.equal([1n]);
    expect(await factory.communityIdByHub(deployment.hub)).to.equal(1n);
    expect(await factory.communityIdByTreasury(deployment.treasury)).to.equal(1n);
    expect(await factory.isActiveCommunityTreasury(deployment.treasury)).to.equal(true);

    expect(await hub.creator()).to.equal(creator.address);
    expect(await hub.isAdminAccount(creator.address)).to.equal(true);
    expect(await treasury.factory()).to.equal(await factory.getAddress());
    expect(await treasury.communityHub()).to.equal(deployment.hub);
    expect(await treasury.usdc()).to.equal(await usdc.getAddress());
  });

  /** @notice it: rejects activation with a Hub constructed from any different immutable config */
  it("rejects a Hub whose configuration does not match the reserved community", async function () {
    const { ethers } = await getConnection();
    const { creator, config, humanVerifier } = await buildConfig(ethers);
    const treasuryDeployer = await (
      await ethers.getContractFactory("CommunityTreasuryDeployer", creator)
    ).deploy();
    const factory = await deployTransparentUpgradeable(
      ethers,
      creator,
      "CommunityFactory",
      [await treasuryDeployer.getAddress(), await humanVerifier.getAddress()],
      creator.address
    );
    const [communityId, treasuryAddress] = await factory.createCommunity.staticCall(config);
    await factory.createCommunity(config);
    const changedConfig = { ...config, name: "Different Community" };
    const adminActions = await (await ethers.getContractFactory("CommunityAdminActions", creator)).deploy();
    const CommunityHub = await ethers.getContractFactory("CommunityHub", {
      libraries: { CommunityAdminActions: await adminActions.getAddress() },
    });
    const mismatchedHub = await CommunityHub.connect(creator).deploy(
      changedConfig,
      treasuryAddress,
      creator.address
    );

    await expect(factory.activateCommunity(communityId, await mismatchedHub.getAddress()))
      .to.be.revertedWithCustomError(factory, "InvalidCommunityHub")
      .withArgs(await mismatchedHub.getAddress());
    expect((await factory.getCommunity(communityId)).hub).to.equal(ethers.ZeroAddress);
  });

  /** @notice it: rejects invalid reservation and activation identifiers before any treasury link can occur */
  it("guards invalid factory inputs and prevents non-creators from activating a reservation", async function () {
    const { ethers } = await getConnection();
    const { creator, validatorOne, config, humanVerifier } = await buildConfig(ethers);
    const treasuryDeployer = await (
      await ethers.getContractFactory("CommunityTreasuryDeployer", creator)
    ).deploy();
    const factory = await deployTransparentUpgradeable(
      ethers,
      creator,
      "CommunityFactory",
      [await treasuryDeployer.getAddress(), await humanVerifier.getAddress()],
      creator.address
    );

    await expect(factory.getCommunity(0)).to.be.revertedWithCustomError(factory, "InvalidId");
    await expect(factory.activateCommunity(1, creator.address))
      .to.be.revertedWithCustomError(factory, "InvalidId");
    await expect(factory.createCommunity({ ...config, usdc: ethers.ZeroAddress }))
      .to.be.revertedWithCustomError(factory, "ZeroAddress")
      .withArgs("usdc");

    const [communityId, treasuryAddress] = await factory.createCommunity.staticCall(config);
    await factory.createCommunity(config);
    const adminActions = await (await ethers.getContractFactory("CommunityAdminActions", creator)).deploy();
    const CommunityHub = await ethers.getContractFactory("CommunityHub", {
      libraries: { CommunityAdminActions: await adminActions.getAddress() },
    });
    const hub = await CommunityHub.connect(creator).deploy(
      config,
      treasuryAddress,
      creator.address
    );

    await expect(factory.connect(validatorOne).activateCommunity(communityId, await hub.getAddress()))
      .to.be.revertedWithCustomError(factory, "NotCommunityCreator")
      .withArgs(communityId, validatorOne.address);
    await expect(factory.activateCommunity(communityId, ethers.ZeroAddress))
      .to.be.revertedWithCustomError(factory, "InvalidCommunityHub")
      .withArgs(ethers.ZeroAddress);

    await factory.activateCommunity(communityId, await hub.getAddress());
    await expect(factory.activateCommunity(communityId, await hub.getAddress()))
      .to.be.revertedWithCustomError(factory, "CommunityAlreadyActivated")
      .withArgs(communityId);
  });

  /** @notice it: blocks unverified wallets from reserving a new community. */
  it("requires proof-of-personhood before creating a community", async function () {
    const { ethers } = await getConnection();
    const { creator, config, humanVerifier } = await buildConfig(ethers);
    const treasuryDeployer = await (
      await ethers.getContractFactory("CommunityTreasuryDeployer", creator)
    ).deploy();
    const factory = await deployTransparentUpgradeable(
      ethers,
      creator,
      "CommunityFactory",
      [await treasuryDeployer.getAddress(), await humanVerifier.getAddress()],
      creator.address
    );

    await humanVerifier.setVerified(creator.address, false);
    await expect(factory.createCommunity(config))
      .to.be.revertedWithCustomError(factory, "HumanVerificationRequired")
      .withArgs(creator.address);
  });
});
