import { expect, hre } from "../setup.js";

describe("V3.1 CommunityTreasury", function () {
  async function deployTreasury(tokenContract = "MockUSDC") {
    const { ethers } = await hre.network.connect();
    const [deployer, supporter, recipient, outsider] = await ethers.getSigners();
    const token = await (await ethers.getContractFactory(tokenContract, deployer)).deploy();
    const reserve = await (
      await ethers.getContractFactory("MockV3GlobalBertReserve", deployer)
    ).deploy(await token.getAddress());
    const verifier = await (await ethers.getContractFactory("MockHumanVerifier", deployer)).deploy();
    const factory = await (
      await ethers.getContractFactory("MockV3CommunityFactory", deployer)
    ).deploy(await verifier.getAddress());
    const hub = await (await ethers.getContractFactory("MockV3CommunityHub", deployer)).deploy();
    const membership = await (
      await ethers.getContractFactory("MockV3TreasuryModule", deployer)
    ).deploy();
    const proposals = await (
      await ethers.getContractFactory("MockV3TreasuryModule", deployer)
    ).deploy();
    const voting = await (
      await ethers.getContractFactory("MockV3TreasuryModule", deployer)
    ).deploy();
    const milestones = await (
      await ethers.getContractFactory("MockV3TreasuryModule", deployer)
    ).deploy();
    const treasury = await (
      await ethers.getContractFactory("CommunityTreasury", deployer)
    ).deploy(await token.getAddress(), await reserve.getAddress(), await factory.getAddress());

    const setHub = treasury.interface.encodeFunctionData("setCommunityHub", [await hub.getAddress()]);
    await factory.callTarget(await treasury.getAddress(), setHub);
    const setModules = treasury.interface.encodeFunctionData("setV31Modules", [
      await membership.getAddress(),
      await proposals.getAddress(),
      await voting.getAddress(),
    ]);
    await factory.callTarget(await treasury.getAddress(), setModules);
    const setMilestoneManager = treasury.interface.encodeFunctionData("setMilestoneManager", [
      await milestones.getAddress(),
    ]);
    await factory.callTarget(await treasury.getAddress(), setMilestoneManager);

    async function moduleCall(module: any, functionName: string, args: readonly unknown[]) {
      const data = treasury.interface.encodeFunctionData(functionName, args);
      return module.callTarget(await treasury.getAddress(), data);
    }

    return { deployer, outsider, supporter, recipient, token, reserve, factory, hub, membership, proposals, voting, milestones, treasury, moduleCall };
  }

  it("allows each capability only its own custody surface", async function () {
    const { outsider, supporter, token, treasury, membership, proposals, voting, moduleCall } = await deployTreasury();
    await token.mint(supporter.address, 100n);
    await token.connect(supporter).approve(await treasury.getAddress(), 100n);

    await expect(treasury.connect(outsider).depositVoteStake(1n, supporter.address, 10n))
      .to.be.revertedWithCustomError(treasury, "NotCommunityHub");
    await expect(moduleCall(membership, "depositVoteStake", [1n, supporter.address, 10n]))
      .to.be.revertedWithCustomError(treasury, "NotCommunityHub");

    await moduleCall(proposals, "depositProposalBond", [1n, supporter.address, 10n]);
    await moduleCall(voting, "depositVoteStake", [1n, supporter.address, 20n]);
    expect(await treasury.totalProposalBondLocked()).to.equal(10n);
    expect(await treasury.totalVoteEscrow()).to.equal(20n);
  });

  it("rejects malformed escrow deposits and inconsistent settlement inputs", async function () {
    const { ethers } = await hre.network.connect();
    const { supporter, token, treasury, membership, voting, moduleCall } = await deployTreasury();
    await token.mint(supporter.address, 100n);
    await token.connect(supporter).approve(await treasury.getAddress(), 100n);

    await expect(moduleCall(membership, "depositMembershipStake", [ethers.ZeroAddress, 1n]))
      .to.be.revertedWithCustomError(treasury, "ZeroAddress");
    await expect(moduleCall(membership, "depositMembershipStake", [supporter.address, 0n]))
      .to.be.revertedWithCustomError(treasury, "ZeroAmount");
    await expect(moduleCall(voting, "depositVoteStake", [0n, supporter.address, 1n]))
      .to.be.revertedWithCustomError(treasury, "InvalidId");
    await expect(moduleCall(voting, "depositRoundVoteStake", [1n, supporter.address, 0n]))
      .to.be.revertedWithCustomError(treasury, "ZeroAmount");

    await moduleCall(voting, "depositVoteStake", [1n, supporter.address, 20n]);
    await expect(moduleCall(voting, "settleBinaryYesWin", [1n, 10n, 10n, 0n]))
      .to.be.revertedWithCustomError(treasury, "InvalidBinarySettlement");
    await expect(moduleCall(voting, "settleBinaryYesWin", [1n, 30n, 0n, 0n]))
      .to.be.revertedWithCustomError(treasury, "VoteEscrowMismatch");
    await moduleCall(voting, "settleBinaryYesWin", [1n, 20n, 0n, 0n]);
    await expect(moduleCall(voting, "depositVoteStake", [1n, supporter.address, 1n]))
      .to.be.revertedWithCustomError(treasury, "ProposalAlreadySettled");
  });

  it("blocks a malicious token callback during escrow collection and preserves the original deposit", async function () {
    const { supporter, token, treasury, voting, moduleCall } = await deployTreasury("MockReentrantUSDC");
    await token.mint(supporter.address, 100n);
    await token.connect(supporter).approve(await treasury.getAddress(), 100n);

    const reentry = treasury.interface.encodeFunctionData("depositVoteStake", [1n, supporter.address, 1n]);
    const callback = voting.interface.encodeFunctionData("callTarget", [await treasury.getAddress(), reentry]);
    await token.configureCallback(await voting.getAddress(), callback, true);

    await moduleCall(voting, "depositVoteStake", [1n, supporter.address, 20n]);

    expect(await token.callbackAttempted()).to.equal(true);
    expect(await token.lastCallbackSucceeded()).to.equal(false);
    expect(await treasury.totalVoteEscrow()).to.equal(20n);
    expect(await token.balanceOf(await treasury.getAddress())).to.equal(20n);
  });

  it("keeps V3 binary and slate settlement ledgers separate", async function () {
    const { supporter, token, reserve, treasury, voting, moduleCall } = await deployTreasury();
    await token.mint(supporter.address, 1_000n);
    await token.connect(supporter).approve(await treasury.getAddress(), 1_000n);

    await moduleCall(voting, "depositVoteStake", [1n, supporter.address, 300n]);
    await moduleCall(voting, "settleBinaryYesWin", [1n, 200n, 100n, 0n]);
    expect(await treasury.executionBalance()).to.equal(200n);
    expect(await reserve.received()).to.equal(100n);

    await moduleCall(voting, "depositRoundVoteStake", [1n, supporter.address, 400n]);
    await moduleCall(voting, "settleSlateRound", [1n, 400n, 0n]);
    expect(await treasury.executionBalance()).to.equal(600n);
    expect(await treasury.totalRoundVoteEscrow()).to.equal(0n);
  });

  it("protects execution-plan reserve and unreleased winner refunds from every other module", async function () {
    const { ethers } = await hre.network.connect();
    const { supporter, recipient, token, treasury, voting, milestones, moduleCall } = await deployTreasury();
    await token.mint(supporter.address, 100n);
    await token.connect(supporter).approve(await treasury.getAddress(), 100n);
    await moduleCall(voting, "depositVoteStake", [1n, supporter.address, 100n]);
    await moduleCall(voting, "settleBinaryYesWin", [1n, 100n, 0n, 0n]);

    await expect(moduleCall(voting, "reserveExecutionPlan", [1n, 100n]))
      .to.be.revertedWithCustomError(treasury, "NotCommunityMilestoneManager");
    await expect(moduleCall(milestones, "reserveExecutionPlan", [0n, 1n]))
      .to.be.revertedWithCustomError(treasury, "ZeroAmount");
    await expect(moduleCall(milestones, "reserveExecutionPlan", [1n, 101n]))
      .to.be.revertedWithCustomError(treasury, "InsufficientExecutionBalance");
    await moduleCall(milestones, "reserveExecutionPlan", [1n, 100n]);
    await expect(moduleCall(milestones, "releaseExecutionTranche", [1n, ethers.ZeroAddress, 1n]))
      .to.be.revertedWithCustomError(treasury, "ZeroAddress");
    await expect(moduleCall(milestones, "releaseExecutionTranche", [1n, recipient.address, 101n]))
      .to.be.revertedWithCustomError(treasury, "InsufficientMilestoneReserve");
    await moduleCall(milestones, "releaseExecutionTranche", [1n, recipient.address, 20n]);
    await expect(moduleCall(milestones, "seedExecutionPlanRefund", [1n, 0n]))
      .to.be.revertedWithCustomError(treasury, "InsufficientMilestoneReserve");
    await moduleCall(milestones, "seedExecutionPlanRefund", [1n, 80n]);

    expect(await token.balanceOf(recipient.address)).to.equal(20n);
    expect(await treasury.executionBalance()).to.equal(0n);
    expect(await treasury.totalMilestoneReserved()).to.equal(0n);
    expect(await treasury.totalMilestoneRefundLiability()).to.equal(80n);

    await expect(moduleCall(milestones, "claimExecutionPlanRefund", [1n, supporter.address, 81n]))
      .to.be.revertedWithCustomError(treasury, "InsufficientMilestoneReserve");
    await moduleCall(milestones, "claimExecutionPlanRefund", [1n, supporter.address, 80n]);
    expect(await token.balanceOf(supporter.address)).to.equal(80n);
    expect(await treasury.totalMilestoneRefundLiability()).to.equal(0n);
  });

  it("updates a plan reserve before a malicious token can reenter a tranche release", async function () {
    const { supporter, recipient, token, treasury, voting, milestones, moduleCall } = await deployTreasury("MockReentrantUSDC");
    await token.mint(supporter.address, 100n);
    await token.connect(supporter).approve(await treasury.getAddress(), 100n);
    await moduleCall(voting, "depositVoteStake", [1n, supporter.address, 100n]);
    await moduleCall(voting, "settleBinaryYesWin", [1n, 100n, 0n, 0n]);
    await moduleCall(milestones, "reserveExecutionPlan", [1n, 100n]);

    const overdraft = treasury.interface.encodeFunctionData("releaseExecutionTranche", [1n, recipient.address, 81n]);
    const callback = milestones.interface.encodeFunctionData("callTarget", [await treasury.getAddress(), overdraft]);
    await token.configureCallback(await milestones.getAddress(), callback, false);

    await moduleCall(milestones, "releaseExecutionTranche", [1n, recipient.address, 20n]);

    expect(await token.callbackAttempted()).to.equal(true);
    expect(await token.lastCallbackSucceeded()).to.equal(false);
    expect(await treasury.milestoneReserveByPlan(1n)).to.equal(80n);
    expect(await token.balanceOf(recipient.address)).to.equal(20n);
  });

  it("binds its Hub and all V3.1 module authorities exactly once", async function () {
    const { treasury, factory, hub, membership, proposals, voting, milestones } = await deployTreasury();
    const setHub = treasury.interface.encodeFunctionData("setCommunityHub", [await hub.getAddress()]);
    await expect(factory.callTarget(await treasury.getAddress(), setHub))
      .to.be.revertedWithCustomError(treasury, "CommunityHubAlreadyConfigured");

    const setModules = treasury.interface.encodeFunctionData("setV31Modules", [
      await membership.getAddress(),
      await proposals.getAddress(),
      await voting.getAddress(),
    ]);
    await expect(factory.callTarget(await treasury.getAddress(), setModules))
      .to.be.revertedWithCustomError(treasury, "CommunityV31ModulesAlreadyConfigured");
    const setMilestones = treasury.interface.encodeFunctionData("setMilestoneManager", [await milestones.getAddress()]);
    await expect(factory.callTarget(await treasury.getAddress(), setMilestones))
      .to.be.revertedWithCustomError(treasury, "CommunityMilestoneManagerAlreadyConfigured");
  });

  it("executes and cancels quorum-protected withdrawals without touching plan reserves", async function () {
    const { ethers } = await hre.network.connect();
    const { deployer, supporter, recipient, token, treasury, hub, voting, moduleCall } = await deployTreasury();
    await hub.setAdmin(deployer.address, true);
    await hub.setAdmin(supporter.address, true);
    await hub.setAdminApprovalThreshold(2n);
    await token.mint(supporter.address, 300n);
    await token.connect(supporter).approve(await treasury.getAddress(), 300n);

    await moduleCall(voting, "depositVoteStake", [1n, supporter.address, 100n]);
    await moduleCall(voting, "settleBinaryYesWin", [1n, 100n, 0n, 0n]);
    await expect(treasury.connect(recipient).createWithdrawalRequest(recipient.address, 1n, "no role", "ipfs://no-role"))
      .to.be.revertedWithCustomError(treasury, "NotCommunityAdmin");
    await expect(treasury.createWithdrawalRequest(ethers.ZeroAddress, 1n, "bad", "ipfs://bad"))
      .to.be.revertedWithCustomError(treasury, "ZeroAddress");
    await expect(treasury.createWithdrawalRequest(recipient.address, 0n, "bad", "ipfs://bad"))
      .to.be.revertedWithCustomError(treasury, "ZeroAmount");
    await expect(treasury.createWithdrawalRequest(recipient.address, 1n, "", "ipfs://bad"))
      .to.be.revertedWithCustomError(treasury, "InvalidParameter");
    await expect(treasury.createWithdrawalRequest(recipient.address, 101n, "too much", "ipfs://bad"))
      .to.be.revertedWithCustomError(treasury, "InsufficientExecutionBalance");
    await treasury.createWithdrawalRequest(recipient.address, 40n, "audit tooling", "ipfs://withdrawal/1");
    expect(await treasury.availableExecutionBalance()).to.equal(60n);
    expect(await treasury.hasApprovedWithdrawal(1n, deployer.address)).to.equal(true);
    await expect(treasury.executeWithdrawal(1n))
      .to.be.revertedWithCustomError(treasury, "WithdrawalApprovalThresholdNotMet");
    await expect(treasury.approveWithdrawal(1n))
      .to.be.revertedWithCustomError(treasury, "WithdrawalAlreadyApproved");
    await treasury.connect(supporter).approveWithdrawal(1n);
    expect((await treasury.getWithdrawalRequest(1n)).approvalCount).to.equal(2n);
    await treasury.executeWithdrawal(1n);
    expect(await token.balanceOf(recipient.address)).to.equal(40n);
    expect((await treasury.getWithdrawalRequest(1n)).executed).to.equal(true);
    await expect(treasury.executeWithdrawal(1n))
      .to.be.revertedWithCustomError(treasury, "WithdrawalAlreadyExecuted");

    await moduleCall(voting, "depositVoteStake", [2n, supporter.address, 100n]);
    await moduleCall(voting, "settleBinaryYesWin", [2n, 100n, 0n, 0n]);
    await treasury.createWithdrawalRequest(recipient.address, 25n, "cancelled", "ipfs://withdrawal/2");
    const cancelData = treasury.interface.encodeFunctionData("cancelWithdrawalRequestByGovernance", [2n]);
    await hub.callTarget(await treasury.getAddress(), cancelData);
    expect((await treasury.getWithdrawalRequest(2n)).cancelled).to.equal(true);
    expect(await treasury.availableExecutionBalance()).to.equal(160n);
    await expect(hub.callTarget(await treasury.getAddress(), cancelData))
      .to.be.revertedWithCustomError(treasury, "WithdrawalAlreadyCancelled");
  });

  it("finalizes validator rewards with a real eligibility check and pull claim", async function () {
    const { deployer, supporter, token, treasury, hub, proposals, voting, moduleCall } = await deployTreasury();
    await hub.setValidatorRewardShareBps(1_000n);
    await hub.setValidatorActiveForEpoch(1n, deployer.address, true);
    await token.mint(supporter.address, 100n);
    await token.connect(supporter).approve(await treasury.getAddress(), 100n);

    await moduleCall(voting, "depositVoteStake", [1n, supporter.address, 100n]);
    await moduleCall(voting, "settleBinaryYesWin", [1n, 100n, 0n, 1n]);
    await moduleCall(proposals, "finalizeValidatorRewardEpoch", [1n, 1n]);
    expect(await treasury.rewardPerValidatorByEpoch(1n)).to.equal(10n);

    const before = await token.balanceOf(deployer.address);
    await treasury.claimValidatorReward(1n);
    expect(await token.balanceOf(deployer.address)).to.equal(before + 10n);
    await expect(treasury.claimValidatorReward(1n)).to.be.revertedWithCustomError(
      treasury,
      "ValidatorRewardAlreadyClaimed",
    );
  });
});
