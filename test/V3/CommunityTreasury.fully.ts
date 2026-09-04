/**
 * @file CommunityTreasury.fully.ts
 * @notice Unit tests for BERT V3 USDC custody, settlement, rewards, refunds, and withdrawals.
 * @dev V3 tests live under test/V3 so judges can distinguish them from the established V2 suite.
 */

import { expect } from "../setup.js";
import { getConnection } from "../helpers.js";

/** @notice describe: CommunityTreasury */
describe("CommunityTreasury", function () {
  /** @notice Deploys an isolated Treasury with USDC and a test-only Hub. */
  async function deployTreasury() {
    const { ethers } = await getConnection();
    const [factory, voterYes, voterNo, reserve] = await ethers.getSigners();

    const usdc = await (await ethers.getContractFactory("MockUSDC", factory)).deploy();
    const hub = await (
      await ethers.getContractFactory("MockCommunityHub", factory)
    ).deploy(1_500);
    const treasury = await (
      await ethers.getContractFactory("CommunityTreasury", factory)
    ).deploy(await usdc.getAddress(), reserve.address, factory.address);

    await treasury.setCommunityHub(await hub.getAddress());

    for (const voter of [voterYes, voterNo]) {
      await usdc.mint(voter.address, 1_000_000n);
      await usdc.connect(voter).approve(await treasury.getAddress(), 1_000_000n);
    }

    return { ethers, factory, voterYes, voterNo, reserve, usdc, hub, treasury };
  }

  /** @notice it: escrows votes and routes a YES win into local and global balances */
  it("escrows votes and routes a YES win into execution, rewards, and global reserve", async function () {
    const { voterYes, voterNo, reserve, usdc, hub, treasury } = await deployTreasury();
    const proposalId = 1n;
    const yesStake = 100_000n;
    const noStake = 40_000n;

    await hub.depositVoteStake(await treasury.getAddress(), proposalId, voterYes.address, yesStake);
    await hub.depositVoteStake(await treasury.getAddress(), proposalId, voterNo.address, noStake);

    expect(await treasury.totalVoteEscrow()).to.equal(yesStake + noStake);
    expect(await treasury.voteEscrowByProposal(proposalId)).to.equal(yesStake + noStake);

    await expect(
      hub.settleBinaryYesWin(await treasury.getAddress(), proposalId, yesStake, noStake, 7)
    )
      .to.emit(treasury, "BinaryYesWinSettled")
      .withArgs(proposalId, 85_000n, 15_000n, noStake);

    expect(await treasury.totalVoteEscrow()).to.equal(0n);
    expect(await treasury.voteEscrowByProposal(proposalId)).to.equal(0n);
    expect(await treasury.executionBalance()).to.equal(85_000n);
    expect(await treasury.validatorRewardBalance()).to.equal(15_000n);
    expect(await treasury.rewardAmountByEpoch(7)).to.equal(15_000n);
    expect(await usdc.balanceOf(reserve.address)).to.equal(noStake);
    expect(await usdc.balanceOf(await treasury.getAddress())).to.equal(100_000n);
  });

  /** @notice it: keeps membership stake outside execution funds until Hub release */
  it("keeps membership stake locked until the paired Hub releases it", async function () {
    const { voterYes, usdc, hub, treasury } = await deployTreasury();
    const membershipStake = 250_000n;

    await hub.depositMembershipStake(await treasury.getAddress(), voterYes.address, membershipStake);

    expect(await treasury.totalMembershipLocked()).to.equal(membershipStake);
    expect(await treasury.executionBalance()).to.equal(0n);
    expect(await usdc.balanceOf(await treasury.getAddress())).to.equal(membershipStake);

    await hub.releaseMembershipStake(await treasury.getAddress(), voterYes.address, membershipStake);

    expect(await treasury.totalMembershipLocked()).to.equal(0n);
    expect(await usdc.balanceOf(voterYes.address)).to.equal(1_000_000n);
  });

  /** @notice it: resolves proposal bonds exactly once through slash or return */
  it("slashes rejected proposal bonds to the global reserve and returns settled bonds to authors", async function () {
    const { voterYes, voterNo, reserve, usdc, hub, treasury } = await deployTreasury();
    const bondAmount = 50_000n;

    await hub.depositProposalBond(await treasury.getAddress(), 10, voterYes.address, bondAmount);
    await hub.slashProposalBond(await treasury.getAddress(), 10);

    expect(await treasury.totalProposalBondLocked()).to.equal(0n);
    expect(await usdc.balanceOf(reserve.address)).to.equal(bondAmount);
    expect(await treasury.getProposalBond(10)).to.deep.equal([bondAmount, true]);

    await hub.depositProposalBond(await treasury.getAddress(), 11, voterNo.address, bondAmount);
    await hub.returnProposalBond(await treasury.getAddress(), 11, voterNo.address);

    expect(await treasury.totalProposalBondLocked()).to.equal(0n);
    expect(await usdc.balanceOf(voterNo.address)).to.equal(1_000_000n);
    expect(await treasury.getProposalBond(11)).to.deep.equal([bondAmount, true]);

    await expect(hub.returnProposalBond(await treasury.getAddress(), 11, voterNo.address))
      .to.be.revertedWithCustomError(treasury, "ProposalBondAlreadySettled")
      .withArgs(11n);
  });

  /** @notice it: creates and settles pull-based NO-side refunds */
  it("records NO-side refunds and routes YES stake plus rejection fee to the reserve", async function () {
    const { voterYes, voterNo, reserve, usdc, hub, treasury } = await deployTreasury();
    const proposalId = 2n;
    const yesStake = 40_000n;
    const noStake = 100_000n;
    const feeBps = 300n;

    await hub.depositVoteStake(await treasury.getAddress(), proposalId, voterYes.address, yesStake);
    await hub.depositVoteStake(await treasury.getAddress(), proposalId, voterNo.address, noStake);
    await hub.setBinaryVote(proposalId, voterNo.address, 2, noStake);

    await expect(
      hub.settleBinaryNoWin(await treasury.getAddress(), proposalId, yesStake, noStake, feeBps)
    )
      .to.emit(treasury, "BinaryNoWinSettled")
      .withArgs(proposalId, 97_000n, 43_000n);

    expect(await treasury.binaryVoteSettled(proposalId)).to.equal(true);
    expect(await treasury.noWonByProposal(proposalId)).to.equal(true);
    expect(await treasury.rejectionFeeBpsByProposal(proposalId)).to.equal(feeBps);
    expect(await treasury.totalVoteEscrow()).to.equal(0n);
    expect(await treasury.totalRefundLiability()).to.equal(97_000n);
    expect(await usdc.balanceOf(reserve.address)).to.equal(43_000n);
    expect(await usdc.balanceOf(await treasury.getAddress())).to.equal(97_000n);

    expect(await treasury.getRefundPreview(proposalId, voterNo.address)).to.deep.equal([
      97_000n,
      true,
    ]);

    await expect(treasury.connect(voterNo).claimNoVoteRefund(proposalId))
      .to.emit(treasury, "RefundClaimed")
      .withArgs(proposalId, voterNo.address, 97_000n);

    expect(await treasury.totalRefundLiability()).to.equal(0n);
    expect(await usdc.balanceOf(voterNo.address)).to.equal(997_000n);

    await expect(treasury.connect(voterNo).claimNoVoteRefund(proposalId))
      .to.be.revertedWithCustomError(treasury, "RefundAlreadyClaimed")
      .withArgs(proposalId, voterNo.address);
  });

  /** @notice it: rejects Hub settlement inputs that disagree with per-proposal escrow */
  it("rejects settlement totals that do not match the proposal escrow", async function () {
    const { voterYes, hub, treasury } = await deployTreasury();

    await hub.depositVoteStake(await treasury.getAddress(), 3, voterYes.address, 100_000n);

    await expect(
      hub.settleBinaryYesWin(await treasury.getAddress(), 3, 90_000n, 1n, 1)
    )
      .to.be.revertedWithCustomError(treasury, "VoteEscrowMismatch")
      .withArgs(3n, 100_000n, 90_001n);
  });

  /** @notice it: distributes active validator rewards and returns rounding dust to execution */
  it("splits an epoch reward equally between active validators and returns rounding dust to execution", async function () {
    const { voterYes, voterNo, usdc, hub, treasury } = await deployTreasury();
    const proposalId = 4n;
    const epochId = 9n;
    const yesStake = 100_007n;

    await hub.depositVoteStake(await treasury.getAddress(), proposalId, voterYes.address, yesStake);
    await hub.settleBinaryYesWin(await treasury.getAddress(), proposalId, yesStake, 0, epochId);
    await hub.setValidatorActiveForEpoch(epochId, voterYes.address, true);
    await hub.setValidatorActiveForEpoch(epochId, voterNo.address, true);

    await expect(
      hub.finalizeValidatorRewardEpoch(await treasury.getAddress(), epochId, 2)
    )
      .to.emit(treasury, "ValidatorRewardEpochFinalized")
      .withArgs(epochId, 7_500n, 2n);

    expect(await treasury.executionBalance()).to.equal(85_007n);
    expect(await treasury.validatorRewardBalance()).to.equal(15_000n);

    await expect(treasury.connect(voterYes).claimValidatorReward(epochId))
      .to.emit(treasury, "ValidatorRewardClaimed")
      .withArgs(epochId, voterYes.address, 7_500n);

    await treasury.connect(voterNo).claimValidatorReward(epochId);
    expect(await treasury.validatorRewardBalance()).to.equal(0n);

    await expect(treasury.connect(voterYes).claimValidatorReward(epochId))
      .to.be.revertedWithCustomError(treasury, "ValidatorRewardAlreadyClaimed")
      .withArgs(epochId, voterYes.address);
  });

  /** @notice it: reserves execution funds and requires the configured admin quorum */
  it("reserves execution funds and requires the admin quorum before withdrawal", async function () {
    const { factory, voterYes, voterNo, reserve, usdc, hub, treasury } = await deployTreasury();
    const proposalId = 5n;
    const executionAmount = 85_000n;
    const withdrawalAmount = 60_000n;

    await hub.depositVoteStake(await treasury.getAddress(), proposalId, voterYes.address, 100_000n);
    await hub.settleBinaryYesWin(await treasury.getAddress(), proposalId, 100_000n, 0, 10);
    await hub.setAdmin(factory.address, true);
    await hub.setAdmin(voterNo.address, true);
    await hub.setAdminApprovalThreshold(2);

    await expect(
      treasury.connect(factory).createWithdrawalRequest(
        reserve.address,
        withdrawalAmount,
        "Fund Minecraft server implementation",
        "ipfs://bert-v3/withdrawal/1"
      )
    )
      .to.emit(treasury, "WithdrawalRequestCreated")
      .withArgs(
        1n,
        factory.address,
        reserve.address,
        withdrawalAmount,
        "Fund Minecraft server implementation",
        "ipfs://bert-v3/withdrawal/1"
      );

    expect(await treasury.reservedExecutionBalance()).to.equal(withdrawalAmount);
    expect(await treasury.availableExecutionBalance()).to.equal(executionAmount - withdrawalAmount);

    await expect(treasury.connect(factory).executeWithdrawal(1))
      .to.be.revertedWithCustomError(treasury, "WithdrawalApprovalThresholdNotMet")
      .withArgs(1n, 1n, 2n);

    await treasury.connect(voterNo).approveWithdrawal(1);
    await expect(treasury.connect(factory).executeWithdrawal(1))
      .to.emit(treasury, "WithdrawalExecuted")
      .withArgs(1n, reserve.address, withdrawalAmount);

    const request = await treasury.getWithdrawalRequest(1);
    expect(request.executed).to.equal(true);
    expect(await treasury.executionBalance()).to.equal(executionAmount - withdrawalAmount);
    expect(await treasury.reservedExecutionBalance()).to.equal(0n);
    expect(await usdc.balanceOf(reserve.address)).to.equal(withdrawalAmount);
  });

  /** @notice it: releases the execution reservation when an admin cancels a request */
  it("cancels a withdrawal request and releases its execution reservation", async function () {
    const { factory, voterYes, reserve, hub, treasury } = await deployTreasury();

    await hub.depositVoteStake(await treasury.getAddress(), 6, voterYes.address, 100_000n);
    await hub.settleBinaryYesWin(await treasury.getAddress(), 6, 100_000n, 0, 11);
    await hub.setAdmin(factory.address, true);

    await treasury
      .connect(factory)
      .createWithdrawalRequest(reserve.address, 50_000n, "Incorrect recipient", "ipfs://bert-v3/withdrawal/2");

    await treasury.connect(factory).cancelWithdrawalRequest(1);

    const request = await treasury.getWithdrawalRequest(1);
    expect(request.cancelled).to.equal(true);
    expect(await treasury.reservedExecutionBalance()).to.equal(0n);
    expect(await treasury.availableExecutionBalance()).to.equal(85_000n);
  });
});
