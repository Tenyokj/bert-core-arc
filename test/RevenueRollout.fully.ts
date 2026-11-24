import fs from "node:fs";
import { expect } from "./setup.js";
import { deploySystem } from "./helpers.js";
import { captureState, executePhase, verifyTreasury, verifyUpgrade } from "../scripts/deploy/lib/v2-4-rollout.mjs";

describe("V2.4 guarded rollout (local EDR only)", function () {
  it("upgrades a funded legacy proxy, resumes without duplicate sends and restores maintenance state", async function () {
    const s = await deploySystem();
    const artifact = (name: string) => JSON.parse(fs.readFileSync(`artifacts/contracts/BERT/DAO/${name}.sol/${name}.json`, "utf8"));
    const baseline = JSON.parse(fs.readFileSync("test/fixtures/FundingPoolV140.json", "utf8"));
    const proxyArtifact = JSON.parse(fs.readFileSync("node_modules/@openzeppelin/contracts/build/contracts/TransparentUpgradeableProxy.json", "utf8"));
    const impl = await new s.ethers.ContractFactory(baseline.abi, baseline.bytecode, s.admin).deploy();
    const proxy = await new s.ethers.ContractFactory(proxyArtifact.abi, proxyArtifact.bytecode, s.admin).deploy(
      await impl.getAddress(), s.admin.address, impl.interface.encodeFunctionData("initialize", [
        await s.usdc.getAddress(), await s.ideaRegistry.getAddress(), await s.roles.getAddress(),
      ]));
    const poolAddress = await proxy.getAddress();
    const pool = new s.ethers.Contract(poolAddress, baseline.abi, s.admin);
    for (const contract of [s.ideaRegistry, s.votingSystem, s.grantManager]) await contract.setFundingPool(poolAddress);
    const factory = await s.ethers.deployContract("MockCommunityFactoryRegistry");
    await pool.setCommunityFactory(await factory.getAddress());
    await pool.unpause(); await s.votingSystem.unpause(); await s.grantManager.unpause();
    await s.usdc.approve(poolAddress, 1140_000000n);
    await pool.deposit(1140_000000n);
    const adminSlot = s.ethers.toBeHex(BigInt(s.ethers.id("eip1967.proxy.admin")) - 1n, 32);
    const proxyAdmin = s.ethers.getAddress(`0x${(await s.ethers.provider.getStorage(poolAddress, adminSlot)).slice(-40)}`);
    const ctx = { provider: s.ethers.provider, baseline,
      config: { chainId: 31337, fundingPoolProxy: poolAddress, expectedProxyAdmin: proxyAdmin,
        expectedPreviousImplementation: await impl.getAddress(), usdc: await s.usdc.getAddress(),
        activation: { beneficiaries: [{ address: s.user4.address, shareBps: 10000 }] } },
      manifest: { v2: { votingSystem: { proxy: await s.votingSystem.getAddress() },
        grantManager: { proxy: await s.grantManager.getAddress() }, ideaRegistry: { proxy: await s.ideaRegistry.getAddress() } } },
      poolArtifact: artifact("FundingPoolUpgradeable"), treasuryArtifact: artifact("ProtocolRevenueTreasury") };
    const keys = { authorStakes: {}, donorBalances: { [s.admin.address]: "1140000000" } };
    const before = await captureState(ctx, "latest", keys);
    const evidence: any = { chainId: 31337, baseline: before, inventory: { snapshot: keys }, operations: {} };
    const save = () => {};
    await executePhase(ctx, evidence, "deploy-implementation", s.admin, save);
    await expect(executePhase(ctx, evidence, "upgrade", s.admin, save)).to.be.rejectedWith("must be paused");
    await expect(executePhase(ctx, evidence, "pause", s.user1, save)).to.be.rejectedWith("Wrong signer");
    await executePhase(ctx, evidence, "pause", s.admin, save);
    await executePhase(ctx, evidence, "pause", s.admin, save);
    await executePhase(ctx, evidence, "upgrade", s.admin, save);
    await executePhase(ctx, evidence, "upgrade", s.admin, save);
    // Model a send that mined but whose receipt was never persisted.
    delete evidence.operations.upgrade.receipt;
    evidence.operations.upgrade.status = "submitted";
    await executePhase(ctx, evidence, "upgrade", s.admin, save);
    await executePhase(ctx, evidence, "deploy-treasury", s.admin, save);
    const treasuryAddress = evidence.treasury.address;
    await executePhase(ctx, evidence, "deploy-treasury", s.admin, save);
    expect(evidence.treasury.address).to.equal(treasuryAddress);
    await executePhase(ctx, evidence, "unpause", s.admin, save);
    await executePhase(ctx, evidence, "unpause", s.admin, save);
    const after = await captureState(ctx, "latest", keys);
    await verifyUpgrade(ctx, evidence, after);
    await verifyTreasury(ctx, treasuryAddress, "latest");
    expect(after.actualBalance).to.equal("1140000000");
    expect(Object.values(after.modules).every((m: any) => !m.paused)).to.equal(true);
    expect(Object.keys(evidence.operations)).to.have.length(9);
    expect(new s.ethers.Interface(["function upgradeAndCall(address,address,bytes)"])
      .parseTransaction({ data: evidence.operations.upgrade.intent.data })!.args[2]).to.equal("0x");
    const modern = new s.ethers.Contract(poolAddress, ctx.poolArtifact.abi, s.admin);
    expect(await modern.revenueTreasury()).to.equal(s.ethers.ZeroAddress);
    expect(await modern.revenueShareBps()).to.equal(0n);
    // Once custody changes, strict rollout checks refuse to continue silently.
    await s.usdc.approve(poolAddress, 1n); await modern.deposit(1n);
    await expect(executePhase(ctx, evidence, "unpause", s.admin, save)).to.be.rejectedWith("state changed");
  });
});
