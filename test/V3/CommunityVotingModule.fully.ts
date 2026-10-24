import { expect, hre } from "../setup.js";

describe("V3.1 CommunityVotingModule", function () {
  it("settles binary escrow into a protected supporter-reviewed execution plan", async function () {
    const { ethers } = await hre.network.connect();
    const [deployer, admin, validator, supporter, opponent, executor] = await ethers.getSigners();
    const token = await (await ethers.getContractFactory("MockUSDC", deployer)).deploy();
    const reserve = await (await ethers.getContractFactory("MockV3GlobalBertReserve", deployer)).deploy(await token.getAddress());
    const verifier = await (await ethers.getContractFactory("MockHumanVerifier", deployer)).deploy();
    const factory = await (await ethers.getContractFactory("MockV3CommunityFactory", deployer)).deploy(await verifier.getAddress());
    const hub = await (await ethers.getContractFactory("MockV3CommunityHub", deployer)).deploy();
    const treasury = await (await ethers.getContractFactory("CommunityTreasury", deployer)).deploy(
      await token.getAddress(), await reserve.getAddress(), await factory.getAddress(),
    );
    const membership = await (await ethers.getContractFactory("CommunityMembershipModule", deployer)).deploy(
      await hub.getAddress(), await treasury.getAddress(), await verifier.getAddress(), 1n, 1n, 1n,
      [admin.address], [validator.address],
    );
    const proposal = await (await ethers.getContractFactory("CommunityProposalModule", deployer)).deploy(
      await hub.getAddress(), await treasury.getAddress(), await membership.getAddress(), 5n, 1n, 1n, 1n, 5_000n, 100n,
    );
    const voting = await (await ethers.getContractFactory("CommunityVotingModule", deployer)).deploy(
      await hub.getAddress(), await treasury.getAddress(), await membership.getAddress(), await proposal.getAddress(),
      1n, 1n, 1n, 500n, 0n,
    );
    const snapshot = await (await ethers.getContractFactory("CommunityWinnerSnapshot", deployer)).deploy(await voting.getAddress());
    const manager = await (await ethers.getContractFactory("CommunityMilestoneManager", deployer)).deploy(
      await hub.getAddress(), await voting.getAddress(), executor.address, await treasury.getAddress(), await snapshot.getAddress(), 24n * 60n * 60n, 14n * 24n * 60n * 60n,
    );

    async function factoryCall(name: string, args: readonly unknown[]) {
      return factory.callTarget(await treasury.getAddress(), treasury.interface.encodeFunctionData(name, args));
    }
    async function hubCall(contract: any, name: string, args: readonly unknown[]) {
      return hub.callTarget(await contract.getAddress(), contract.interface.encodeFunctionData(name, args));
    }

    await factoryCall("setCommunityHub", [await hub.getAddress()]);
    await factoryCall("setV31Modules", [await membership.getAddress(), await proposal.getAddress(), await voting.getAddress()]);
    await factoryCall("setMilestoneManager", [await manager.getAddress()]);
    await hubCall(membership, "setOperationalModules", [await proposal.getAddress(), await voting.getAddress()]);
    await hubCall(proposal, "setVotingModule", [await voting.getAddress()]);
    await hubCall(voting, "setMilestoneModules", [await snapshot.getAddress(), await manager.getAddress()]);
    await expect(hubCall(voting, "setMilestoneModules", [await snapshot.getAddress(), await manager.getAddress()]))
      .to.be.revertedWithCustomError(voting, "CommunityV31ModulesAlreadyConfigured");
    await expect(voting.getRound(0n)).to.be.revertedWithCustomError(voting, "CommunityRoundNotFound");

    for (const member of [supporter, opponent]) {
      await verifier.setVerified(member.address, true);
      await token.mint(member.address, 100n);
      await token.connect(member).approve(await treasury.getAddress(), 100n);
      await hubCall(membership, "join", [member.address, 100n]);
    }

    await hubCall(proposal, "createAdminBinary", [admin.address, "Build", "Ship the agreed work", "ipfs://build", 101n]);
    await expect(hubCall(voting, "openBinaryVoting", [supporter.address, 1n, 102n]))
      .to.be.revertedWithCustomError(voting, "NotCommunityAdmin");
    await expect(hubCall(voting, "castBinaryVote", [supporter.address, 1n, 1, 40n, 102n]))
      .to.be.revertedWithCustomError(voting, "VotingNotOpen");
    await hubCall(voting, "openBinaryVoting", [admin.address, 1n, 102n]);
    await expect(hubCall(voting, "settleBinaryProposal", [1n, 102n]))
      .to.be.revertedWithCustomError(voting, "VotingStillOpen");
    await expect(hubCall(voting, "castBinaryVote", [supporter.address, 1n, 0, 40n, 102n]))
      .to.be.revertedWithCustomError(voting, "InvalidVoteChoice");
    await expect(hubCall(voting, "castBinaryVote", [supporter.address, 1n, 1, 0n, 102n]))
      .to.be.revertedWithCustomError(voting, "VoteStakeTooLow");
    await hubCall(voting, "castBinaryVote", [supporter.address, 1n, 1, 40n, 102n]);
    await expect(hubCall(voting, "castBinaryVote", [supporter.address, 1n, 1, 1n, 102n]))
      .to.be.revertedWithCustomError(voting, "BinaryVoteAlreadyCast");
    await hubCall(voting, "castBinaryVote", [opponent.address, 1n, 2, 10n, 102n]);

    await hubCall(voting, "settleBinaryProposal", [1n, 103n]);
    await expect(hubCall(voting, "settleBinaryProposal", [1n, 104n]))
      .to.be.revertedWithCustomError(voting, "InvalidProposalState");

    const plan = await manager.getPlan(1n);
    expect(plan.totalBudget).to.equal(40n);
    expect(plan.releasedAmount).to.equal(0n);
    expect(plan.status).to.equal(7n);
    expect(plan.eligibleSupportWeight).to.equal(40n);
    expect(await token.balanceOf(executor.address)).to.equal(0n);
    expect(await treasury.totalMilestoneReserved()).to.equal(40n);
    expect(await reserve.received()).to.equal(10n);
    expect(await snapshot.milestoneVoterWeight(1n, supporter.address)).to.equal(40n);
    expect(await snapshot.milestoneVoterWeight(1n, opponent.address)).to.equal(0n);

    await expect(hubCall(voting, "clearSettledBinaryVoteLock", [supporter.address, 1n]))
      .to.be.revertedWithCustomError(voting, "MembershipExitBlocked");
    await hubCall(voting, "clearSettledBinaryVoteLock", [opponent.address, 1n]);
    expect(await voting.hasExitBlockingObligation(opponent.address)).to.equal(false);
    await expect(hubCall(voting, "clearSettledBinaryVoteLock", [opponent.address, 1n]))
      .to.be.revertedWithCustomError(voting, "VoteLockAlreadyCleared");
    await hubCall(membership, "requestExit", [opponent.address, 104n]);
    await hubCall(membership, "finalizeExit", [opponent.address, 106n, false]);
    expect((await membership.getMember(opponent.address)).active).to.equal(false);
    expect(await token.balanceOf(opponent.address)).to.equal(90n);
  });

  it("uses only the winning slate cohort for the execution plan while routing the full round budget", async function () {
    const { ethers } = await hre.network.connect();
    const [deployer, admin, validator, winnerSupporter, loserSupporter, executor] = await ethers.getSigners();
    const token = await (await ethers.getContractFactory("MockUSDC", deployer)).deploy();
    const reserve = await (await ethers.getContractFactory("MockV3GlobalBertReserve", deployer)).deploy(await token.getAddress());
    const verifier = await (await ethers.getContractFactory("MockHumanVerifier", deployer)).deploy();
    const factory = await (await ethers.getContractFactory("MockV3CommunityFactory", deployer)).deploy(await verifier.getAddress());
    const hub = await (await ethers.getContractFactory("MockV3CommunityHub", deployer)).deploy();
    const treasury = await (await ethers.getContractFactory("CommunityTreasury", deployer)).deploy(
      await token.getAddress(), await reserve.getAddress(), await factory.getAddress(),
    );
    const membership = await (await ethers.getContractFactory("CommunityMembershipModule", deployer)).deploy(
      await hub.getAddress(), await treasury.getAddress(), await verifier.getAddress(), 1n, 1n, 1n,
      [admin.address], [validator.address],
    );
    const proposal = await (await ethers.getContractFactory("CommunityProposalModule", deployer)).deploy(
      await hub.getAddress(), await treasury.getAddress(), await membership.getAddress(), 5n, 1n, 1n, 1n, 5_000n, 100n,
    );
    const voting = await (await ethers.getContractFactory("CommunityVotingModule", deployer)).deploy(
      await hub.getAddress(), await treasury.getAddress(), await membership.getAddress(), await proposal.getAddress(),
      1n, 1n, 1n, 0n, 0n,
    );
    const snapshot = await (await ethers.getContractFactory("CommunityWinnerSnapshot", deployer)).deploy(await voting.getAddress());
    const manager = await (await ethers.getContractFactory("CommunityMilestoneManager", deployer)).deploy(
      await hub.getAddress(), await voting.getAddress(), executor.address, await treasury.getAddress(), await snapshot.getAddress(),
      24n * 60n * 60n, 14n * 24n * 60n * 60n,
    );
    const factoryCall = async (name: string, args: readonly unknown[]) =>
      factory.callTarget(await treasury.getAddress(), treasury.interface.encodeFunctionData(name, args));
    const hubCall = async (contract: any, name: string, args: readonly unknown[]) =>
      hub.callTarget(await contract.getAddress(), contract.interface.encodeFunctionData(name, args));

    await factoryCall("setCommunityHub", [await hub.getAddress()]);
    await factoryCall("setV31Modules", [await membership.getAddress(), await proposal.getAddress(), await voting.getAddress()]);
    await factoryCall("setMilestoneManager", [await manager.getAddress()]);
    await hubCall(membership, "setOperationalModules", [await proposal.getAddress(), await voting.getAddress()]);
    await hubCall(proposal, "setVotingModule", [await voting.getAddress()]);
    await hubCall(voting, "setMilestoneModules", [await snapshot.getAddress(), await manager.getAddress()]);
    for (const member of [winnerSupporter, loserSupporter]) {
      await verifier.setVerified(member.address, true);
      await token.mint(member.address, 50n);
      await token.connect(member).approve(await treasury.getAddress(), 50n);
      await hubCall(membership, "join", [member.address, 100n]);
    }

    await hubCall(proposal, "createAdminSlate", [admin.address, "Winner", "Wins the slate", "ipfs://winner", 101n]);
    await hubCall(proposal, "createAdminSlate", [admin.address, "Loser", "Loses the slate", "ipfs://loser", 101n]);
    await expect(hubCall(voting, "createAdminSlateRound", [winnerSupporter.address, [1n, 2n], 102n]))
      .to.be.revertedWithCustomError(voting, "NotCommunityAdmin");
    await expect(hubCall(voting, "createAdminSlateRound", [admin.address, [], 102n]))
      .to.be.revertedWithCustomError(voting, "InvalidCommunityConfig");
    await expect(hubCall(voting, "createAdminSlateRound", [admin.address, [1n, 1n], 102n]))
      .to.be.revertedWithCustomError(voting, "InvalidRoundProposal");
    await hubCall(voting, "createAdminSlateRound", [admin.address, [1n, 2n], 102n]);
    await expect(hubCall(voting, "settleSlateRound", [1n, 102n]))
      .to.be.revertedWithCustomError(voting, "VotingStillOpen");
    await expect(hubCall(voting, "castSlateRoundVote", [winnerSupporter.address, 1n, 99n, 30n, 102n]))
      .to.be.revertedWithCustomError(voting, "InvalidRoundProposal");
    await expect(hubCall(voting, "castSlateRoundVote", [winnerSupporter.address, 1n, 1n, 0n, 102n]))
      .to.be.revertedWithCustomError(voting, "VoteStakeTooLow");
    await hubCall(voting, "castSlateRoundVote", [winnerSupporter.address, 1n, 1n, 30n, 102n]);
    await expect(hubCall(voting, "castSlateRoundVote", [winnerSupporter.address, 1n, 1n, 1n, 102n]))
      .to.be.revertedWithCustomError(voting, "RoundVoteAlreadyCast");
    await hubCall(voting, "castSlateRoundVote", [loserSupporter.address, 1n, 2n, 20n, 102n]);
    await hubCall(voting, "settleSlateRound", [1n, 103n]);
    await expect(hubCall(voting, "settleSlateRound", [1n, 104n]))
      .to.be.revertedWithCustomError(voting, "ProposalAlreadySettled");

    expect((await voting.getRound(1n)).winningProposalId).to.equal(1n);
    expect(await snapshot.milestoneVoterWeight(1n, winnerSupporter.address)).to.equal(30n);
    expect(await snapshot.milestoneVoterWeight(1n, loserSupporter.address)).to.equal(0n);
    const plan = await manager.getPlan(1n);
    expect(plan.totalBudget).to.equal(50n);
    expect(plan.eligibleSupportWeight).to.equal(30n);
    expect(await token.balanceOf(executor.address)).to.equal(0n);
    expect(await treasury.totalMilestoneReserved()).to.equal(50n);
  });
});
