import { expect, hre } from "../setup.js";

describe("V3.1 CommunityMilestoneManager", function () {
  const DAY = 24n * 60n * 60n;
  const proofHash = (value: number) => `0x${value.toString(16).padStart(64, "0")}`;

  async function deployManager() {
    const { ethers, networkHelpers } = await hre.network.connect();
    const [votingModule, executionRecipient, supporterOne, supporterTwo, supporterThree, outsider] =
      await ethers.getSigners();
    const treasury = await (
      await ethers.getContractFactory("MockCommunityMilestoneTreasury", votingModule)
    ).deploy();
    const hub = await (
      await ethers.getContractFactory("MockV3CommunityHub", votingModule)
    ).deploy();
    await hub.setAdmin(votingModule.address, true);
    const voting = await (
      await ethers.getContractFactory("MockCommunityMilestoneVoting", votingModule)
    ).deploy();
    const manager = await (
      await ethers.getContractFactory("CommunityMilestoneManager", votingModule)
    ).deploy(
      await hub.getAddress(),
      votingModule.address,
      executionRecipient.address,
      await treasury.getAddress(),
      await voting.getAddress(),
      DAY,
      14n * DAY,
    );

    return {
      votingModule,
      executionRecipient,
      supporterOne,
      supporterTwo,
      supporterThree,
      outsider,
      treasury,
      hub,
      voting,
      manager,
      networkHelpers,
    };
  }

  async function communityTime(): Promise<bigint> {
    const { networkHelpers } = await hre.network.connect();
    return BigInt(await networkHelpers.time.latest());
  }

  async function hubCall(hub: any, target: any, name: string, args: readonly unknown[]) {
    return hub.callTarget(await target.getAddress(), target.interface.encodeFunctionData(name, args));
  }

  async function reviewClose(manager: any, planId: bigint, milestone: bigint) {
    return (await manager.getReview(planId, milestone)).closesAt;
  }

  async function payTranche(hub: any, manager: any, planId: bigint) {
    const { ethers } = await hre.network.connect();
    const [admin] = await ethers.getSigners();
    const tranche = await manager.getExecutionTranche(planId, await manager.pendingTrancheByPlan(planId));
    const now = await communityTime();
    const time = now > tranche.readyAt ? now : tranche.readyAt;
    await hubCall(hub, manager, "approveExecutionTranche", [admin.address, planId, time]);
    await hubCall(hub, manager, "executeExecutionTranche", [planId, [admin.address], time]);
  }

  async function seedThreeSupporters(
    voting: any,
    planId: bigint,
    one: { address: string },
    two: { address: string },
    three: { address: string },
  ) {
    await voting.setVoter(planId, one.address, 34n);
    await voting.setVoter(planId, two.address, 33n);
    await voting.setVoter(planId, three.address, 33n);
  }

  it("releases 20/40/40 only after two passed full-duration supporter reviews", async function () {
    const {
      votingModule,
      executionRecipient,
      supporterOne,
      supporterTwo,
      supporterThree,
      treasury,
      voting,
      manager,
      networkHelpers, hub,
    } = await deployManager();
    const planId = 1n;
    const budget = 100n;
    await seedThreeSupporters(voting, planId, supporterOne, supporterTwo, supporterThree);
    await treasury.seedExecutionBalance(budget);

    await manager.connect(votingModule).startExecutionPlan(planId, budget, 100n, await communityTime());
    await payTranche(hub, manager, planId);
    expect(await treasury.paidTo(executionRecipient.address)).to.equal(20n);

    await hubCall(hub, manager, "submitMilestoneProof", [executionRecipient.address, planId, proofHash(1), await communityTime()]);
    await hubCall(hub, manager, "castMilestoneReview", [supporterOne.address, planId, true, await communityTime()]);
    await hubCall(hub, manager, "castMilestoneReview", [supporterTwo.address, planId, true, await communityTime()]);
    await hubCall(hub, manager, "castMilestoneReview", [supporterThree.address, planId, true, await communityTime()]);
    await networkHelpers.time.increase(Number(DAY));
    await networkHelpers.mine();
    await hubCall(hub, manager, "finalizeMilestoneReview", [planId, await reviewClose(manager, planId, 1n)]);
    await payTranche(hub, manager, planId);
    expect(await treasury.paidTo(executionRecipient.address)).to.equal(60n);

    await hubCall(hub, manager, "submitMilestoneProof", [executionRecipient.address, planId, proofHash(2), await communityTime()]);
    await hubCall(hub, manager, "castMilestoneReview", [supporterOne.address, planId, true, await communityTime()]);
    await hubCall(hub, manager, "castMilestoneReview", [supporterTwo.address, planId, true, await communityTime()]);
    await hubCall(hub, manager, "castMilestoneReview", [supporterThree.address, planId, true, await communityTime()]);
    await networkHelpers.time.increase(Number(DAY));
    await networkHelpers.mine();
    await hubCall(hub, manager, "finalizeMilestoneReview", [planId, await reviewClose(manager, planId, 2n)]);
    await payTranche(hub, manager, planId);

    const plan = await manager.getPlan(planId);
    expect(plan.status).to.equal(5n); // Completed
    expect(plan.releasedAmount).to.equal(budget);
    expect(await treasury.paidTo(executionRecipient.address)).to.equal(budget);
  });

  it("allows one corrected proof and gives every supporter a fresh review vote", async function () {
    const {
      votingModule,
      executionRecipient,
      supporterOne,
      supporterTwo,
      supporterThree,
      treasury,
      voting,
      manager,
      networkHelpers,
      hub,
    } = await deployManager();
    const planId = 2n;
    await seedThreeSupporters(voting, planId, supporterOne, supporterTwo, supporterThree);
    await treasury.seedExecutionBalance(100n);
    await manager.connect(votingModule).startExecutionPlan(planId, 100n, 100n, await communityTime());
    await payTranche(hub, manager, planId);

    await hubCall(hub, manager, "submitMilestoneProof", [executionRecipient.address, planId, proofHash(3), await communityTime()]);
    await hubCall(hub, manager, "castMilestoneReview", [supporterOne.address, planId, true, await communityTime()]);
    await hubCall(hub, manager, "castMilestoneReview", [supporterTwo.address, planId, false, await communityTime()]);
    await hubCall(hub, manager, "castMilestoneReview", [supporterThree.address, planId, false, await communityTime()]);
    await networkHelpers.time.increase(Number(DAY));
    await networkHelpers.mine();
    await hubCall(hub, manager, "finalizeMilestoneReview", [planId, await reviewClose(manager, planId, 1n)]);
    expect((await manager.getPlan(planId)).status).to.equal(3n); // CorrectionCooldown

    await networkHelpers.time.increase(48 * 60 * 60);
    await networkHelpers.mine();
    const correctionTime = (await manager.getReview(planId, 1n)).correctionAvailableAt;
    await hubCall(hub, manager, "reopenAfterCorrection", [executionRecipient.address, planId, correctionTime]);
    await hubCall(hub, manager, "submitMilestoneProof", [executionRecipient.address, planId, proofHash(4), await communityTime()]);
    await hubCall(hub, manager, "castMilestoneReview", [supporterOne.address, planId, true, await communityTime()]);
    await hubCall(hub, manager, "castMilestoneReview", [supporterTwo.address, planId, true, await communityTime()]);
    await hubCall(hub, manager, "castMilestoneReview", [supporterThree.address, planId, true, await communityTime()]);
    await networkHelpers.time.increase(Number(DAY));
    await networkHelpers.mine();
    await hubCall(hub, manager, "finalizeMilestoneReview", [planId, await reviewClose(manager, planId, 1n)]);

    await payTranche(hub, manager, planId);
    expect((await manager.getPlan(planId)).status).to.equal(1n); // AwaitingProof for milestone 2
    expect(await treasury.paidTo(executionRecipient.address)).to.equal(60n);
  });

  it("fails after the no-quorum grace period and returns the entire unreleased budget without dust", async function () {
    const {
      votingModule,
      executionRecipient,
      supporterOne,
      supporterTwo,
      supporterThree,
      treasury,
      voting,
      manager,
      networkHelpers,
      hub,
    } = await deployManager();
    const planId = 3n;
    await seedThreeSupporters(voting, planId, supporterOne, supporterTwo, supporterThree);
    await treasury.seedExecutionBalance(101n);
    await manager.connect(votingModule).startExecutionPlan(planId, 101n, 100n, await communityTime());
    await payTranche(hub, manager, planId);

    await hubCall(hub, manager, "submitMilestoneProof", [executionRecipient.address, planId, proofHash(5), await communityTime()]);
    await hubCall(hub, manager, "castMilestoneReview", [supporterOne.address, planId, true, await communityTime()]); // 34% < 40% quorum
    await networkHelpers.time.increase(Number(DAY));
    await networkHelpers.mine();
    await hubCall(hub, manager, "finalizeMilestoneReview", [planId, await reviewClose(manager, planId, 1n)]);
    expect((await manager.getPlan(planId)).status).to.equal(4n); // GraceReview

    await networkHelpers.time.increase(2 * 24 * 60 * 60);
    await networkHelpers.mine();
    await hubCall(hub, manager, "finalizeMilestoneReview", [planId, await reviewClose(manager, planId, 1n)]);
    expect((await manager.getPlan(planId)).status).to.equal(6n); // Failed
    expect(await treasury.refundsByPlan(planId)).to.equal(81n);

    await hubCall(hub, manager, "claimFailedPlanRefund", [supporterOne.address, planId]);
    await hubCall(hub, manager, "claimFailedPlanRefund", [supporterTwo.address, planId]);
    await hubCall(hub, manager, "claimFailedPlanRefund", [supporterThree.address, planId]);

    expect(await treasury.paidTo(supporterOne.address)).to.equal(27n);
    expect(await treasury.paidTo(supporterTwo.address)).to.equal(26n);
    expect(await treasury.paidTo(supporterThree.address)).to.equal(28n);
    expect(await treasury.refundsByPlan(planId)).to.equal(0n);
  });

  for (const executorClaimsLast of [false, true]) {
    it(`preserves executor financial refunds with the original denominator and dust when claiming ${executorClaimsLast ? "last" : "first"}`, async function () {
      const { executionRecipient, supporterOne, supporterTwo, supporterThree, outsider, treasury, voting, manager, hub } = await deployManager();
      await voting.setVoter(1n, executionRecipient.address, 50n);
      for (const supporter of [supporterOne, supporterTwo, supporterThree]) await voting.setVoter(1n, supporter.address, 17n);
      await treasury.seedExecutionBalance(101n);
      await manager.startExecutionPlan(1n, 101n, 101n, await communityTime());
      await payTranche(hub, manager, 1n);
      expect((await manager.getPlan(1n)).eligibleSupportWeight).to.equal(51n);
      expect(await manager.totalSupportWeightByPlan(1n)).to.equal(101n);
      expect(await manager.eligibleReviewerCountByPlan(1n)).to.equal(3n);
      const plan = await manager.getPlan(1n);
      await hubCall(hub, manager, "failExpiredPlan", [1n, plan.proofDeadline + 1n]);
      await expect(hubCall(hub, manager, "claimFailedPlanRefund", [outsider.address, 1n])).to.be.revertedWith("not winning supporter");
      const others = [supporterOne, supporterTwo, supporterThree];
      const claimers = executorClaimsLast ? [...others, executionRecipient] : [executionRecipient, ...others];
      let refunded = 0n;
      for (const [index, supporter] of claimers.entries()) {
        const weight = supporter === executionRecipient ? 50n : 17n;
        const amount = index === claimers.length - 1 ? 81n - refunded : (81n * weight) / 101n;
        const before = await treasury.paidTo(supporter.address);
        await hubCall(hub, manager, "claimFailedPlanRefund", [supporter.address, 1n]);
        expect(await treasury.paidTo(supporter.address)).to.equal(before + amount);
        expect(await manager.canReleaseReviewerLock(1n, supporter.address)).to.equal(true);
        await expect(hubCall(hub, manager, "claimFailedPlanRefund", [supporter.address, 1n])).to.be.revertedWith("refund unavailable");
        refunded += amount;
      }
      expect(refunded).to.equal(81n);
      expect(await treasury.refundsByPlan(1n)).to.equal(0n);
      expect(await manager.refundPaidByPlan(1n)).to.equal(81n);
    });
  }

  it("excludes the executor from the ceil(3%) count at the 100-reviewer boundary", async function () {
    const { executionRecipient, supporterOne, supporterTwo, supporterThree, treasury, voting, manager, hub } = await deployManager();
    await voting.setVoter(1n, executionRecipient.address, 1_000n);
    for (const supporter of [supporterOne, supporterTwo, supporterThree]) await voting.setVoter(1n, supporter.address, 40n);
    for (let index = 0; index < 97; index += 1) {
      await voting.setVoter(1n, `0x${(index + 100).toString(16).padStart(40, "0")}`, 1n);
    }
    await treasury.seedExecutionBalance(100n);
    await manager.startExecutionPlan(1n, 100n, 1_217n, await communityTime());
    await payTranche(hub, manager, 1n);
    expect(await voting.milestoneVoterCount(1n)).to.equal(101n);
    expect(await manager.eligibleReviewerCountByPlan(1n)).to.equal(100n);
    expect((await manager.getPlan(1n)).eligibleSupportWeight).to.equal(217n);
    const now = await communityTime();
    await hubCall(hub, manager, "submitMilestoneProof", [executionRecipient.address, 1n, proofHash(11), now]);
    for (const supporter of [supporterOne, supporterTwo, supporterThree]) {
      await hubCall(hub, manager, "castMilestoneReview", [supporter.address, 1n, true, now]);
    }
    await hubCall(hub, manager, "finalizeMilestoneReview", [1n, await reviewClose(manager, 1n, 1n)]);
    await payTranche(hub, manager, 1n);
    expect((await manager.getPlan(1n)).releasedAmount).to.equal(60n);
  });

  it("keeps the three-independent-approver floor when the executor was one of three supporters", async function () {
    const { executionRecipient, supporterOne, supporterTwo, treasury, voting, manager, hub } = await deployManager();
    for (const supporter of [executionRecipient, supporterOne, supporterTwo]) await voting.setVoter(1n, supporter.address, 100n);
    await treasury.seedExecutionBalance(100n);
    await manager.startExecutionPlan(1n, 100n, 300n, await communityTime());
    await payTranche(hub, manager, 1n);
    const now = await communityTime();
    await hubCall(hub, manager, "submitMilestoneProof", [executionRecipient.address, 1n, proofHash(12), now]);
    for (const supporter of [supporterOne, supporterTwo]) {
      await hubCall(hub, manager, "castMilestoneReview", [supporter.address, 1n, true, now]);
    }
    await hubCall(hub, manager, "finalizeMilestoneReview", [1n, await reviewClose(manager, 1n, 1n)]);
    expect((await manager.getPlan(1n)).status).to.equal(3n);
    expect(await treasury.paidTo(executionRecipient.address)).to.equal(20n);
  });

  it("settles an executor-only winner without trapping escrow, then fails zero-reviewer quorum and refunds", async function () {
    const { executionRecipient, treasury, voting, manager, hub } = await deployManager();
    await voting.setVoter(1n, executionRecipient.address, 100n);
    await treasury.seedExecutionBalance(100n);
    await manager.startExecutionPlan(1n, 100n, 100n, await communityTime());
    await payTranche(hub, manager, 1n);
    expect((await manager.getPlan(1n)).eligibleSupportWeight).to.equal(0n);
    expect(await manager.eligibleReviewerCountByPlan(1n)).to.equal(0n);
    const now = await communityTime();
    await hubCall(hub, manager, "submitMilestoneProof", [executionRecipient.address, 1n, proofHash(13), now]);
    await expect(hubCall(hub, manager, "castMilestoneReview", [executionRecipient.address, 1n, true, now]))
      .to.be.revertedWith("execution recipient cannot review");
    await hubCall(hub, manager, "finalizeMilestoneReview", [1n, await reviewClose(manager, 1n, 1n)]);
    expect((await manager.getPlan(1n)).status).to.equal(4n);
    await hubCall(hub, manager, "finalizeMilestoneReview", [1n, await reviewClose(manager, 1n, 1n)]);
    expect((await manager.getPlan(1n)).status).to.equal(6n);
    await hubCall(hub, manager, "claimFailedPlanRefund", [executionRecipient.address, 1n]);
    expect(await treasury.paidTo(executionRecipient.address)).to.equal(100n);
    expect(await treasury.refundsByPlan(1n)).to.equal(0n);
  });

  it("rolls back a failed transfer without consuming the quorum-approved authorization", async function () {
    const { votingModule, executionRecipient, supporterOne, supporterTwo, supporterThree, treasury, voting, manager, hub } = await deployManager();
    await seedThreeSupporters(voting, 1n, supporterOne, supporterTwo, supporterThree);
    await treasury.seedExecutionBalance(100n);
    const now = await communityTime();
    await manager.startExecutionPlan(1n, 100n, 100n, now);
    await hubCall(hub, manager, "approveExecutionTranche", [votingModule.address, 1n, now]);
    await treasury.setRejectRelease(true);
    await expect(hubCall(hub, manager, "executeExecutionTranche", [1n, [votingModule.address], now])).to.be.revertedWith("release rejected");
    expect((await manager.getPlan(1n)).releasedAmount).to.equal(0n);
    expect((await manager.getExecutionTranche(1n, 0)).paid).to.equal(false);
    expect(await manager.hasExecutionTrancheApproval(1n, 0, votingModule.address)).to.equal(true);
    expect(await treasury.reservedByPlan(1n)).to.equal(100n);
    await treasury.setRejectRelease(false);
    await hubCall(hub, manager, "executeExecutionTranche", [1n, [votingModule.address], now]);
    expect(await treasury.paidTo(executionRecipient.address)).to.equal(20n);
  });

  it("advances a zero-rounded initial tranche without a zero-value Treasury transfer", async function () {
    const { supporterOne, supporterTwo, supporterThree, treasury, voting, manager, hub } = await deployManager();
    await seedThreeSupporters(voting, 1n, supporterOne, supporterTwo, supporterThree);
    await treasury.seedExecutionBalance(1n);
    await manager.startExecutionPlan(1n, 1n, 100n, await communityTime());
    await treasury.setRejectRelease(true);
    await payTranche(hub, manager, 1n);
    expect((await manager.getExecutionTranche(1n, 0)).paid).to.equal(true);
    expect((await manager.getPlan(1n)).releasedAmount).to.equal(0n);
    expect((await manager.getPlan(1n)).status).to.equal(1n);
    expect(await treasury.reservedByPlan(1n)).to.equal(1n);
  });

  it("rejects executor approvals and rejections after correction and during grace without mutating review totals", async function () {
    const { executionRecipient, supporterOne, supporterTwo, supporterThree, treasury, voting, manager, hub } = await deployManager();
    await seedThreeSupporters(voting, 1n, supporterOne, supporterTwo, supporterThree);
    await voting.setVoter(1n, executionRecipient.address, 900n);
    await treasury.seedExecutionBalance(100n);
    await manager.startExecutionPlan(1n, 100n, 1_000n, await communityTime());
    await payTranche(hub, manager, 1n);
    const now = await communityTime();
    await hubCall(hub, manager, "submitMilestoneProof", [executionRecipient.address, 1n, proofHash(14), now]);
    for (const supporter of [supporterOne, supporterTwo, supporterThree]) {
      await hubCall(hub, manager, "castMilestoneReview", [supporter.address, 1n, false, now]);
    }
    await hubCall(hub, manager, "finalizeMilestoneReview", [1n, await reviewClose(manager, 1n, 1n)]);
    const correctionAt = (await manager.getReview(1n, 1n)).correctionAvailableAt;
    await hubCall(hub, manager, "reopenAfterCorrection", [executionRecipient.address, 1n, correctionAt]);
    await hubCall(hub, manager, "submitMilestoneProof", [executionRecipient.address, 1n, proofHash(15), correctionAt]);
    for (const approved of [true, false]) {
      await expect(hubCall(hub, manager, "castMilestoneReview", [executionRecipient.address, 1n, approved, correctionAt]))
        .to.be.revertedWith("execution recipient cannot review");
    }
    await hubCall(hub, manager, "finalizeMilestoneReview", [1n, await reviewClose(manager, 1n, 1n)]);
    const grace = await manager.getReview(1n, 1n);
    expect((await manager.getPlan(1n)).status).to.equal(4n);
    for (const approved of [true, false]) {
      await expect(hubCall(hub, manager, "castMilestoneReview", [executionRecipient.address, 1n, approved, grace.openedAt]))
        .to.be.revertedWith("execution recipient cannot review");
    }
    const review = await manager.getReview(1n, 1n);
    expect(review.approvingWeight).to.equal(0n);
    expect(review.rejectingWeight).to.equal(0n);
    expect(review.approvingAddresses).to.equal(0n);
    expect(review.participatingAddresses).to.equal(0n);
  });
});
