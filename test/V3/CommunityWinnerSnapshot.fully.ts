import { expect, hre } from "../setup.js";

describe("V3.1 CommunityWinnerSnapshot", function () {
  async function deploySnapshot() {
    const { ethers } = await hre.network.connect();
    const [deployer, supporterOne, supporterTwo, outsider] = await ethers.getSigners();
    const votingModule = await (
      await ethers.getContractFactory("MockV3TreasuryModule", deployer)
    ).deploy();
    const snapshot = await (
      await ethers.getContractFactory("CommunityWinnerSnapshot", deployer)
    ).deploy(await votingModule.getAddress());

    async function votingCall(name: string, args: readonly unknown[]) {
      const data = snapshot.interface.encodeFunctionData(name, args);
      return votingModule.callTarget(await snapshot.getAddress(), data);
    }

    return { supporterOne, supporterTwo, outsider, snapshot, votingCall };
  }

  it("exposes no reviewer weight until the exact winner snapshot is sealed", async function () {
    const { supporterOne, supporterTwo, snapshot, votingCall } = await deploySnapshot();
    await votingCall("recordWinnerSupport", [7n, supporterOne.address, 60n]);
    await votingCall("recordWinnerSupport", [7n, supporterTwo.address, 40n]);

    expect(await snapshot.milestoneVoterWeight(7n, supporterOne.address)).to.equal(0n);
    await expect(votingCall("sealWinnerSnapshot", [7n, 99n])).to.be.revertedWith("weight mismatch");

    await votingCall("sealWinnerSnapshot", [7n, 100n]);
    expect(await snapshot.milestoneVoterWeight(7n, supporterOne.address)).to.equal(60n);
    expect(await snapshot.milestoneVoterWeight(7n, supporterTwo.address)).to.equal(40n);
    expect(await snapshot.milestoneVoterCount(7n)).to.equal(2n);
    expect(await snapshot.milestoneTotalWeight(7n)).to.equal(100n);
  });

  it("prevents arbitrary addresses and post-settlement membership changes from mutating a sealed snapshot", async function () {
    const { supporterOne, supporterTwo, outsider, snapshot, votingCall } = await deploySnapshot();
    await votingCall("recordWinnerSupport", [8n, supporterOne.address, 100n]);
    await votingCall("sealWinnerSnapshot", [8n, 100n]);

    await expect(snapshot.connect(outsider).recordWinnerSupport(8n, outsider.address, 1n)).to.be.revertedWith(
      "only voting module",
    );
    await expect(votingCall("recordWinnerSupport", [8n, supporterTwo.address, 1n])).to.be.revertedWith(
      "snapshot sealed",
    );
  });
});
