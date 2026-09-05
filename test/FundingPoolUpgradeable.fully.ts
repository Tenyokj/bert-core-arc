/**
 * @file FundingPoolUpgradeable.fully.ts
 * @notice Deposits, distributions, reserves, and admin controls.
 * @dev NatSpec-style comment for test documentation.
 */

import { expect } from "./setup.js";
import { deploySystem } from "./helpers.js";

/** @notice describe: FundingPoolUpgradeable */
describe("FundingPoolUpgradeable", function () {
  /** @notice it: handles deposits and pause logic */
  it("handles deposits and pause logic", async function () {
    const { admin, user1, fundingPool, usdc } = await deploySystem();

    await usdc.mint(user1.address, 1000n);
    await usdc.connect(user1).approve(await fundingPool.getAddress(), 1000n);

    await expect(fundingPool.connect(user1).deposit(100n))
      .to.be.revertedWithCustomError(fundingPool, "EnforcedPause");

    await fundingPool.connect(admin).unpause();

    await expect(fundingPool.connect(user1).deposit(0))
      .to.be.revertedWithCustomError(fundingPool, "ZeroAmount");

    await expect(fundingPool.connect(user1).deposit(100n))
      .to.emit(fundingPool, "FundsDeposited")
      .withArgs(user1.address, 100n);

    expect(await fundingPool.totalPoolBalance()).to.equal(100n);
  });

  /** @notice it: records authenticated V3 reserve inflows without creating a donor balance */
  it("accounts for reserve capital routed by an active V3 community treasury", async function () {
    const { admin, ethers, fundingPool, usdc } = await deploySystem();
    const registry = await (
      await ethers.getContractFactory("MockCommunityFactoryRegistry", admin)
    ).deploy();
    const treasury = await (
      await ethers.getContractFactory("MockCommunityReserveTreasury", admin)
    ).deploy(await usdc.getAddress());
    const amount = 125_000n;

    await fundingPool.connect(admin).setCommunityFactory(await registry.getAddress());
    await registry.setActiveCommunityTreasury(await treasury.getAddress(), true);
    await usdc.mint(await treasury.getAddress(), amount);
    await fundingPool.connect(admin).unpause();

    await expect(treasury.routeReserve(await fundingPool.getAddress(), amount))
      .to.emit(fundingPool, "CommunityReserveReceived")
      .withArgs(await treasury.getAddress(), amount);

    expect(await fundingPool.totalPoolBalance()).to.equal(amount);
    expect(await fundingPool.protocolReserve()).to.equal(amount);
    expect(await fundingPool.donorBalances(await treasury.getAddress())).to.equal(0n);
    expect(await usdc.balanceOf(await fundingPool.getAddress())).to.equal(amount);
  });

  /** @notice it: rejects V3 reserve inflows from callers that Factory has not activated */
  it("rejects reserve routing from an unauthenticated V3 treasury", async function () {
    const { admin, user1, ethers, fundingPool } = await deploySystem();
    const registry = await (
      await ethers.getContractFactory("MockCommunityFactoryRegistry", admin)
    ).deploy();

    await fundingPool.connect(admin).setCommunityFactory(await registry.getAddress());
    await fundingPool.connect(admin).unpause();

    await expect(fundingPool.connect(user1).receiveCommunityReserve(1n))
      .to.be.revertedWithCustomError(fundingPool, "UnauthorizedCommunityTreasury")
      .withArgs(user1.address);
  });

  /** @notice it: allows voting system deposits for ideas */
  it("allows voting system deposits for ideas", async function () {
    const { admin, user1, roles, fundingPool, usdc } =
      await deploySystem();

    await usdc.mint(user1.address, 500n);
    await usdc.connect(user1).approve(await fundingPool.getAddress(), 500n);
    await fundingPool.connect(admin).unpause();

    await expect(
      fundingPool.depositForIdeaFrom(user1.address, 1, 1, 100n)
    ).to.be.revertedWithCustomError(fundingPool, "NotVotingSystem");

    const VOTING_ROLE = await roles.VOTING_ROLE();
    await roles.grantSystemRole(VOTING_ROLE, admin.address);

    await fundingPool
      .connect(admin)
      .depositForIdeaFrom(user1.address, 1, 1, 100n);

    expect(await fundingPool.totalPoolBalance()).to.equal(100n);
  });

  /** @notice it: distributes funds and moves reserve accounting explicitly */
  it("distributes funds and moves reserve accounting explicitly", async function () {
    const {
      admin,
      user1,
      roles,
      fundingPool,
      usdc,
      ideaRegistry,
    } = await deploySystem();

    await usdc.mint(user1.address, 1000n);
    await usdc.connect(user1).approve(await fundingPool.getAddress(), 1000n);

    await fundingPool.connect(admin).unpause();

    await ideaRegistry.connect(user1).createIdea("Idea", "Desc", "", 1n);

    const VOTING_ROLE = await roles.VOTING_ROLE();
    await roles.grantSystemRole(VOTING_ROLE, admin.address);
    await fundingPool.connect(admin).depositForIdeaFrom(user1.address, 1, 1, 200n);

    const DISTRIBUTOR_ROLE = await roles.DISTRIBUTOR_ROLE();
    await roles.grantSystemRole(DISTRIBUTOR_ROLE, admin.address);

    await expect(fundingPool.connect(admin).moveIdeaFundsToReserve(1, 1, 50n))
      .to.emit(fundingPool, "IdeaFundsReserved")
      .withArgs(1n, 1n, 50n);

    await expect(fundingPool.connect(admin).distributeFunds(1, 1, 150n))
      .to.emit(fundingPool, "FundsDistributed")
      .withArgs(1n, 1n, 150n);

    expect(await fundingPool.protocolReserve()).to.equal(50n);
    expect(await fundingPool.totalPoolBalance()).to.equal(51n);

    expect(await fundingPool.poolByRoundAndIdea(1, 1)).to.equal(0n);
  });

  /** @notice it: validates pool queries and admin functions */
  it("validates pool queries and admin functions", async function () {
    const { admin, ethers, fundingPool, usdc, ideaRegistry } =
      await deploySystem();

    await expect(fundingPool.isDistributed(0))
      .to.be.revertedWithCustomError(fundingPool, "InvalidId")
      .withArgs("roundId");

    await expect(fundingPool.poolByRoundAndIdea(0, 1))
      .to.be.revertedWithCustomError(fundingPool, "InvalidId")
      .withArgs("roundId");

    await expect(fundingPool.poolByRoundAndIdea(1, 0))
      .to.be.revertedWithCustomError(fundingPool, "InvalidId")
      .withArgs("ideaId");

    await expect(
      fundingPool.setGovernanceToken(ethers.ZeroAddress)
    ).to.be.revertedWithCustomError(fundingPool, "ZeroAddress");

    await expect(
      fundingPool.setIdeaRegistry(ethers.ZeroAddress)
    ).to.be.revertedWithCustomError(fundingPool, "ZeroAddress");

    expect(await fundingPool.governanceToken()).to.equal(await usdc.getAddress());

    await expect(
      fundingPool.allocateReserveToIdea(1, 1, 10)
    ).to.be.revertedWithCustomError(fundingPool, "InsufficientPoolBalance");

    await expect(fundingPool.setUsdc(await usdc.getAddress()))
      .to.emit(fundingPool, "UsdcUpdated")
      .withArgs(await usdc.getAddress());

    await expect(fundingPool.setGovernanceToken(await usdc.getAddress()))
      .to.emit(fundingPool, "GovernanceTokenUpdated")
      .withArgs(await usdc.getAddress());

    await fundingPool.setIdeaRegistry(await ideaRegistry.getAddress());

    await fundingPool.connect(admin).unpause();
    await fundingPool.connect(admin).pause();
    expect(await fundingPool.isPaused()).to.equal(true);
  });
});

