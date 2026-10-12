import { expect, hre } from "../setup.js";

describe("V3.1 CommunityMembershipModule", function () {
  it("enforces PoP, role exclusivity, stake custody, and unresolved-governance exit locks", async function () {
    const { ethers } = await hre.network.connect();
    const [deployer, admin, validator, member] = await ethers.getSigners();
    const token = await (await ethers.getContractFactory("MockUSDC", deployer)).deploy();
    const verifier = await (await ethers.getContractFactory("MockHumanVerifier", deployer)).deploy();
    const factory = await (
      await ethers.getContractFactory("MockV3CommunityFactory", deployer)
    ).deploy(await verifier.getAddress());
    const hub = await (await ethers.getContractFactory("MockV3CommunityHub", deployer)).deploy();
    const treasury = await (
      await ethers.getContractFactory("CommunityTreasury", deployer)
    ).deploy(await token.getAddress(), deployer.address, await factory.getAddress());
    const proposalModule = await (
      await ethers.getContractFactory("MockV3TreasuryModule", deployer)
    ).deploy();
    const votingModule = await (
      await ethers.getContractFactory("MockV3TreasuryModule", deployer)
    ).deploy();
    const membership = await (
      await ethers.getContractFactory("CommunityMembershipModule", deployer)
    ).deploy(
      await hub.getAddress(),
      await treasury.getAddress(),
      await verifier.getAddress(),
      25n,
      3n * 24n * 60n * 60n,
      1n,
      [admin.address],
      [validator.address],
    );

    const setHub = treasury.interface.encodeFunctionData("setCommunityHub", [await hub.getAddress()]);
    await factory.callTarget(await treasury.getAddress(), setHub);
    const setModules = treasury.interface.encodeFunctionData("setV31Modules", [
      await membership.getAddress(),
      await proposalModule.getAddress(),
      await votingModule.getAddress(),
    ]);
    await factory.callTarget(await treasury.getAddress(), setModules);

    async function hubCall(name: string, args: readonly unknown[]) {
      const data = membership.interface.encodeFunctionData(name, args);
      return hub.callTarget(await membership.getAddress(), data);
    }

    await expect(membership.join(member.address, 100n)).to.be.revertedWithCustomError(
      membership,
      "NotCommunityHub",
    );
    await expect(hubCall("clearObligation", [member.address]))
      .to.be.revertedWithCustomError(membership, "MembershipExitBlocked");
    await expect(hubCall("join", [ethers.ZeroAddress, 100n]))
      .to.be.revertedWithCustomError(membership, "ZeroAddress");

    await token.mint(member.address, 25n);
    await token.connect(member).approve(await treasury.getAddress(), 25n);
    await expect(hubCall("join", [member.address, 100n])).to.be.revertedWithCustomError(
      membership,
      "HumanVerificationRequired",
    );

    await verifier.setVerified(member.address, true);
    await hubCall("join", [member.address, 100n]);
    expect(await membership.isActiveMember(member.address)).to.equal(true);
    expect(await treasury.totalMembershipLocked()).to.equal(25n);
    await expect(hubCall("join", [member.address, 101n]))
      .to.be.revertedWithCustomError(membership, "AlreadyCommunityMember");

    await expect(hubCall("addAdmin", [member.address])).to.be.revertedWithCustomError(
      membership,
      "AdminValidatorRoleConflict",
    );
    await hubCall("addObligation", [member.address]);
    await hubCall("requestExit", [member.address, 200n]);
    await expect(hubCall("requestExit", [member.address, 201n]))
      .to.be.revertedWithCustomError(membership, "ExitAlreadyRequested");
    await expect(hubCall("finalizeExit", [member.address, 201n, false]))
      .to.be.revertedWithCustomError(membership, "ExitCooldownNotFinished");
    await expect(hubCall("finalizeExit", [member.address, 200n + 3n * 24n * 60n * 60n, false]))
      .to.be.revertedWithCustomError(membership, "MembershipExitBlocked");

    await hubCall("clearObligation", [member.address]);
    await hubCall("finalizeExit", [member.address, 200n + 3n * 24n * 60n * 60n, false]);
    expect(await membership.isActiveMember(member.address)).to.equal(false);
    expect(await token.balanceOf(member.address)).to.equal(25n);

    await expect(hubCall("removeAdmin", [member.address]))
      .to.be.revertedWithCustomError(membership, "RoleNotAssigned");
    await expect(hubCall("removeValidator", [member.address]))
      .to.be.revertedWithCustomError(membership, "RoleNotAssigned");
    await expect(hubCall("addAdmin", [admin.address]))
      .to.be.revertedWithCustomError(membership, "RoleAlreadyAssigned");
    await expect(hubCall("removeAdmin", [admin.address]))
      .to.be.revertedWithCustomError(membership, "CannotRemoveLastAdmin");

    await hubCall("awardProposalPoint", [1n, member.address]);
    expect(await membership.isValidatorEligible(member.address)).to.equal(true);
    await hubCall("addValidator", [member.address]);
    expect(await membership.isValidator(member.address)).to.equal(true);
    await expect(hubCall("addAdmin", [member.address]))
      .to.be.revertedWithCustomError(membership, "AdminValidatorRoleConflict");
    await hubCall("removeValidator", [member.address]);
  });
});
