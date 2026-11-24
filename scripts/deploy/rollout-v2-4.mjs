import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import { spawnSync } from "node:child_process";
import { fileURLToPath, pathToFileURL } from "node:url";
import { FetchRequest, JsonRpcProvider, ZeroHash, keccak256, toUtf8Bytes } from "ethers";
import { validateReleaseConfig } from "./prepare-v2-4-release.mjs";
import { captureState, executePhase, guardPhase, json, saveEvidence, validateStorageLayout,
  verifyTreasury, verifyUpgrade, withEvidenceLock, WRITE_PHASES } from "./lib/v2-4-rollout.mjs";
import { reconcilePreRoundInventory } from "../local/lib/revenue-inventory.mjs";

const root = fileURLToPath(new URL("../../", import.meta.url));
const read = (filename) => JSON.parse(fs.readFileSync(path.join(root, filename), "utf8"));
const same = (a, b) => a?.toLowerCase() === b?.toLowerCase();

export function loadRolloutContext(provider) {
  const config = read("release-config/arc-testnet-v2.4.json");
  const manifest = read("deployments/arc-testnet-v3.json");
  const baseline = read("test/fixtures/FundingPoolV140.json");
  function artifact(name) {
    const value = read(`artifacts/contracts/BERT/DAO/${name}.sol/${name}.json`);
    const build = read(`artifacts/build-info/${value.buildInfoId}.json`);
    for (const [userName, inputName] of Object.entries(build.userSourceNameMap)) {
      if (!userName.startsWith("contracts/")) continue;
      assert.equal(fs.readFileSync(path.join(root, userName), "utf8"), build.input.sources[inputName].content,
        `Source changed since compilation: ${userName}. Run npm run compile.`);
    }
    const output = read(`artifacts/build-info/${value.buildInfoId}.output.json`).output.contracts[value.inputSourceName][name];
    assert.equal(`0x${output.evm.deployedBytecode.object}`, value.deployedBytecode, "Artifact/runtime output mismatch");
    assert.equal(`0x${output.evm.bytecode.object}`, value.bytecode, "Artifact/creation output mismatch");
    return { artifact: value, layout: output.storageLayout };
  }
  const pool = artifact("FundingPoolUpgradeable"), treasury = artifact("ProtocolRevenueTreasury");
  const plan = validateReleaseConfig(config, manifest, pool.artifact);
  assert(plan.activationTermsComplete, "Owner-selected terms incomplete");
  validateStorageLayout(baseline.storageLayout, pool.layout);
  const tools = ["scripts/deploy/rollout-v2-4.mjs", "scripts/deploy/rollout-v2-4.ts",
    "scripts/deploy/lib/v2-4-rollout.mjs", "scripts/deploy/prepare-v2-4-release.mjs",
    "scripts/local/inspect-v2-4-historical-accounting.mjs", "scripts/local/lib/revenue-inventory.mjs",
    "hardhat.config.ts", "package.json", "package-lock.json"].map((name) => [name, keccak256(fs.readFileSync(path.join(root, name)))]);
  const fingerprint = keccak256(toUtf8Bytes(json({ config, manifest, baseline, pool: pool.artifact, treasury: treasury.artifact, tools })));
  return { provider, config, manifest, baseline, poolArtifact: pool.artifact, treasuryArtifact: treasury.artifact,
    fingerprint, plan, prior: read("docs/security-reports/v2.4-arc-fork-73753950.json").publicSnapshot };
}

async function preflight(ctx, filename) {
  assert(!fs.existsSync(filename), "Evidence already exists; use verify or a NEW evidence path, never overwrite a rollout journal");
  const rpc = process.env.ARC_TESTNET_RPC_URL;
  assert(rpc, "Explicit ARC_TESTNET_RPC_URL required for fresh read-only inventory");
  const header = await ctx.provider.getBlock("latest");
  assert(header?.hash, "No latest block");
  const inventoryPath = `${filename}.inventory.json`;
  assert(!fs.existsSync(inventoryPath), "Inventory path already exists; choose a NEW evidence path");
  const child = spawnSync(process.execPath, [path.join(root, "scripts/local/inspect-v2-4-historical-accounting.mjs")], {
    cwd: root, stdio: "inherit", timeout: 240_000,
    env: { ...process.env, REVENUE_INVENTORY_RPC_URL: rpc, REVENUE_INVENTORY_BLOCK: String(header.number), REVENUE_INVENTORY_REPORT: inventoryPath },
  });
  assert.equal(child.status, 0, "Fresh inventory failed; no writes allowed");
  const inventory = JSON.parse(fs.readFileSync(inventoryPath, "utf8"));
  assert(inventory.status === "reconciled-snapshot" && inventory.publicTransactionsSent === false
    && inventory.blockNumber === header.number && inventory.blockHash === header.hash
    && same(inventory.pool, ctx.config.fundingPoolProxy), "Invalid fresh inventory evidence");
  reconcilePreRoundInventory({ pool: inventory.pool, token: ctx.config.usdc, abi: ctx.baseline.abi,
    transactions: inventory.transactions, snapshot: inventory.snapshot });
  const state = await captureState(ctx, header.number, inventory.snapshot);
  assert(same(state.implementation, ctx.config.expectedPreviousImplementation), "Previous implementation changed");
  assert(same(state.proxyAdmin, ctx.config.expectedProxyAdmin), "ProxyAdmin mismatch");
  assert(same(state.owner, ctx.prior.proxyAdminOwner), "Upgrade owner changed; review required");
  assert.equal(state.modules.pool.codeHash, ctx.prior.implementationCodeHash, "Previous runtime is not the reviewed 1.4.0 baseline");
  assert(same(state.values.roles, ctx.manifest.rolesRegistry) && same(state.values.usdc, ctx.config.usdc)
    && same(state.values.ideaRegistry, ctx.manifest.v2.ideaRegistry.proxy), "Pool wiring differs from manifest");
  for (const [name, key] of [["voting", "votingSystem"], ["grants", "grantManager"]]) {
    assert(same(state.modules[name].implementation, ctx.manifest.v2[key].implementation), `Unexpected ${name} implementation`);
  }
  assert.equal(state.totalIdeas, String(inventory.snapshot.totalIdeas));
  assert.equal(state.currentRoundId, "1");
  assert.equal(state.actualBalance, String(inventory.snapshot.actualBalance));
  assert.equal(state.values.totalPoolBalance, String(inventory.snapshot.totalPoolBalance));
  assert.deepEqual(state.authorStakes, inventory.snapshot.authorStakes);
  assert.deepEqual(state.donorBalances, inventory.snapshot.donorBalances);
  assert(Object.values(state.modules).every((m) => !m.paused), "Existing maintenance: review instead of assuming an active baseline");
  assert.deepEqual(state.factories.map((f) => f.address.toLowerCase()).sort(),
    ["v3Legacy", "v3Previous", "v3PreviousV32", "v3"].map((key) => ctx.manifest[key].factory.toLowerCase()).sort(),
    "Factory allowlist differs from the four reviewed generations");
  for (let i = 83; i < 112; i++) assert.equal(state.storage[i], ZeroHash, "Old reserved gap is not empty");
  const evidence = { schemaVersion: 1, chainId: ctx.config.chainId, fingerprint: ctx.fingerprint,
    recordedAt: new Date().toISOString(), baseline: state, inventory, operations: {},
    limits: "Bounded pre-round explorer-discovered inventory, not an independent exhaustive chain scan or security audit. No policy activation in this tool." };
  saveEvidence(filename, evidence);
  return evidence;
}