/** @notice describe: FundingPoolUpgradeable edge cases */
describe("FundingPoolUpgradeable edge cases", function () {
  /** @notice it: validates depositForIdeaFrom inputs */
  it("validates depositForIdeaFrom inputs", async function () {
    const { ethers, admin, roles, fundingPool, usdc, user1 } =
      await deploySystem();

    await fundingPool.connect(admin).unpause();
    await usdc.mint(user1.address, 1000n);
    await usdc.connect(user1).approve(await fundingPool.getAddress(), 1000n);

    const VOTING_ROLE = await roles.VOTING_ROLE();
    await roles.grantSystemRole(VOTING_ROLE, admin.address);

    await expect(
      fundingPool.connect(admin).depositForIdeaFrom(ethers.ZeroAddress, 1, 1, 1)
    ).to.be.revertedWithCustomError(fundingPool, "ZeroAddress");

    await expect(
      fundingPool.connect(admin).depositForIdeaFrom(user1.address, 1, 0, 1)
    ).to.be.revertedWithCustomError(fundingPool, "InvalidId");

    await expect(
      fundingPool.connect(admin).depositForIdeaFrom(user1.address, 1, 1, 0)
    ).to.be.revertedWithCustomError(fundingPool, "ZeroAmount");
  });

  /** @notice it: rejects insufficient idea balance after partial distribution */
  it("rejects insufficient idea balance after partial distribution", async function () {
    const {
      admin,
      user1,
      roles,
      fundingPool,
      usdc,
      ideaRegistry,
    } = await deploySystem();

    await fundingPool.connect(admin).unpause();

    await ideaRegistry.connect(user1).createIdea("Idea", "Desc", "", 1n);

    await usdc.mint(user1.address, 500n);
    await usdc.connect(user1).approve(await fundingPool.getAddress(), 500n);

    const VOTING_ROLE = await roles.VOTING_ROLE();
    await roles.grantSystemRole(VOTING_ROLE, admin.address);
    await fundingPool.connect(admin).depositForIdeaFrom(user1.address, 1, 1, 200n);

    const DISTRIBUTOR_ROLE = await roles.DISTRIBUTOR_ROLE();
    await roles.grantSystemRole(DISTRIBUTOR_ROLE, admin.address);

    await expect(
      fundingPool.connect(admin).distributeFunds(1, 1, 300n)
    ).to.be.revertedWithCustomError(fundingPool, "InsufficientIdeaBalance");

    await fundingPool.connect(admin).distributeFunds(1, 1, 150n);

    await expect(
      fundingPool.connect(admin).distributeFunds(1, 1, 60n)
    ).to.be.revertedWithCustomError(fundingPool, "InsufficientIdeaBalance");
  });

  /** @notice it: validates reserve allocation inputs */
  it("validates reserve allocation inputs", async function () {
    const { admin, fundingPool } = await deploySystem();

    await expect(
      fundingPool.allocateReserveToIdea(0, 1, 1)
    ).to.be.revertedWithCustomError(fundingPool, "InvalidId");

    await expect(
      fundingPool.allocateReserveToIdea(1, 0, 1)
    ).to.be.revertedWithCustomError(fundingPool, "InvalidId");

    await expect(
      fundingPool.allocateReserveToIdea(1, 1, 0)
    ).to.be.revertedWithCustomError(fundingPool, "ZeroAmount");
  });
});

