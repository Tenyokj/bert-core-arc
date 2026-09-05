/**
 * @file CommunityHub.fully.ts
 * @notice Integration tests for BERT V3 community governance state and Treasury routing.
 * @dev V3 tests live under test/V3 so judges can distinguish them from the established V2 suite.
 */

import { expect } from "../setup.js";
import { getConnection } from "../helpers.js";

/** @notice describe: CommunityHub */
describe("CommunityHub", function () {
  /** @notice Deploys a Hub, its real Treasury, and a small active validator set. */
  async function deployCommunity() {
    const { ethers, networkHelpers } = await getConnection();
    const [admin, validatorOne, validatorTwo, validatorThree, memberOne, memberTwo] =
      await ethers.getSigners();

    const usdc = await (await ethers.getContractFactory("MockUSDC", admin)).deploy();
    const reserve = await (
      await ethers.getContractFactory("MockGlobalBertReserve", admin)
    ).deploy(await usdc.getAddress());
    const treasury = await (
      await ethers.getContractFactory("CommunityTreasury", admin)
    ).deploy(await usdc.getAddress(), await reserve.getAddress(), admin.address);

    const config = {
      name: "Minecraft Community",
      metadataURI: "ipfs://bert-v3/community/minecraft",
      usdc: await usdc.getAddress(),
      globalBertReserve: await reserve.getAddress(),
      initialAdmins: [admin.address],
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
    };

    const hub = await (await ethers.getContractFactory("CommunityHub", admin)).deploy(
      config,
      await treasury.getAddress(),
      admin.address
    );
    await treasury.setCommunityHub(await hub.getAddress());

    for (const account of [memberOne, memberTwo]) {
      await usdc.mint(account.address, 1_000_000n);
      await usdc.connect(account).approve(await treasury.getAddress(), 1_000_000n);
    }

    return {
      ethers,
      networkHelpers,
      admin,
      validatorOne,
      validatorTwo,
      validatorThree,
      memberOne,
      memberTwo,
      reserve,
      usdc,
      treasury,
      hub,
    };
  }

  /** @notice it: enforces the admin-validator separation invariant */
  it("rejects a role assignment that would make an admin a validator", async function () {
    const { admin, validatorOne, hub } = await deployCommunity();

    expect(await hub.isAdminAccount(admin.address)).to.equal(true);
    expect(await hub.isValidatorAccount(validatorOne.address)).to.equal(true);

    await expect(hub.addValidator(admin.address))
      .to.be.revertedWithCustomError(hub, "AdminValidatorRoleConflict")
      .withArgs(admin.address);
  });

  /** @notice it: requires local proposal-point eligibility before an admin may nominate a validator */
  it("rejects validator nomination for a member without local eligibility", async function () {
    const { admin, memberOne, hub } = await deployCommunity();
    await hub.connect(memberOne).joinCommunity();

    expect(await hub.isValidatorEligible(memberOne.address)).to.equal(false);
    await expect(hub.connect(admin).addValidator(memberOne.address))
      .to.be.revertedWithCustomError(hub, "ValidatorNotEligible")
      .withArgs(memberOne.address, 0n, 15n);
    expect(await hub.isValidatorAccount(memberOne.address)).to.equal(false);
  });

  /** @notice it: freezes proposal deadlines while the community is paused */
  it("stops the community clock while paused", async function () {
    const { admin, hub, networkHelpers } = await deployCommunity();
    await hub.connect(admin).pauseCommunity();
    const pausedClock = await hub.communityTime();
    await networkHelpers.time.increase(86_400);

    expect(await hub.communityTime()).to.equal(pausedClock);

    await hub.connect(admin).unpauseCommunity();
    expect(await hub.communityTime()).to.be.greaterThanOrEqual(pausedClock);
    expect(await hub.communityTime()).to.be.lessThan(pausedClock + 10n);
  });

  /** @notice it: archives only after fund-bearing governance settles and permits immediate member unwind */
  it("archives a clean community without trapping membership stake", async function () {
    const { admin, memberOne, usdc, hub } = await deployCommunity();
    await hub.connect(memberOne).joinCommunity();

    await expect(hub.connect(admin).archiveCommunity()).to.emit(hub, "CommunityArchived");
    expect(await hub.communityStatus()).to.equal(2n);
    await expect(hub.connect(memberOne).joinCommunity()).to.be.revertedWithCustomError(
      hub,
      "CommunityIsArchived"
    );

    await hub.connect(memberOne).requestMembershipExit();
    await hub.connect(memberOne).finalizeMembershipExit();
    expect((await hub.getMember(memberOne.address)).active).to.equal(false);
    expect(await usdc.balanceOf(memberOne.address)).to.equal(1_000_000n);
  });

  /** @notice it: prevents archival while an active vote could still lock voting escrow */
  it("rejects archive while a binary proposal remains open", async function () {
    const { admin, hub } = await deployCommunity();
    await hub.createAdminProposal("Server rules", "Adopt a new community rule set.", "ipfs://archive");
    await hub.openBinaryVoting(1);

    await expect(hub.connect(admin).archiveCommunity())
      .to.be.revertedWithCustomError(hub, "CommunityArchiveBlocked")
      .withArgs(0n, 1n, 0n, 0n);
  });

  /** @notice it: caps one binary vote at 10,000 USDC to limit whale dominance */
  it("rejects a binary vote above the protocol-wide 10,000 USDC cap", async function () {
    const { memberOne, hub } = await deployCommunity();

    await hub.createAdminProposal("Server rules", "Adopt a new community rule set.", "ipfs://proposal/cap");
    await hub.openBinaryVoting(1);
    await hub.connect(memberOne).joinCommunity();

    await expect(hub.connect(memberOne).castBinaryVote(1, 1, 10_000_000_001n))
      .to.be.revertedWithCustomError(hub, "VoteAmountCapExceeded")
      .withArgs(10_000_000_001n, 10_000_000_000n);
  });

  /** @notice it: slashes a member bond when validator rejection becomes mathematically final */
  it("slashes a rejected member proposal and prevents creator exit until its resolution", async function () {
    const { memberOne, validatorOne, validatorTwo, reserve, usdc, treasury, hub } =
      await deployCommunity();

    await hub.connect(memberOne).joinCommunity();
    await hub
      .connect(memberOne)
      .createMemberProposal("Add a mob", "Add the Sniffer to the community server.", "ipfs://proposal/1");

    await expect(hub.connect(memberOne).requestMembershipExit()).to.emit(
      hub,
      "MembershipExitRequested"
    );

    await hub.connect(validatorOne).castValidationDecision(1, false);
    await hub.connect(validatorTwo).castValidationDecision(1, false);

    const proposal = await hub.getProposal(1);
    expect(proposal.status).to.equal(1n);
    expect(await treasury.totalProposalBondLocked()).to.equal(0n);
    expect(await usdc.balanceOf(await reserve.getAddress())).to.equal(50_000n);

    await expect(hub.connect(memberOne).finalizeMembershipExit())
      .to.be.revertedWithCustomError(hub, "ExitCooldownNotFinished");
  });

  /** @notice it: settles a YES vote into execution funds and awards a winning member point */
  it("routes a winning member proposal through validation, voting, and Treasury settlement", async function () {
    const {
      memberOne,
      memberTwo,
      validatorOne,
      validatorTwo,
      treasury,
      hub,
      networkHelpers,
    } = await deployCommunity();

    await hub.connect(memberOne).joinCommunity();
    await hub.connect(memberTwo).joinCommunity();
    await hub
      .connect(memberOne)
      .createMemberProposal("Build spawn", "Build a protected community spawn area.", "ipfs://proposal/2");

    await hub.connect(validatorOne).castValidationDecision(1, true);
    await hub.connect(validatorTwo).castValidationDecision(1, true);
    await hub.openBinaryVoting(1);
    await hub.connect(memberTwo).castBinaryVote(1, 1, 100_000n);

    const opened = await hub.getProposal(1);
    await networkHelpers.time.increaseTo(Number(opened.votingDeadline) + 1);
    await hub.settleBinaryProposal(1);

    const settled = await hub.getProposal(1);
    const member = await hub.getMember(memberOne.address);
    expect(settled.accepted).to.equal(true);
    expect(settled.settled).to.equal(true);
    expect(member.proposalPoints).to.equal(1n);
    expect(await treasury.executionBalance()).to.equal(85_000n);
    expect(await treasury.validatorRewardBalance()).to.equal(15_000n);

    await hub.connect(memberTwo).clearSettledVoteLock(1);
    expect(await hub.unresolvedVoteLockCount(memberTwo.address)).to.equal(0n);
  });

  /** @notice it: uses proposal order as the deterministic first-max slate tie-breaker */
  it("settles an admin slate round into local Treasury balances without routing USDC to reserve", async function () {
    const { admin, memberOne, memberTwo, reserve, usdc, treasury, hub, networkHelpers } =
      await deployCommunity();

    await hub.createAdminSlateProposal(
      "Add bees",
      "Add bees to the Minecraft community server.",
      "ipfs://proposal/slate/1"
    );
    await hub.createAdminSlateProposal(
      "Add camels",
      "Add camels to the Minecraft community server.",
      "ipfs://proposal/slate/2"
    );
    await hub.connect(admin).createAdminSlateRound([1, 2]);
    await hub.connect(memberOne).joinCommunity();
    await hub.connect(memberTwo).joinCommunity();

    await hub.connect(memberOne).castSlateRoundVote(1, 1, 100_000n);
    await hub.connect(memberTwo).castSlateRoundVote(1, 2, 100_000n);

    const roundBeforeSettlement = await hub.getRound(1);
    await networkHelpers.time.increaseTo(Number(roundBeforeSettlement.endTime) + 1);
    await hub.settleSlateRound(1);

    const round = await hub.getRound(1);
    const winningProposal = await hub.getProposal(1);
    const losingProposal = await hub.getProposal(2);
    expect(round.winningProposalId).to.equal(1n);
    expect(round.winningVotes).to.equal(100_000n);
    expect(round.settled).to.equal(true);
    expect(winningProposal.status).to.equal(8n);
    expect(losingProposal.status).to.equal(9n);
    expect(await treasury.executionBalance()).to.equal(170_000n);
    expect(await treasury.validatorRewardBalance()).to.equal(30_000n);
    expect(await usdc.balanceOf(await reserve.getAddress())).to.equal(0n);

    await hub.connect(memberOne).clearSettledRoundVoteLock(1);
    await hub.connect(memberTwo).clearSettledRoundVoteLock(1);
    expect(await hub.unresolvedVoteLockCount(memberOne.address)).to.equal(0n);
    expect(await hub.unresolvedVoteLockCount(memberTwo.address)).to.equal(0n);
  });

  /** @notice it: returns fair-vote member bonds and awards one point to the slate winner */
  it("validates, settles, and returns bonds for member slate proposals", async function () {
    const {
      admin,
      validatorOne,
      validatorTwo,
      memberOne,
      memberTwo,
      treasury,
      hub,
      networkHelpers,
    } = await deployCommunity();

    await hub.connect(memberOne).joinCommunity();
    await hub.connect(memberTwo).joinCommunity();
    await hub
      .connect(memberOne)
      .createMemberSlateProposal("Build a market", "Build a community market at spawn.", "ipfs://proposal/member-slate/1");
    await hub
      .connect(memberTwo)
      .createMemberSlateProposal("Build an arena", "Build a PvP arena near spawn.", "ipfs://proposal/member-slate/2");

    for (const proposalId of [1, 2]) {
      await hub.connect(validatorOne).castValidationDecision(proposalId, true);
      await hub.connect(validatorTwo).castValidationDecision(proposalId, true);
    }
    await hub.connect(admin).createMemberSlateRound([1, 2]);
    await hub.connect(memberOne).castSlateRoundVote(1, 1, 150_000n);
    await hub.connect(memberTwo).castSlateRoundVote(1, 2, 100_000n);

    const roundBeforeSettlement = await hub.getRound(1);
    await networkHelpers.time.increaseTo(Number(roundBeforeSettlement.endTime) + 1);
    await hub.settleSlateRound(1);

    const winner = await hub.getProposal(1);
    const loser = await hub.getProposal(2);
    const winningAuthor = await hub.getMember(memberOne.address);
    expect(winner.status).to.equal(8n);
    expect(loser.status).to.equal(9n);
    expect(winningAuthor.proposalPoints).to.equal(1n);
    expect(await treasury.totalProposalBondLocked()).to.equal(0n);
    expect(await treasury.executionBalance()).to.equal(212_500n);
    expect(await treasury.validatorRewardBalance()).to.equal(37_500n);
  });

  /** @notice it: finalizes an undecided member proposal as rejected once its validation window expires */
  it("rejects and slashes a member proposal that cannot reach approval before its deadline", async function () {
    const { memberOne, validatorOne, reserve, hub, networkHelpers } = await deployCommunity();

    await hub.connect(memberOne).joinCommunity();
    await hub
      .connect(memberOne)
      .createMemberProposal("Add maps", "Add community-created adventure maps.", "ipfs://proposal/deadline");
    await hub.connect(validatorOne).castValidationDecision(1, true);

    const proposalBeforeDeadline = await hub.getProposal(1);
    await expect(hub.finalizeMemberProposalValidation(1))
      .to.be.revertedWithCustomError(hub, "ValidationStillOpen")
      .withArgs(1n, proposalBeforeDeadline.validationDeadline);

    await networkHelpers.time.increaseTo(Number(proposalBeforeDeadline.validationDeadline) + 1);
    await hub.finalizeMemberProposalValidation(1);

    const rejectedProposal = await hub.getProposal(1);
    expect(rejectedProposal.status).to.equal(1n);
    expect(await reserve.totalReceived()).to.equal(50_000n);
  });

  /** @notice it: settles a NO result as a pull refund while routing YES stake and fee to BERT reserve */
  it("settles a binary NO result with the configured rejection fee", async function () {
    const { admin, memberOne, memberTwo, reserve, treasury, hub, networkHelpers } =
      await deployCommunity();

    await hub.connect(admin).createAdminProposal(
      "Remove a feature",
      "Remove an unpopular feature from the server.",
      "ipfs://proposal/no-win"
    );
    await hub.openBinaryVoting(1);
    await hub.connect(memberOne).joinCommunity();
    await hub.connect(memberTwo).joinCommunity();
    await hub.connect(memberOne).castBinaryVote(1, 1, 40_000n);
    await hub.connect(memberTwo).castBinaryVote(1, 2, 100_000n);

    const openProposal = await hub.getProposal(1);
    await networkHelpers.time.increaseTo(Number(openProposal.votingDeadline) + 1);
    await hub.settleBinaryProposal(1);

    expect((await hub.getProposal(1)).accepted).to.equal(false);
    expect(await reserve.totalReceived()).to.equal(43_000n);
    expect(await treasury.totalRefundLiability()).to.equal(97_000n);

    await treasury.connect(memberTwo).claimNoVoteRefund(1);
    expect(await treasury.totalRefundLiability()).to.equal(0n);
    await hub.connect(memberOne).clearSettledVoteLock(1);
    await hub.connect(memberTwo).clearSettledVoteLock(1);
  });

  /** @notice it: manages local admin assignments without permitting an empty admin set */
  it("adds, transfers, and removes community-local administrators safely", async function () {
    const { admin, validatorOne, memberOne, hub } = await deployCommunity();

    await expect(hub.addAdmin(validatorOne.address))
      .to.be.revertedWithCustomError(hub, "AdminValidatorRoleConflict")
      .withArgs(validatorOne.address);

    await hub.addAdmin(memberOne.address);
    expect(await hub.isAdminAccount(memberOne.address)).to.equal(true);

    await hub.connect(memberOne).removeAdmin(memberOne.address);
    expect(await hub.isAdminAccount(memberOne.address)).to.equal(false);
    await expect(hub.removeAdmin(admin.address)).to.be.revertedWithCustomError(hub, "CannotRemoveLastAdmin");
  });
});
