import { expect, hre } from "../setup.js";

describe("V3.1 CommunityProposalModule", function () {
  it("preserves all four lanes and gives member proposals a bonded validator gate", async function () {
    const { ethers } = await hre.network.connect();
    const [deployer, admin, validator, member] = await ethers.getSigners();
    const token = await (await ethers.getContractFactory("MockUSDC", deployer)).deploy();
    const reserve = await (await ethers.getContractFactory("MockV3GlobalBertReserve", deployer)).deploy(await token.getAddress());
    const verifier = await (await ethers.getContractFactory("MockHumanVerifier", deployer)).deploy();
    const factory = await (await ethers.getContractFactory("MockV3CommunityFactory", deployer)).deploy(await verifier.getAddress());
    const hub = await (await ethers.getContractFactory("MockV3CommunityHub", deployer)).deploy();
    const treasury = await (await ethers.getContractFactory("CommunityTreasury", deployer)).deploy(
      await token.getAddress(), await reserve.getAddress(), await factory.getAddress(),
    );
    const membership = await (await ethers.getContractFactory("CommunityMembershipModule", deployer)).deploy(
      await hub.getAddress(), await treasury.getAddress(), await verifier.getAddress(), 25n, 1n, 1n,
      [admin.address], [validator.address],
    );
    const proposal = await (await ethers.getContractFactory("CommunityProposalModule", deployer)).deploy(
      await hub.getAddress(), await treasury.getAddress(), await membership.getAddress(), 5n, 1n, 24n * 60n * 60n, 7n * 24n * 60n * 60n, 5_000n, 100n,
    );
    const voting = await (await ethers.getContractFactory("MockV3TreasuryModule", deployer)).deploy();

    async function factoryCall(name: string, args: readonly unknown[]) {
      const data = treasury.interface.encodeFunctionData(name, args);
      return factory.callTarget(await treasury.getAddress(), data);
    }
    async function hubMembership(name: string, args: readonly unknown[]) {
      const data = membership.interface.encodeFunctionData(name, args);
      return hub.callTarget(await membership.getAddress(), data);
    }
    async function hubProposal(name: string, args: readonly unknown[]) {
      const data = proposal.interface.encodeFunctionData(name, args);
      return hub.callTarget(await proposal.getAddress(), data);
    }

    await factoryCall("setCommunityHub", [await hub.getAddress()]);
    await factoryCall("setV31Modules", [await membership.getAddress(), await proposal.getAddress(), await voting.getAddress()]);
    await hubMembership("setOperationalModules", [await proposal.getAddress(), await voting.getAddress()]);
    await hubProposal("setVotingModule", [await voting.getAddress()]);
    await expect(hubProposal("setVotingModule", [await voting.getAddress()]))
      .to.be.revertedWithCustomError(proposal, "CommunityV31ModulesAlreadyConfigured");
    await expect(proposal.getProposal(0n)).to.be.revertedWithCustomError(proposal, "CommunityProposalNotFound");
    await expect(proposal.getValidatorRewardEpoch(99n))
      .to.be.revertedWithCustomError(proposal, "ValidatorRewardEpochNotFound");
    await expect(proposal.createAdminBinary(admin.address, "Direct", "Direct", "ipfs://direct", 100n))
      .to.be.revertedWithCustomError(proposal, "NotCommunityHub");

    await verifier.setVerified(member.address, true);
    await token.mint(member.address, 35n);
    await token.connect(member).approve(await treasury.getAddress(), 35n);
    await hubMembership("join", [member.address, 100n]);

    await expect(hubProposal("createAdminBinary", [member.address, "No role", "Description", "ipfs://no-role", 101n]))
      .to.be.revertedWithCustomError(proposal, "NotCommunityAdmin");
    await expect(hubProposal("createAdminBinary", [admin.address, "", "Description", "ipfs://empty", 101n]))
      .to.be.revertedWithCustomError(proposal, "ZeroLength");
    await expect(hubProposal("createMemberBinary", [admin.address, "No member", "Description", "ipfs://no-member", 101n]))
      .to.be.revertedWithCustomError(proposal, "NotCommunityMember");

    await hubProposal("createAdminBinary", [admin.address, "Admin binary", "Description", "ipfs://admin-binary", 101n]);
    await hubProposal("createAdminSlate", [admin.address, "Admin slate", "Description", "ipfs://admin-slate", 101n]);
    await hubProposal("createMemberBinary", [member.address, "Member binary", "Description", "ipfs://member-binary", 101n]);
    await hubProposal("createMemberSlate", [member.address, "Member slate", "Description", "ipfs://member-slate", 101n]);

    expect((await proposal.getProposal(1n)).status).to.equal(2n);
    expect((await proposal.getProposal(2n)).status).to.equal(3n);
    expect((await proposal.getProposal(3n)).status).to.equal(0n);
    expect((await proposal.getProposal(4n)).status).to.equal(0n);
    expect(await treasury.totalProposalBondLocked()).to.equal(10n);
    expect(await membership.unresolvedObligationCount(member.address)).to.equal(2n);

    await expect(hubProposal("castValidationDecision", [admin.address, 3n, true, 102n]))
      .to.be.revertedWithCustomError(proposal, "NotCommunityValidator");
    await expect(hubProposal("castValidationDecision", [validator.address, 3n, true, 101n + 24n * 60n * 60n]))
      .to.be.revertedWithCustomError(proposal, "ValidationWindowClosed");
    await expect(hubProposal("finalizeExpiredValidation", [4n, 102n]))
      .to.be.revertedWithCustomError(proposal, "ValidationStillOpen");

    await hubProposal("castValidationDecision", [validator.address, 3n, true, 102n]);
    expect((await proposal.getProposal(3n)).status).to.equal(2n);
    expect(await membership.unresolvedObligationCount(member.address)).to.equal(2n);
    await expect(hubProposal("castValidationDecision", [validator.address, 3n, true, 103n]))
      .to.be.revertedWithCustomError(proposal, "InvalidProposalState");

    await hubProposal("castValidationDecision", [validator.address, 4n, false, 102n]);
    expect((await proposal.getProposal(4n)).status).to.equal(1n);
    expect(await membership.unresolvedObligationCount(member.address)).to.equal(1n);
    expect(await treasury.totalProposalBondLocked()).to.equal(5n);
    expect(await reserve.received()).to.equal(5n);
    await expect(hubProposal("finalizeExpiredValidation", [4n, 7n * 24n * 60n * 60n]))
      .to.be.revertedWithCustomError(proposal, "InvalidProposalState");
    await expect(hubProposal("finalizeValidatorRewardEpoch", [99n, 10n ** 9n]))
      .to.be.revertedWithCustomError(proposal, "ValidatorRewardEpochNotFound");

    // Both validator decisions belong to epoch 1. At a 50% activity threshold,
    // one completed case is enough, but this validator completed both.
    await hubProposal("finalizeValidatorRewardEpoch", [1n, 7n * 24n * 60n * 60n + 24n * 60n * 60n + 100n]);
    expect((await proposal.getValidatorRewardEpoch(1n)).finalized).to.equal(true);
    expect(await proposal.isValidatorActiveForEpoch(1n, validator.address)).to.equal(true);
    expect(await treasury.validatorRewardEpochFinalized(1n)).to.equal(true);
    await expect(hubProposal("finalizeValidatorRewardEpoch", [1n, 10n ** 9n]))
      .to.be.revertedWithCustomError(proposal, "ValidatorRewardEpochAlreadyFinalized");
  });
});
