/**
 * @file FundingRounds.fully.ts
 * @notice End-to-end tests for BERT V2 stake-backed funding rounds.
 */

import { expect } from "./setup.js";
import { deploySystem } from "./helpers.js";

describe("BERT V2 funding rounds", function () {
  async function createFundingProposals(system: any, minimumA: bigint, minimumB: bigint) {
    const { ideaRegistry, user3, user4 } = system;

    await ideaRegistry
      .connect(user3)
      .createFundingProposal("Proposal A", "Funding proposal A", "", 1n, minimumA);
    await ideaRegistry
      .connect(user4)
      .createFundingProposal("Proposal B", "Funding proposal B", "", 1n, minimumB);
    await ideaRegistry
      .connect(user3)
      .createFundingProposal("Proposal C", "Funding proposal C", "", 1n, 1n);
    await ideaRegistry
      .connect(user4)
      .createFundingProposal("Proposal D", "Funding proposal D", "", 1n, 1n);
    await ideaRegistry
      .connect(user3)
      .createFundingProposal("Proposal E", "Funding proposal E", "", 1n, 1n);
  }

  it("funds the highest viable proposal, finalizes its fee on claim, and refunds losing pledges", async function () {
    const system = await deploySystem();
    const {
      admin,
      user1,
      user2,
      user3,
      ideaRegistry,
      votingSystem,
      fundingPool,
      grantManager,
      usdc,
      networkHelpers,
      ethers,
    } = system;

    const unit = 10n ** 6n;
    const winnerPledge = 100n * unit;
    const loserPledge = 70n * unit;

    await fundingPool.connect(admin).unpause();
    await votingSystem.connect(admin).unpause();
    await grantManager.connect(admin).unpause();
    await fundingPool.connect(admin).setPledgeFeeBps(500);

    // Proposal A needs 80 USDC after the configured 5% fee; 100 gross makes it viable.
    await createFundingProposals(system, 80n * unit, 60n * unit);
    await votingSystem.connect(admin).setIdeaPerRound(5);
    await votingSystem.startFundingRound();

    await votingSystem.connect(user1).vote(1n, 1n, winnerPledge);
    await votingSystem.connect(user2).vote(1n, 2n, loserPledge);

    const round = await votingSystem.getRoundInfo(1n);
    await networkHelpers.time.increaseTo(Number(round[3]) + 1);
    await votingSystem.endVotingRound(1n);

    const winner = await votingSystem.getRoundWinner(1n);
    expect(winner[0]).to.equal(1n);
    expect(await fundingPool.poolByRoundAndIdea(1n, 1n)).to.equal(95n * unit);
    // Before grant claim, only losing author bonds enter reserve. The success fee stays refundable in escrow.
    expect(await fundingPool.protocolReserve()).to.equal(4n);

    const beforeRefund = await usdc.balanceOf(user2.address);
    await fundingPool.connect(user2).claimPledgeRefund(1n);
    expect(await usdc.balanceOf(user2.address)).to.equal(beforeRefund + loserPledge);
    await expect(fundingPool.connect(user2).claimPledgeRefund(1n))
      .to.be.revertedWithCustomError(fundingPool, "PledgeRefundAlreadyClaimed");

    const beforeGrant = await usdc.balanceOf(user3.address);
    await grantManager.connect(user3).claimGrant(1n);
    expect(await fundingPool.protocolReserve()).to.equal(5n * unit + 4n);
    // The author receives the returned 1-USDC bond plus the first 30% milestone tranche of 95 USDC.
    expect(await usdc.balanceOf(user3.address)).to.equal(beforeGrant + 1n + (95n * unit * 30n) / 100n);
    expect(await ideaRegistry.getStatus(1n)).to.equal(3n);
  });

  it("refunds every pledge when no proposal reaches its minimum net funding", async function () {
    const system = await deploySystem();
    const {
      admin,
      user1,
      user2,
      ideaRegistry,
      votingSystem,
      fundingPool,
      networkHelpers,
    } = system;

    const unit = 10n ** 6n;
    const firstPledge = 50n * unit;
    const secondPledge = 40n * unit;

    await fundingPool.connect(admin).unpause();
    await votingSystem.connect(admin).unpause();
    await fundingPool.connect(admin).setPledgeFeeBps(500);

    await createFundingProposals(system, 80n * unit, 80n * unit);
    await votingSystem.connect(admin).setIdeaPerRound(5);
    await votingSystem.startFundingRound();
    await votingSystem.connect(user1).vote(1n, 1n, firstPledge);
    await votingSystem.connect(user2).vote(1n, 2n, secondPledge);

    const round = await votingSystem.getRoundInfo(1n);
    await networkHelpers.time.increaseTo(Number(round[3]) + 1);
    await votingSystem.endVotingRound(1n);

    expect((await votingSystem.getRoundWinner(1n))[0]).to.equal(0n);
    expect(await ideaRegistry.getStatus(1n)).to.equal(4n);
    expect(await ideaRegistry.getStatus(2n)).to.equal(4n);

    const user1Before = await system.usdc.balanceOf(user1.address);
    const user2Before = await system.usdc.balanceOf(user2.address);
    await fundingPool.connect(user1).claimPledgeRefund(1n);
    await fundingPool.connect(user2).claimPledgeRefund(1n);
    expect(await system.usdc.balanceOf(user1.address)).to.equal(user1Before + firstPledge);
    expect(await system.usdc.balanceOf(user2.address)).to.equal(user2Before + secondPledge);
  });

  it("selects a viable runner-up instead of an underfunded top pledge", async function () {
    const system = await deploySystem();
    const { admin, user1, user2, votingSystem, fundingPool, networkHelpers } = system;
    const unit = 10n ** 6n;

    await fundingPool.connect(admin).unpause();
    await votingSystem.connect(admin).unpause();
    await fundingPool.connect(admin).setPledgeFeeBps(500);

    // Proposal A leads in gross support but misses its 96-USDC post-fee minimum.
    // Proposal B has less support, yet clears its own viable 80-USDC minimum.
    await createFundingProposals(system, 96n * unit, 80n * unit);
    await votingSystem.connect(admin).setIdeaPerRound(5);
    await votingSystem.startFundingRound();
    await votingSystem.connect(user1).vote(1n, 1n, 100n * unit);
    await votingSystem.connect(user2).vote(1n, 2n, 90n * unit);

    const round = await votingSystem.getRoundInfo(1n);
    await networkHelpers.time.increaseTo(Number(round[3]) + 1);
    await votingSystem.endVotingRound(1n);

    expect((await votingSystem.getRoundWinner(1n))[0]).to.equal(2n);
    expect(await fundingPool.poolByRoundAndIdea(1n, 2n)).to.equal(85_500_000n);
  });

  it("locks the success fee when the round starts", async function () {
    const system = await deploySystem();
    const { admin, user1, user2, votingSystem, fundingPool, networkHelpers } = system;
    const unit = 10n ** 6n;

    await fundingPool.connect(admin).unpause();
    await votingSystem.connect(admin).unpause();
    await fundingPool.connect(admin).setPledgeFeeBps(500);

    // At 5%, proposal A nets exactly 95 USDC and is the highest viable pledge.
    await createFundingProposals(system, 95n * unit, 80n * unit);
    await votingSystem.connect(admin).setIdeaPerRound(5);
    await votingSystem.startFundingRound();
    expect(await fundingPool.fundingRoundFeeBps(1n)).to.equal(500n);

    // A later configuration change must affect only a future round.
    await fundingPool.connect(admin).setPledgeFeeBps(1_000);
    await votingSystem.connect(user1).vote(1n, 1n, 100n * unit);
    await votingSystem.connect(user2).vote(1n, 2n, 90n * unit);

    const round = await votingSystem.getRoundInfo(1n);
    await networkHelpers.time.increaseTo(Number(round[3]) + 1);
    await votingSystem.endVotingRound(1n);

    expect((await votingSystem.getRoundWinner(1n))[0]).to.equal(1n);
    expect(await fundingPool.poolByRoundAndIdea(1n, 1n)).to.equal(95n * unit);
  });
});
