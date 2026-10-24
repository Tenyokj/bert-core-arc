import { expect, hre } from "../setup.js";

describe("V3.1 milestone custody with the restored CommunityTreasury", function () {
  it("protects a settled V3.0 execution balance and converts only the unreleased amount into a winner refund", async function () {
    const { ethers, networkHelpers } = await hre.network.connect();
    const [factory, executionRecipient, supporter] = await ethers.getSigners();
    const token = await (await ethers.getContractFactory("MockUSDC", factory)).deploy();
    const hub = await (await ethers.getContractFactory("MockV3CommunityHub", factory)).deploy();
    await hub.setAdmin(factory.address, true);
    const treasury = await (
      await ethers.getContractFactory("CommunityTreasury", factory)
    ).deploy(await token.getAddress(), factory.address, factory.address);
    const votingModule = await (
      await ethers.getContractFactory("MockV3TreasuryModule", factory)
    ).deploy();
    const snapshot = await (
      await ethers.getContractFactory("MockCommunityMilestoneVoting", factory)
    ).deploy();
    const manager = await (
      await ethers.getContractFactory("CommunityMilestoneManager", factory)
    ).deploy(
      await hub.getAddress(),
      await votingModule.getAddress(),
      executionRecipient.address,
      await treasury.getAddress(),
      await snapshot.getAddress(),
      24n * 60n * 60n,
      14n * 24n * 60n * 60n,
    );

    await treasury.setCommunityHub(await hub.getAddress());
    await treasury.setMilestoneManager(await manager.getAddress());
    await snapshot.setVoter(1n, supporter.address, 100n);

    await token.mint(supporter.address, 100n);
    await token.connect(supporter).approve(await treasury.getAddress(), 100n);
    const deposit = treasury.interface.encodeFunctionData("depositVoteStake", [1n, supporter.address, 100n]);
    await hub.callTarget(await treasury.getAddress(), deposit);
    const settle = treasury.interface.encodeFunctionData("settleBinaryYesWin", [1n, 100n, 0n, 0n]);
    await hub.callTarget(await treasury.getAddress(), settle);
    expect(await treasury.executionBalance()).to.equal(100n);

    const latest = await ethers.provider.getBlock("latest");
    const start = manager.interface.encodeFunctionData("startExecutionPlan", [1n, 100n, 100n, BigInt(latest!.timestamp)]);
    await votingModule.callTarget(await manager.getAddress(), start);
    expect(await token.balanceOf(executionRecipient.address)).to.equal(0n);
    const approve = manager.interface.encodeFunctionData("approveExecutionTranche", [factory.address, 1n, BigInt(latest!.timestamp)]);
    await hub.callTarget(await manager.getAddress(), approve);
    const execute = manager.interface.encodeFunctionData("executeExecutionTranche", [1n, [factory.address], BigInt(latest!.timestamp)]);
    await hub.callTarget(await manager.getAddress(), execute);
    expect(await treasury.executionBalance()).to.equal(0n);
    expect(await treasury.totalMilestoneReserved()).to.equal(80n);
    expect(await token.balanceOf(executionRecipient.address)).to.equal(20n);

    await networkHelpers.time.increase(14 * 24 * 60 * 60 + 1);
    const expiredAt = await ethers.provider.getBlock("latest");
    const fail = manager.interface.encodeFunctionData("failExpiredPlan", [1n, BigInt(expiredAt!.timestamp)]);
    await hub.callTarget(await manager.getAddress(), fail);
    expect(await treasury.totalMilestoneReserved()).to.equal(0n);
    expect(await treasury.totalMilestoneRefundLiability()).to.equal(80n);

    const claim = manager.interface.encodeFunctionData("claimFailedPlanRefund", [supporter.address, 1n]);
    await hub.callTarget(await manager.getAddress(), claim);
    expect(await token.balanceOf(supporter.address)).to.equal(80n);
    expect(await treasury.totalMilestoneRefundLiability()).to.equal(0n);
  });
});