export async function runRollout(provider, getSigner) {
  const phase = process.env.V24_PHASE ?? "preflight";
  guardPhase(phase, process.env.V24_SEND);
  const filename = process.env.V24_EVIDENCE;
  assert(filename && path.isAbsolute(filename), "V24_EVIDENCE must be an absolute persistent path outside the repository");
  assert(path.relative(root, filename).startsWith(`..${path.sep}`), "Keep operational evidence outside the source repository; publish reviewed/redacted copies later");
  assert.equal(Number((await provider.getNetwork()).chainId), 5042002, "Expected Arc Testnet; no mainnet/local target accepted by CLI");
  const ctx = loadRolloutContext(provider);
  return withEvidenceLock(filename, async () => {
    let evidence;
    if (phase === "preflight") evidence = await preflight(ctx, filename);
    else {
      evidence = JSON.parse(fs.readFileSync(filename, "utf8"));
      assert(evidence.schemaVersion === 1 && evidence.chainId === ctx.config.chainId && evidence.fingerprint === ctx.fingerprint,
        "Release source/config/artifacts changed or wrong evidence file; stop for review");
      assert.equal((await provider.getBlock(evidence.baseline.blockNumber))?.hash, evidence.baseline.blockHash, "Original checkpoint is no longer canonical");
      for (const operation of Object.values(evidence.operations)) {
        if (!operation.receipt) continue;
        const receipt = await provider.getTransactionReceipt(operation.hash);
        assert(receipt?.status === 1 && receipt.blockHash === operation.receipt.blockHash
          && (await provider.getBlock(receipt.blockNumber))?.hash === receipt.blockHash,
          "A recorded receipt reverted/disappeared/reorganized; stop for recovery");
      }
      const save = () => saveEvidence(filename, evidence);
      if (phase === "verify") {
        const state = await captureState(ctx, "latest", evidence.inventory.snapshot);
        await verifyUpgrade(ctx, evidence, state);
        assert(evidence.operations.upgrade?.status === "confirmed", "Upgrade receipt unresolved; recover the upgrade phase first");
        if (evidence.treasury) await verifyTreasury(ctx, evidence.treasury.address, state.blockNumber);
        evidence.lastReadOnlyVerification = state;
        save();
      } else {
        assert(WRITE_PHASES.includes(phase) && getSigner, "Writes require the Hardhat wrapper and configured signer");
        evidence = await executePhase(ctx, evidence, phase, await getSigner(), save, process.env.V24_RECOVERY_TX);
      }
    }
    console.log(json({ phase, evidence: filename, checkpointBlock: evidence.baseline.blockNumber,
      implementation: evidence.implementationAddress ?? null, treasury: evidence.treasury?.address ?? null,
      lastCompletedPhase: evidence.lastCompletedPhase ?? "read-only preflight", revenuePolicy: "disabled; schedule/activation NOT performed",
      note: "Do not remove this journal or rerun using a new file after any send. Resolve recorded intents first." }));
    return evidence;
  });
}

if (process.argv[1] && pathToFileURL(path.resolve(process.argv[1])).href === import.meta.url) {
  let provider;
  try {
    const phase = process.env.V24_PHASE ?? "preflight";
    assert(!WRITE_PHASES.includes(phase), "Use rollout-v2-4.ts through Hardhat for explicit send phases");
    assert(process.env.ARC_TESTNET_RPC_URL, "Set ARC_TESTNET_RPC_URL");
    const request = new FetchRequest(process.env.ARC_TESTNET_RPC_URL);
    request.timeout = 20_000;
    provider = new JsonRpcProvider(request);
    await runRollout(provider);
  } catch (error) {
    console.error(error.shortMessage ?? error.message);
    process.exitCode = 1;
  } finally { provider?.destroy(); }
}