/** @notice describe: FundingPoolUpgradeable extra coverage */
describe("FundingPoolUpgradeable extra coverage", function () {
  /** @notice it: validates depositAuthorStakeFrom inputs and syncs live balance */
  it("validates author stake inputs and syncBalance", async function () {
    const { admin, user1, roles, fundingPool, usdc } = await deploySystem();

    const IREGISTRY_ROLE = await roles.IREGISTRY_ROLE();
    await roles.grantSystemRole(IREGISTRY_ROLE, admin.address);

    await expect(
      fundingPool.depositAuthorStakeFrom(user1.address, 0, 1n)
    ).to.be.revertedWithCustomError(fundingPool, "InvalidId")
      .withArgs("ideaId");

    await expect(
      fundingPool.depositAuthorStakeFrom(user1.address, 1, 0n)
    ).to.be.revertedWithCustomError(fundingPool, "ZeroAmount");

    await expect(
      fundingPool.depositAuthorStakeFrom("0x0000000000000000000000000000000000000000", 1, 1n)
    ).to.be.revertedWithCustomError(fundingPool, "ZeroAddress")
      .withArgs("from");

    await usdc.mint(user1.address, 20n);
    await usdc.connect(user1).approve(await fundingPool.getAddress(), 20n);

    await fundingPool.depositAuthorStakeFrom(user1.address, 1, 10n);
    await usdc.transfer(await fundingPool.getAddress(), 7n);

    await fundingPool.syncBalance();
    expect(await fundingPool.totalPoolBalance()).to.equal(17n);

    await expect(
      fundingPool.slashAuthorStakeToReserve(0)
    ).to.be.revertedWithCustomError(fundingPool, "InvalidId")
      .withArgs("ideaId");

    await fundingPool.slashAuthorStakeToReserve(2n);

    await expect(fundingPool.slashAuthorStakeToReserve(1n))
      .to.emit(fundingPool, "AuthorStakeSlashed")
      .withArgs(1n, 10n);

    expect(await fundingPool.authorStakeByIdea(1n)).to.equal(0n);
  });

  /** @notice it: rejects distributeFunds when paused or non-distributor */
  it("rejects distributeFunds when paused or non-distributor", async function () {
    const {
      admin,
      user1,
      roles,
      fundingPool,
      usdc,
      ideaRegistry,
    } = await deploySystem();

    await ideaRegistry.connect(user1).createIdea("Idea", "Desc", "", 1n);
    await usdc.mint(user1.address, 200n);
    await usdc
      .connect(user1)
      .approve(await fundingPool.getAddress(), 200n);

    const VOTING_ROLE = await roles.VOTING_ROLE();
    await roles.grantSystemRole(VOTING_ROLE, admin.address);

    await fundingPool.connect(admin).unpause();
    await fundingPool.connect(admin).depositForIdeaFrom(user1.address, 1, 1, 200n);

    await expect(
      fundingPool.connect(user1).distributeFunds(1, 1, 100n)
    ).to.be.revertedWithCustomError(fundingPool, "NotDistributor");

    const DISTRIBUTOR_ROLE = await roles.DISTRIBUTOR_ROLE();
    await roles.grantSystemRole(DISTRIBUTOR_ROLE, admin.address);

    await fundingPool.connect(admin).pause();
    await expect(
      fundingPool.connect(admin).distributeFunds(1, 1, 100n)
    ).to.be.revertedWithCustomError(fundingPool, "EnforcedPause");
  });

  /** @notice it: validates distributeFunds zero amount and records distributions */
  it("validates distributeFunds zero amount and records distributions", async function () {
    const {
      admin,
      user1,
      roles,
      fundingPool,
      usdc,
      ideaRegistry,
    } = await deploySystem();

    await ideaRegistry.connect(user1).createIdea("Idea", "Desc", "", 1n);
    await usdc.mint(user1.address, 200n);
    await usdc
      .connect(user1)
      .approve(await fundingPool.getAddress(), 200n);

    const VOTING_ROLE = await roles.VOTING_ROLE();
    await roles.grantSystemRole(VOTING_ROLE, admin.address);

    const DISTRIBUTOR_ROLE = await roles.DISTRIBUTOR_ROLE();
    await roles.grantSystemRole(DISTRIBUTOR_ROLE, admin.address);

    await fundingPool.connect(admin).unpause();
    await fundingPool.connect(admin).depositForIdeaFrom(user1.address, 1, 1, 200n);

    await expect(
      fundingPool.connect(admin).distributeFunds(1, 1, 0)
    ).to.be.revertedWithCustomError(fundingPool, "ZeroAmount");

    await fundingPool.connect(admin).distributeFunds(1, 1, 150n);

    expect(await fundingPool.getDistributionCount()).to.equal(1n);
    const dist = await fundingPool.getDistribution(0);
    expect(dist[0]).to.equal(1n);
    expect(dist[1]).to.equal(1n);
    expect(dist[2]).to.equal(150n);

    await expect(fundingPool.getDistribution(1))
      .to.be.revertedWithCustomError(fundingPool, "IndexOutOfBounds");
  });

  /** @notice it: allocates protocol reserve to idea */
  it("allocates protocol reserve to idea", async function () {
    const {
      admin,
      user1,
      roles,
      fundingPool,
      usdc,
      ideaRegistry,
    } = await deploySystem();

    await ideaRegistry.connect(user1).createIdea("Idea", "Desc", "", 1n);
    await usdc.mint(user1.address, 200n);
    await usdc
      .connect(user1)
      .approve(await fundingPool.getAddress(), 200n);

    const VOTING_ROLE = await roles.VOTING_ROLE();
    const DISTRIBUTOR_ROLE = await roles.DISTRIBUTOR_ROLE();
    await roles.grantSystemRole(VOTING_ROLE, admin.address);
    await roles.grantSystemRole(DISTRIBUTOR_ROLE, admin.address);

    await fundingPool.connect(admin).unpause();
    await fundingPool.connect(admin).depositForIdeaFrom(user1.address, 1, 1, 200n);
    await fundingPool.connect(admin).moveIdeaFundsToReserve(1, 1, 50n);
    await fundingPool.connect(admin).distributeFunds(1, 1, 150n);

    expect(await fundingPool.protocolReserve()).to.equal(50n);

    await fundingPool.allocateReserveToIdea(2, 2, 50n);
    expect(await fundingPool.poolByRoundAndIdea(2, 2)).to.equal(50n);
  });

  /** @notice it: enforces admin-only functions */
  it("enforces admin-only functions", async function () {
    const { user1, fundingPool, usdc, ideaRegistry } =
      await deploySystem();

    await expect(
      fundingPool.connect(user1).setGovernanceToken(await usdc.getAddress())
    ).to.be.revertedWithCustomError(fundingPool, "NotAdmin");

    await expect(
      fundingPool.connect(user1).setIdeaRegistry(await ideaRegistry.getAddress())
    ).to.be.revertedWithCustomError(fundingPool, "NotAdmin");

    await expect(
      fundingPool.connect(user1).syncBalance()
    ).to.be.revertedWithCustomError(fundingPool, "NotAdmin");

    await expect(
      fundingPool.connect(user1).pause()
    ).to.be.revertedWithCustomError(fundingPool, "NotAdmin");

    await expect(
      fundingPool.connect(user1).unpause()
    ).to.be.revertedWithCustomError(fundingPool, "NotAdmin");
  });

  /** @notice it: rejects depositForIdeaFrom when paused */
  it("rejects depositForIdeaFrom when paused", async function () {
    const { admin, user1, roles, fundingPool, usdc } =
      await deploySystem();

    await usdc.mint(user1.address, 100n);
    await usdc
      .connect(user1)
      .approve(await fundingPool.getAddress(), 100n);

    const VOTING_ROLE = await roles.VOTING_ROLE();
    await roles.grantSystemRole(VOTING_ROLE, admin.address);

    await expect(
      fundingPool.connect(admin).depositForIdeaFrom(user1.address, 1, 1, 10n)
    ).to.be.revertedWithCustomError(fundingPool, "EnforcedPause");
  });

  /** @notice it: reverts on invalid author during distribution */
  it("reverts on invalid author during distribution", async function () {
    const { admin, roles, fundingPool, usdc, ethers } =
      await deploySystem();

    const mockIdeaRegistry = await ethers.deployContract(
      "MockIdeaRegistryAuthorZero",
      []
    );
    await mockIdeaRegistry.waitForDeployment();

    await fundingPool.setIdeaRegistry(await mockIdeaRegistry.getAddress());

    const VOTING_ROLE = await roles.VOTING_ROLE();
    const DISTRIBUTOR_ROLE = await roles.DISTRIBUTOR_ROLE();
    await roles.grantSystemRole(VOTING_ROLE, admin.address);
    await roles.grantSystemRole(DISTRIBUTOR_ROLE, admin.address);

    await fundingPool.connect(admin).unpause();

    await usdc.mint(admin.address, 200n);
    await usdc
      .connect(admin)
      .approve(await fundingPool.getAddress(), 200n);

    await fundingPool
      .connect(admin)
      .depositForIdeaFrom(admin.address, 1, 1, 200n);

    await expect(
      fundingPool.connect(admin).distributeFunds(1, 1, 100n)
    ).to.be.revertedWithCustomError(fundingPool, "InvalidAuthor");
  });
});
