import { expect, hre } from "../setup.js";
import { deployTransparentUpgradeable } from "../helpers.js";

/**
 * These tests deliberately use the production Hub/Factory/module wiring instead
 * of module mocks. They protect the cross-contract accounting invariants that
 * unit tests cannot observe: vote escrow, plan reserves, reviewer eligibility,
 * tranche releases, and failed-plan pull refunds.
 */
describe("V3.1 Community end-to-end lifecycle", function () {
  async function deployCommunity() {
    const { ethers, networkHelpers } = await hre.network.connect();
    const [creator, validator, author, supporterOne, supporterTwo, supporterThree, noVoter, exitingMember] =
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
      initialAdmins: [creator.address],
      initialValidators: [validator.address],
      entryStakeUSDC: 10n,
      proposalBondUSDC: 5n,
      voteMinStakeUSDC: 1n,
      membershipExitCooldown: 60n,
      validatorApprovalThreshold: 1n,
      adminApprovalThreshold: 1n,
      binaryRejectionFeeBps: 1_000n,
      validatorRewardShareBps: 1_000n,
      validationWindow: 60n * 60n,
      binaryVotingDuration: 60n * 60n,
      roundVotingDuration: 60n * 60n,
      validatorRewardEpoch: 60n * 60n,
      validatorActiveThresholdBps: 5_000n,
      validatorProposalPointsThreshold: 1n,
      executionRecipient: creator.address,
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

    return {
      ethers,
      networkHelpers,
      creator,
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
    };
  }

  it("settles a validated Member proposal through both supporter-approved milestones", async function () {
    const ctx = await deployCommunity();
    const { hub, validator, author, supporterOne, supporterTwo, supporterThree, creator, token, milestones, treasury, networkHelpers, passVotingWindow, passReviewWindow } = ctx;

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
    const { hub, supporterOne, supporterTwo, supporterThree, creator, token, milestones, treasury, networkHelpers, passVotingWindow } = ctx;

    await hub.createAdminProposal("Admin build", "Fund the team", "ipfs://admin-build");
    await hub.openBinaryVoting(1n);
    for (const supporter of [supporterOne, supporterTwo, supporterThree]) {
      await hub.connect(supporter).castBinaryVote(1n, 1, 100n);
    }
    await passVotingWindow();
    await hub.settleBinaryProposal(1n);

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
