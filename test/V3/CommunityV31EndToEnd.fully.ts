import { expect, hre } from "../setup.js";
import { deployTransparentUpgradeable } from "../helpers.js";

/**
 * These tests deliberately use the production Hub/Factory/module wiring instead
 * of module mocks. They protect the cross-contract accounting invariants that
 * unit tests cannot observe: vote escrow, plan reserves, reviewer eligibility,
 * tranche releases, and failed-plan pull refunds.
 */
describe("V3.1 Community end-to-end lifecycle", function () {
  async function deployCommunity(executionRecipientIsMember = false, multiAdmin = false) {
    const { ethers, networkHelpers } = await hre.network.connect();
    const [creator, validator, author, supporterOne, supporterTwo, supporterThree, noVoter, exitingMember, adminTwo, adminThree, relay] =
      await ethers.getSigners();

    const token = await (await ethers.getContractFactory("MockUSDC", creator)).deploy();
    const reserve = await (await ethers.getContractFactory("MockV3GlobalBertReserve", creator)).deploy(
      await token.getAddress(),
    );
    const verifier = await (await ethers.getContractFactory("MockHumanVerifier", creator)).deploy();
    for (const account of [creator, author, supporterOne, supporterTwo, supporterThree, noVoter, exitingMember]) {
      await verifier.setVerified(account.address, true);
    }

    const treasuryDeployer = await (await ethers.getContractFactory("CommunityTreasuryDeployer", creator)).deploy();
    const membershipDeployer = await (
      await ethers.getContractFactory("CommunityMembershipModuleDeployer", creator)
    ).deploy();
    const proposalDeployer = await (
      await ethers.getContractFactory("CommunityProposalModuleDeployer", creator)
    ).deploy();
    const votingDeployer = await (await ethers.getContractFactory("CommunityVotingModuleDeployer", creator)).deploy();
    const milestoneDeployer = await (
      await ethers.getContractFactory("CommunityMilestoneModuleDeployer", creator)
    ).deploy();

    const factory = await deployTransparentUpgradeable(ethers, creator, "CommunityFactory", [
      await treasuryDeployer.getAddress(),
      await verifier.getAddress(),
      await membershipDeployer.getAddress(),
      await proposalDeployer.getAddress(),
      await votingDeployer.getAddress(),
      await milestoneDeployer.getAddress(),
    ], creator.address);

    const config = {
      name: "E2E V3.1 Community",
      metadataURI: "ipfs://bert/v3.1/e2e",
      usdc: await token.getAddress(),
      globalBertReserve: await reserve.getAddress(),
      initialAdmins: multiAdmin ? [creator.address, adminTwo.address, adminThree.address] : [creator.address],
      initialValidators: [validator.address],
      entryStakeUSDC: 10n,
      proposalBondUSDC: 5n,
      voteMinStakeUSDC: 1n,
      membershipExitCooldown: 60n,
      validatorApprovalThreshold: 1n,
      adminApprovalThreshold: multiAdmin ? 2n : 1n,
      binaryRejectionFeeBps: 1_000n,
      validatorRewardShareBps: 1_000n,
      validationWindow: 60n * 60n,
      binaryVotingDuration: 60n * 60n,
      roundVotingDuration: 60n * 60n,
      validatorRewardEpoch: 60n * 60n,
      validatorActiveThresholdBps: 5_000n,
      validatorProposalPointsThreshold: 1n,
      executionRecipient: executionRecipientIsMember ? supporterOne.address : creator.address,
      milestoneReviewDuration: 24n * 60n * 60n,
      milestoneProofDuration: 24n * 60n * 60n,
    };
    const [communityId, treasuryAddress] = await factory.createCommunity.staticCall(config);
    await factory.createCommunity(config);

    const adminActions = await (await ethers.getContractFactory("CommunityAdminActions", creator)).deploy();
    const Hub = await ethers.getContractFactory("CommunityHub", {
      libraries: { CommunityAdminActions: await adminActions.getAddress() },
    });
    const hub = await Hub.deploy(config, treasuryAddress, creator.address);
    await factory.activateCommunity(communityId, await hub.getAddress());
    const deployment = await factory.getCommunity(communityId);
    expect(deployment.hub).to.equal(await hub.getAddress());
    expect(await factory.isActiveCommunityTreasury(treasuryAddress)).to.equal(true);
    expect(await factory.getCreatorCommunityIds(creator.address)).to.deep.equal([communityId]);

    const treasury = await ethers.getContractAt("CommunityTreasury", treasuryAddress);
    const milestones = await ethers.getContractAt("CommunityMilestoneManager", await hub.milestoneManager());
    const voting = await ethers.getContractAt("CommunityVotingModule", await hub.votingModule());
    const proposals = await ethers.getContractAt("CommunityProposalModule", await hub.proposalModule());
    const membership = await ethers.getContractAt("CommunityMembershipModule", await hub.membershipModule());

    const fundedMembers = [author, supporterOne, supporterTwo, supporterThree, noVoter, exitingMember];
    for (const member of fundedMembers) {
      await token.mint(member.address, 100_000n);
      await token.connect(member).approve(treasuryAddress, 100_000n);
      await hub.connect(member).joinCommunity();
    }

    async function passVotingWindow() {
      await networkHelpers.time.increase(60n * 60n + 1n);
      await networkHelpers.mine();
    }

    async function passReviewWindow() {
      await networkHelpers.time.increase(24n * 60n * 60n + 1n);
      await networkHelpers.mine();
    }

    async function payTranche(planId: bigint) {
      const admins = multiAdmin ? [creator, adminTwo] : [creator];
      for (const admin of admins) await hub.connect(admin).approveExecutionTranche(planId);
      const addresses = admins.map((admin) => admin.address).sort((a, b) => a.toLowerCase().localeCompare(b.toLowerCase()));
      await hub.connect(noVoter).executeExecutionTranche(planId, addresses);
    }

    return {
      ethers,
      networkHelpers,
      creator,
      adminTwo,
      adminThree,
      relay,
      validator,
      author,
      supporterOne,
      supporterTwo,
      supporterThree,
      noVoter,
      exitingMember,
      token,
      reserve,
      factory,
      hub,
      treasury,
      milestones,
      voting,
      proposals,
      membership,
      passVotingWindow,
      passReviewWindow,
      payTranche,
    };
  }

  for (const lane of ["Admin Binary", "Member Binary", "Admin Slate", "Member Slate"]) {
    it(`blocks executor self-review in ${lane} without changing validator rewards or 20/40/40 payouts`, async function () {
      const { hub, validator, author, supporterOne, supporterTwo, supporterThree, noVoter, milestones, treasury,
        passVotingWindow, passReviewWindow, payTranche } = await deployCommunity(true, true);
      const memberOrigin = lane.startsWith("Member");
      const slate = lane.endsWith("Slate");
      if (slate) {
        if (memberOrigin) {
          await hub.connect(author).createMemberSlateProposal("Winner", "Member winner", "ipfs://winner");
          await hub.connect(author).createMemberSlateProposal("Alternative", "Member alternative", "ipfs://alternative");
          await hub.connect(validator).castValidationDecision(1n, true);
          await hub.connect(validator).castValidationDecision(2n, true);
          await hub.createMemberSlateRound([1n, 2n]);
        } else {
          await hub.createAdminSlateProposal("Winner", "Admin winner", "ipfs://winner");
          await hub.createAdminSlateProposal("Alternative", "Admin alternative", "ipfs://alternative");
          await hub.createAdminSlateRound([1n, 2n]);
        }
      } else {
        if (memberOrigin) {
          await hub.connect(author).createMemberProposal("Winner", "Member winner", "ipfs://winner");
          await hub.connect(validator).castValidationDecision(1n, true);
        } else await hub.createAdminProposal("Winner", "Admin winner", "ipfs://winner");
        await hub.openBinaryVoting(1n);
      }
      const reviewers = [supporterTwo, supporterThree, noVoter];
      for (const supporter of [supporterOne, ...reviewers]) {
        const amount = supporter === supporterOne ? 900n : 100n;
        if (slate) await hub.connect(supporter).castSlateRoundVote(1n, 1n, amount);
        else await hub.connect(supporter).castBinaryVote(1n, 1, amount);
      }
      await passVotingWindow();
      if (slate) await hub.settleSlateRound(1n);
      else await hub.settleBinaryProposal(1n);
      await payTranche(1n);
      const budget = memberOrigin ? 1_080n : 1_200n;
      expect(await milestones.totalSupportWeightByPlan(1n)).to.equal(1_200n);
      expect((await milestones.getPlan(1n)).eligibleSupportWeight).to.equal(300n);
      expect(await milestones.eligibleReviewerCountByPlan(1n)).to.equal(3n);
      expect(await treasury.validatorRewardBalance()).to.equal(memberOrigin ? 120n : 0n);

      for (const milestone of [1n, 2n]) {
        await hub.connect(supporterOne).submitMilestoneProof(1n, "0x" + "ab".repeat(32));
        for (const approved of [true, false]) {
          await expect(hub.connect(supporterOne).castMilestoneReview(1n, approved))
            .to.be.revertedWith("execution recipient cannot review");
        }
        for (const reviewer of reviewers) await hub.connect(reviewer).castMilestoneReview(1n, true);
        await passReviewWindow();
        await hub.finalizeMilestoneReview(1n);
        await payTranche(1n);
        expect((await milestones.getPlan(1n)).releasedAmount)
          .to.equal(milestone === 1n ? (budget * 6n) / 10n : budget);
      }
      expect((await milestones.getPlan(1n)).status).to.equal(5n);
      expect(await treasury.totalMilestoneReserved()).to.equal(0n);
      expect(await treasury.validatorRewardBalance()).to.equal(memberOrigin ? 120n : 0n);
    });
  }

  it("preserves a Member execution recipient's failed-plan refund and exit lock until its claim", async function () {
    const { hub, supporterOne, supporterTwo, supporterThree, noVoter, token, treasury, milestones, voting,
      networkHelpers, passVotingWindow, payTranche } = await deployCommunity(true);
    await hub.createAdminProposal("Refund rights", "Executor is also a financial supporter", "ipfs://refund-rights");
    await hub.openBinaryVoting(1n);
    for (const supporter of [supporterOne, supporterTwo, supporterThree, noVoter]) {
      await hub.connect(supporter).castBinaryVote(1n, 1, supporter === supporterOne ? 50n : 17n);
    }
    await passVotingWindow();
    await hub.settleBinaryProposal(1n);
    await payTranche(1n);
    expect((await milestones.getPlan(1n)).eligibleSupportWeight).to.equal(51n);
    expect(await milestones.totalSupportWeightByPlan(1n)).to.equal(101n);
    await expect(hub.connect(supporterOne).clearSettledVoteLock(1n))
      .to.be.revertedWithCustomError(voting, "MembershipExitBlocked").withArgs(supporterOne.address);
    await networkHelpers.time.increase(24n * 60n * 60n + 2n);
    await hub.failExpiredPlan(1n);
    expect(await milestones.canReleaseReviewerLock(1n, supporterOne.address)).to.equal(false);
    const recipientBefore = await token.balanceOf(supporterOne.address);
    await hub.connect(supporterOne).claimFailedPlanRefund(1n);
    expect(await token.balanceOf(supporterOne.address)).to.equal(recipientBefore + 40n);
    await hub.connect(supporterOne).clearSettledVoteLock(1n);
    for (const supporter of [supporterTwo, supporterThree, noVoter]) await hub.connect(supporter).claimFailedPlanRefund(1n);
    expect(await treasury.totalMilestoneRefundLiability()).to.equal(0n);
    expect(await milestones.refundPaidByPlan(1n)).to.equal(81n);
  });

  it("settles a validated Member proposal through both supporter-approved milestones", async function () {
    const ctx = await deployCommunity();
    const { hub, validator, author, supporterOne, supporterTwo, supporterThree, creator, token, milestones, treasury, networkHelpers, passVotingWindow, passReviewWindow, payTranche } = ctx;

    await hub.connect(author).createMemberProposal("Member build", "Deliver an audited implementation", "ipfs://member-build");
    expect((await hub.getProposal(1n)).creator).to.equal(author.address);
    await hub.connect(validator).castValidationDecision(1n, true);
    await hub.openBinaryVoting(1n);
    expect(await hub.isValidatorEligible(author.address)).to.equal(false);

    for (const supporter of [supporterOne, supporterTwo, supporterThree]) {
      await hub.connect(supporter).castBinaryVote(1n, 1, 100n);
    }
    expect((await hub.getBinaryVote(1n, supporterOne.address)).stake).to.equal(100n);
    await passVotingWindow();
    await hub.settleBinaryProposal(1n);
    await payTranche(1n);

    // The 10% validator share is reserved separately: 270 executes, 30 stays in the epoch bucket.
    let plan = await milestones.getPlan(1n);
    expect(plan.totalBudget).to.equal(270n);
    expect(plan.releasedAmount).to.equal(54n);
    expect(await treasury.totalMilestoneReserved()).to.equal(216n);
    expect(await token.balanceOf(creator.address)).to.equal(54n);

    await hub.submitMilestoneProof(1n, "0x" + "11".repeat(32));
    for (const supporter of [supporterOne, supporterTwo, supporterThree]) {
      await hub.connect(supporter).castMilestoneReview(1n, true);
    }
    await passReviewWindow();
    await hub.finalizeMilestoneReview(1n);
    await payTranche(1n);

    plan = await milestones.getPlan(1n);
    expect(plan.currentMilestone).to.equal(2n);
    expect(plan.releasedAmount).to.equal(162n);
    expect(plan.status).to.equal(1n); // AwaitingProof

    await hub.submitMilestoneProof(1n, "0x" + "22".repeat(32));
    for (const supporter of [supporterOne, supporterTwo, supporterThree]) {
      await hub.connect(supporter).castMilestoneReview(1n, true);
    }
    await passReviewWindow();
    await hub.finalizeMilestoneReview(1n);
    await payTranche(1n);

    plan = await milestones.getPlan(1n);
    expect(plan.status).to.equal(5n); // Completed
    expect(plan.releasedAmount).to.equal(270n);
    expect(await treasury.totalMilestoneReserved()).to.equal(0n);
    expect(await token.balanceOf(creator.address)).to.equal(270n);

    // A completed plan releases the supporter exit locks created by voting.
    for (const supporter of [supporterOne, supporterTwo, supporterThree]) {
      await hub.connect(supporter).clearSettledVoteLock(1n);
    }

    // Validator compensation is pull-based and only opens after the review epoch closes.
    await hub.finalizeValidatorRewardEpoch(1n);
    expect((await hub.getValidatorRewardEpoch(1n)).finalized).to.equal(true);
    const validatorBefore = await token.balanceOf(validator.address);
    await treasury.connect(validator).claimValidatorReward(1n);
    expect(await token.balanceOf(validator.address)).to.equal(validatorBefore + 30n);

    // A successful Member author can leave, then become a validator only through Admin quorum.
    await hub.connect(author).requestMembershipExit();
    await networkHelpers.time.increase(61n);
    await networkHelpers.mine();
    await hub.connect(author).finalizeMembershipExit();
    await hub.createAdminActionRequest(5, author.address, 0n); // AddValidator
    await hub.executeAdminActionRequest(1n);
    expect(await hub.isValidatorAccount(author.address)).to.equal(true);
    await hub.connect(author).renounceValidatorRole();
    expect(await hub.isValidatorAccount(author.address)).to.equal(false);
  });

  it("returns a failed plan's unreleased budget only to its winning supporters", async function () {
    const ctx = await deployCommunity();
    const { hub, supporterOne, supporterTwo, supporterThree, creator, token, milestones, treasury, networkHelpers, passVotingWindow, payTranche } = ctx;

    await hub.createAdminProposal("Admin build", "Fund the team", "ipfs://admin-build");
    await hub.openBinaryVoting(1n);
    for (const supporter of [supporterOne, supporterTwo, supporterThree]) {
      await hub.connect(supporter).castBinaryVote(1n, 1, 100n);
    }
    await passVotingWindow();
    await hub.settleBinaryProposal(1n);
    await payTranche(1n);

    const creatorAfterInitialTranche = await token.balanceOf(creator.address);
    expect(creatorAfterInitialTranche).to.equal(60n);
    await networkHelpers.time.increase(24n * 60n * 60n + 2n);
    await networkHelpers.mine();
    await hub.failExpiredPlan(1n);

    let plan = await milestones.getPlan(1n);
    expect(plan.status).to.equal(6n); // Failed
    expect(plan.refundableAmount).to.equal(240n);
    expect(await treasury.totalMilestoneRefundLiability()).to.equal(240n);

    for (const supporter of [supporterOne, supporterTwo, supporterThree]) {
      const before = await token.balanceOf(supporter.address);
      await hub.connect(supporter).claimFailedPlanRefund(1n);
      expect(await token.balanceOf(supporter.address)).to.equal(before + 80n);
      await hub.connect(supporter).clearSettledVoteLock(1n);
    }
    expect(await treasury.totalMilestoneRefundLiability()).to.equal(0n);
  });

  it("settles slate and rejected-binary branches while preserving pull refunds and exit safety", async function () {
    const ctx = await deployCommunity();
    const { hub, supporterOne, supporterTwo, supporterThree, noVoter, exitingMember, token, reserve, treasury, voting, membership, networkHelpers, passVotingWindow } = ctx;

    await hub.createAdminSlateProposal("Slate A", "First slate option", "ipfs://slate-a");
    await hub.createAdminSlateProposal("Slate B", "Second slate option", "ipfs://slate-b");
    await hub.createAdminSlateRound([1n, 2n]);
    await hub.connect(supporterOne).castSlateRoundVote(1n, 1n, 100n);
    await hub.connect(supporterTwo).castSlateRoundVote(1n, 1n, 100n);
    await hub.connect(supporterThree).castSlateRoundVote(1n, 2n, 100n);
    expect((await hub.getSlateVote(1n, supporterThree.address)).proposalId).to.equal(2n);
    await passVotingWindow();
    await hub.settleSlateRound(1n);

    const round = await voting.getRound(1n);
    expect(round.winningProposalId).to.equal(1n);
    expect(round.winningVotes).to.equal(200n);
    expect(round.totalVotes).to.equal(300n);

    await hub.createAdminProposal("Rejected binary", "NO side wins", "ipfs://no-wins");
    await hub.openBinaryVoting(3n);
    await hub.connect(supporterOne).castBinaryVote(3n, 1, 50n);
    await hub.connect(noVoter).castBinaryVote(3n, 2, 100n);
    await passVotingWindow();
    await hub.settleBinaryProposal(3n);

    // The disclosed 10% rejection fee stays with BERT's reserve; the NO voter pulls the balance.
    expect(await treasury.totalRefundLiability()).to.equal(90n);
    expect(await token.balanceOf(await reserve.getAddress())).to.equal(60n);
    expect(await treasury.getRefundPreview(3n, noVoter.address)).to.deep.equal([90n, true]);
    const noVoterBefore = await token.balanceOf(noVoter.address);
    await treasury.connect(noVoter).claimNoVoteRefund(3n);
    expect(await token.balanceOf(noVoter.address)).to.equal(noVoterBefore + 90n);
    expect(await treasury.totalRefundLiability()).to.equal(0n);

    // An uninvolved Member can leave after the configured cooldown, whereas voters remain locked.
    await hub.connect(exitingMember).requestMembershipExit();
    await networkHelpers.time.increase(61n);
    await networkHelpers.mine();
    const exitingBalance = await token.balanceOf(exitingMember.address);
    await hub.connect(exitingMember).finalizeMembershipExit();
    expect(await token.balanceOf(exitingMember.address)).to.equal(exitingBalance + 10n);
    await expect(hub.connect(supporterOne).finalizeMembershipExit()).to.be.revertedWithCustomError(
      membership,
      "ExitNotRequested",
    );

    // Roster changes preserve role exclusivity and cannot strand a former Member.
    await hub.createAdminActionRequest(3, exitingMember.address, 0n); // AddAdmin
    await hub.executeAdminActionRequest(1n);
    expect(await hub.isAdminAccount(exitingMember.address)).to.equal(true);
    await hub.createAdminActionRequest(4, exitingMember.address, 0n); // RemoveAdmin
    await hub.executeAdminActionRequest(2n);
    expect(await hub.isAdminAccount(exitingMember.address)).to.equal(false);
  });

  it("supports the validated Member-slate lane and pauses time only through an Admin action", async function () {
    const ctx = await deployCommunity();
    const { ethers, hub, validator, author, noVoter, supporterOne, supporterTwo, supporterThree, milestones, voting, passVotingWindow } = ctx;

    await hub.connect(author).createMemberSlateProposal("Member slate", "Ship a scoped feature", "ipfs://member-slate");
    await hub.connect(noVoter).createMemberSlateProposal("Alternative slate", "Ship a second scoped feature", "ipfs://alternative-slate");
    await hub.connect(validator).castValidationDecision(1n, true);
    await hub.connect(validator).castValidationDecision(2n, true);
    await hub.createMemberSlateRound([1n, 2n]);
    expect(await hub.getRoundProposalIds(1n)).to.deep.equal([1n, 2n]);
    await hub.connect(supporterOne).castSlateRoundVote(1n, 1n, 100n);
    await hub.connect(supporterTwo).castSlateRoundVote(1n, 1n, 100n);
    await hub.connect(supporterThree).castSlateRoundVote(1n, 2n, 100n);
    await passVotingWindow();
    await hub.settleSlateRound(1n);

    const round = await voting.getRound(1n);
    expect(round.winningProposalId).to.equal(1n);
    expect((await milestones.getPlan(1n)).totalBudget).to.equal(270n);
    expect((await hub.getRound(1n)).settled).to.equal(true);

    // A one-admin Community still uses the same request -> approval -> execution path.
    await hub.createAdminActionRequest(0, ethers.ZeroAddress, 0n); // Pause
    await hub.executeAdminActionRequest(1n);
    expect(await hub.communityStatus()).to.equal(1n); // Paused

    await hub.createAdminActionRequest(1, ethers.ZeroAddress, 0n); // Unpause
    await hub.executeAdminActionRequest(2n);
    expect(await hub.communityStatus()).to.equal(0n); // Active

    // Losing slate voters never acquire a reviewer duty and may clear their vote lock immediately.
    await hub.connect(supporterThree).clearSettledRoundVoteLock(1n);
  });

  async function fundedQuorumPlan(memberOrigin = false) {
    const ctx = await deployCommunity(false, true);
    const { hub, author, validator, supporterOne, supporterTwo, supporterThree, passVotingWindow } = ctx;
    if (memberOrigin) {
      await hub.connect(author).createMemberProposal("Quorum build", "A protected payment plan", "ipfs://quorum");
      await hub.connect(validator).castValidationDecision(1n, true);
    } else await hub.createAdminProposal("Quorum build", "A protected payment plan", "ipfs://quorum");
    await hub.openBinaryVoting(1n);
    for (const supporter of [supporterOne, supporterTwo, supporterThree]) await hub.connect(supporter).castBinaryVote(1n, 1, 100n);
    await passVotingWindow();
    await hub.settleBinaryProposal(1n);
    return ctx;
  }

  it("requires separate current Admin quorum for all three tranches and permits a non-Admin payment relay", async function () {
    const { hub, milestones, treasury, token, creator, adminTwo, noVoter, supporterOne, supporterTwo, supporterThree, relay,
      passReviewWindow, payTranche } = await fundedQuorumPlan();
    const sorted = [creator.address, adminTwo.address].sort((a, b) => a.toLowerCase().localeCompare(b.toLowerCase()));
    expect((await milestones.getPlan(1n)).releasedAmount).to.equal(0n);
    expect(await token.balanceOf(creator.address)).to.equal(0n);
    expect(await treasury.totalMilestoneReserved()).to.equal(300n);
    await expect(hub.connect(noVoter).approveExecutionTranche(1n)).to.be.revertedWithCustomError(hub, "NotCommunityAdmin");
    await expect(hub.connect(noVoter).executeExecutionTranche(1n, sorted)).to.be.revertedWith("invalid tranche approver");
    await hub.approveExecutionTranche(1n);
    await expect(hub.approveExecutionTranche(1n)).to.be.revertedWith("tranche already approved");
    await expect(hub.executeExecutionTranche(1n, [creator.address])).to.be.revertedWith("tranche quorum not met");
    await hub.connect(adminTwo).approveExecutionTranche(1n);
    await expect(hub.executeExecutionTranche(1n, [creator.address, creator.address])).to.be.revertedWith("invalid tranche approver");
    await expect(hub.executeExecutionTranche(1n, [...sorted].reverse())).to.be.revertedWith("invalid tranche approver");
    expect((await hub.getMember(relay.address)).active).to.equal(false);
    await hub.connect(relay).executeExecutionTranche(1n, sorted);
    expect(await token.balanceOf(creator.address)).to.equal(60n);
    await expect(hub.executeExecutionTranche(1n, sorted)).to.be.revertedWith("tranche unavailable");

    for (const stage of [1n, 2n]) {
      await hub.submitMilestoneProof(1n, "0x" + "aa".repeat(32));
      for (const supporter of [supporterOne, supporterTwo, supporterThree]) await hub.connect(supporter).castMilestoneReview(1n, true);
      await passReviewWindow();
      await hub.finalizeMilestoneReview(1n);
      const plan = await milestones.getPlan(1n);
      expect(plan.status).to.equal(7n);
      expect(plan.releasedAmount).to.equal(stage === 1n ? 60n : 180n);
      expect(plan.proofDeadline).to.equal(0n);
      expect(await milestones.unresolvedPlanCount()).to.equal(1n);
      expect(await milestones.hasExecutionTrancheApproval(1n, stage, creator.address)).to.equal(false);
      await expect(hub.executeExecutionTranche(1n, sorted)).to.be.revertedWith("invalid tranche approver");
      await expect(hub.submitMilestoneProof(1n, "0x" + "bb".repeat(32))).to.be.revertedWith("proof unavailable");
      await payTranche(1n);
    }
    expect((await milestones.getPlan(1n)).status).to.equal(5n);
    expect(await milestones.unresolvedPlanCount()).to.equal(0n);
    expect(await token.balanceOf(creator.address)).to.equal(300n);
    expect(await treasury.totalMilestoneReserved()).to.equal(0n);
  });

  for (const expiryStage of [0, 1, 2]) {
    it(`refunds the entire unpaid Member execution budget at tranche ${expiryStage} expiry without consuming validator rewards`, async function () {
      const { hub, milestones, treasury, token, creator, adminTwo, noVoter, supporterOne, supporterTwo, supporterThree,
        networkHelpers, passReviewWindow, payTranche } = await fundedQuorumPlan(true);
      if (expiryStage > 0) await payTranche(1n);
      for (let stage = 1; stage <= expiryStage; stage += 1) {
        await hub.submitMilestoneProof(1n, "0x" + "cc".repeat(32));
        for (const supporter of [supporterOne, supporterTwo, supporterThree]) await hub.connect(supporter).castMilestoneReview(1n, true);
        await passReviewWindow();
        await hub.finalizeMilestoneReview(1n);
        if (stage < expiryStage) await payTranche(1n);
      }
      const plan = await milestones.getPlan(1n);
      const pending = await milestones.getExecutionTranche(1n, expiryStage);
      const unpaid = 270n - plan.releasedAmount;
      expect(unpaid).to.equal(expiryStage === 0 ? 270n : expiryStage === 1 ? 216n : 108n);
      await hub.approveExecutionTranche(1n);
      await hub.connect(adminTwo).approveExecutionTranche(1n);
      await expect(hub.connect(noVoter).expireExecutionTranche(1n)).to.be.revertedWith("tranche not expired");
      await networkHelpers.time.increaseTo(pending.expiresAt);
      const sorted = [creator.address, adminTwo.address].sort((a, b) => a.toLowerCase().localeCompare(b.toLowerCase()));
      await expect(hub.executeExecutionTranche(1n, sorted)).to.be.revertedWith("tranche expired");
      await expect(hub.approveExecutionTranche(1n)).to.be.revertedWith("tranche expired");
      await hub.connect(noVoter).expireExecutionTranche(1n);
      expect((await milestones.getPlan(1n)).refundableAmount).to.equal(unpaid);
      expect(await treasury.validatorRewardBalance()).to.equal(30n);
      for (const supporter of [supporterOne, supporterTwo, supporterThree]) {
        const before = await token.balanceOf(supporter.address);
        await hub.connect(supporter).claimFailedPlanRefund(1n);
        expect(await token.balanceOf(supporter.address)).to.equal(before + unpaid / 3n);
        await hub.connect(supporter).clearSettledVoteLock(1n);
      }
      expect(await treasury.totalMilestoneRefundLiability()).to.equal(0n);
      expect(await treasury.totalMilestoneReserved()).to.equal(0n);
      await expect(hub.executeExecutionTranche(1n, sorted)).to.be.revertedWith("tranche unavailable");
    });
  }

  it("invalidates removed and reappointed Admin approvals without restarting the tranche window", async function () {
    const { hub, milestones, creator, adminTwo, adminThree, noVoter } = await fundedQuorumPlan();
    const pending = await milestones.getExecutionTranche(1n, 0);
    await hub.approveExecutionTranche(1n);
    await hub.connect(adminTwo).approveExecutionTranche(1n);
    const sorted = [creator.address, adminTwo.address].sort((a, b) => a.toLowerCase().localeCompare(b.toLowerCase()));
    await hub.createAdminActionRequest(4, adminTwo.address, 0n);
    await hub.connect(adminThree).approveAdminActionRequest(1n);
    await hub.executeAdminActionRequest(1n);
    expect(await milestones.hasExecutionTrancheApproval(1n, 0, adminTwo.address)).to.equal(false);
    await expect(hub.connect(noVoter).executeExecutionTranche(1n, sorted)).to.be.revertedWith("invalid tranche approver");
    await hub.createAdminActionRequest(3, adminTwo.address, 0n);
    await hub.connect(adminThree).approveAdminActionRequest(2n);
    await hub.executeAdminActionRequest(2n);
    expect(await hub.adminRoleNonce(adminTwo.address)).to.equal(3n);
    expect(await milestones.hasExecutionTrancheApproval(1n, 0, adminTwo.address)).to.equal(false);
    await expect(hub.executeExecutionTranche(1n, sorted)).to.be.revertedWith("invalid tranche approver");
    await hub.connect(adminTwo).approveExecutionTranche(1n);
    expect((await milestones.getExecutionTrancheApprovers(1n, 0)).length).to.equal(2);
    expect((await milestones.getExecutionTranche(1n, 0)).expiresAt).to.equal(pending.expiresAt);
    await hub.connect(noVoter).executeExecutionTranche(1n, sorted);
  });

  it("freezes payment expiry while paused and starts the proof deadline only after actual payment", async function () {
    const { hub, milestones, creator, adminTwo, noVoter, ethers, networkHelpers, payTranche } = await fundedQuorumPlan();
    const request = await milestones.getExecutionTranche(1n, 0);
    await hub.createAdminActionRequest(0, ethers.ZeroAddress, 0n);
    await hub.connect(adminTwo).approveAdminActionRequest(1n);
    await hub.executeAdminActionRequest(1n);
    const frozen = await hub.communityTime();
    await networkHelpers.time.increase(10 * 24 * 60 * 60);
    expect(await hub.communityTime()).to.equal(frozen);
    await expect(hub.approveExecutionTranche(1n)).to.be.revertedWithCustomError(hub, "CommunityIsPaused");
    await expect(hub.connect(noVoter).expireExecutionTranche(1n)).to.be.revertedWithCustomError(hub, "CommunityIsPaused");
    await hub.createAdminActionRequest(1, ethers.ZeroAddress, 0n);
    await hub.connect(adminTwo).approveAdminActionRequest(2n);
    await hub.executeAdminActionRequest(2n);
    await networkHelpers.time.increase(5 * 24 * 60 * 60);
    await payTranche(1n);
    const plan = await milestones.getPlan(1n);
    expect(plan.proofDeadline).to.equal(await hub.communityTime() + 24n * 60n * 60n);
    expect(plan.proofDeadline).to.be.greaterThan(request.readyAt + 5n * 24n * 60n * 60n);
  });

  it("archives an idle Community through quorum and releases a pre-requested member exit", async function () {
    const ctx = await deployCommunity();
    const { hub, exitingMember, token, factory } = ctx;

    await expect(factory.getCommunity(0n)).to.be.revertedWithCustomError(factory, "InvalidId");

    await hub.connect(exitingMember).requestMembershipExit();
    await hub.createAdminActionRequest(2, "0x0000000000000000000000000000000000000000", 0n); // Archive
    await hub.executeAdminActionRequest(1n);
    expect(await hub.communityStatus()).to.equal(2n); // Archived

    const balanceBefore = await token.balanceOf(exitingMember.address);
    await hub.connect(exitingMember).finalizeMembershipExit();
    expect(await token.balanceOf(exitingMember.address)).to.equal(balanceBefore + 10n);
  });
});
