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
    expect(await treasury.paidTo(executionRecipient.address)).to.equal(20n);

    await hubCall(hub, manager, "submitMilestoneProof", [executionRecipient.address, planId, proofHash(1), await communityTime()]);
    await hubCall(hub, manager, "castMilestoneReview", [supporterOne.address, planId, true, await communityTime()]);
    await hubCall(hub, manager, "castMilestoneReview", [supporterTwo.address, planId, true, await communityTime()]);
    await hubCall(hub, manager, "castMilestoneReview", [supporterThree.address, planId, true, await communityTime()]);
    await networkHelpers.time.increase(Number(DAY));
    await networkHelpers.mine();
    await hubCall(hub, manager, "finalizeMilestoneReview", [planId, await reviewClose(manager, planId, 1n)]);
    expect(await treasury.paidTo(executionRecipient.address)).to.equal(60n);

    await hubCall(hub, manager, "submitMilestoneProof", [executionRecipient.address, planId, proofHash(2), await communityTime()]);
    await hubCall(hub, manager, "castMilestoneReview", [supporterOne.address, planId, true, await communityTime()]);
    await hubCall(hub, manager, "castMilestoneReview", [supporterTwo.address, planId, true, await communityTime()]);
    await hubCall(hub, manager, "castMilestoneReview", [supporterThree.address, planId, true, await communityTime()]);
    await networkHelpers.time.increase(Number(DAY));
    await networkHelpers.mine();
    await hubCall(hub, manager, "finalizeMilestoneReview", [planId, await reviewClose(manager, planId, 2n)]);

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
});
