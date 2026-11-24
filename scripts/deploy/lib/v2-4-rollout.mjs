import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import { Contract, ContractFactory, ZeroAddress, ZeroHash, getAddress,
  getCreateAddress, id, keccak256, toBeHex } from "ethers";

export const SEND_ACK = "I_UNDERSTAND_PUBLIC_TRANSACTIONS";
export const WRITE_PHASES = ["deploy-implementation", "pause", "upgrade", "deploy-treasury", "unpause"];
export const json = (value) => JSON.stringify(value, (_, v) => typeof v === "bigint" ? v.toString() : v, 2);
const same = (a, b) => a?.toLowerCase() === b?.toLowerCase();
const slot = (name) => toBeHex(BigInt(id(`eip1967.proxy.${name}`)) - 1n, 32);
const addressIn = (word) => getAddress(`0x${word.slice(-40)}`);
const pausedABI = ["function isPaused() view returns(bool)", "function pause()", "function unpause()"];
const adminABI = ["function owner() view returns(address)", "function upgradeAndCall(address,address,bytes) payable"];

export function guardPhase(phase, ack) {
  assert(["preflight", "verify", ...WRITE_PHASES].includes(phase), "Unknown rollout phase");
  if (WRITE_PHASES.includes(phase)) assert.equal(ack, SEND_ACK, "Public send requires explicit V24_SEND acknowledgement");
}

export function validateStorageLayout(old, next) {
  function shape(types, key) {
    const t = types[key];
    return { encoding: t.encoding, label: t.label, bytes: t.numberOfBytes,
      key: t.key ? shape(types, t.key) : undefined, value: t.value ? shape(types, t.value) : undefined,
      base: t.base ? shape(types, t.base) : undefined,
      members: t.members?.map((m) => ({ label: m.label, slot: m.slot, offset: m.offset, type: shape(types, m.type) })) };
  }
  for (const [i, field] of old.storage.slice(0, -1).entries()) {
    const now = next.storage[i];
    assert(now && now.label === field.label && now.slot === field.slot && now.offset === field.offset,
      `Storage field moved: ${field.label}`);
    assert.deepEqual(shape(next.types, now.type), shape(old.types, field.type), `Storage type changed: ${field.label}`);
  }
  const before = old.storage.at(-1), after = next.storage.at(-1);
  assert.equal(BigInt(after.slot), BigInt(before.slot) + 10n, "Unexpected revenue storage allocation");
  assert.equal(BigInt(next.types[after.type].numberOfBytes), 19n * 32n);
  assert.equal(BigInt(after.slot) * 32n + BigInt(next.types[after.type].numberOfBytes),
    BigInt(before.slot) * 32n + BigInt(old.types[before.type].numberOfBytes));
}

export function stripImmutables(code, references) {
  const chars = code.slice(2).split("");
  for (const ranges of Object.values(references)) for (const { start, length } of ranges) {
    assert(start >= 0 && length > 0 && (start + length) * 2 <= chars.length, "Invalid immutable reference");
    chars.fill("0", start * 2, (start + length) * 2);
  }
  return `0x${chars.join("")}`;
}

export function saveEvidence(filename, evidence) {
  const temporary = `${filename}.tmp`;
  const fd = fs.openSync(temporary, "w", 0o600);
  try { fs.writeFileSync(fd, `${json(evidence)}\n`); fs.fsyncSync(fd); } finally { fs.closeSync(fd); }
  fs.renameSync(temporary, filename);
}

export async function withEvidenceLock(filename, callback) {
  fs.mkdirSync(path.dirname(filename), { recursive: true });
  const lock = `${filename}.lock`;
  const fd = fs.openSync(lock, "wx", 0o600);
  try { return await callback(); } finally { fs.closeSync(fd); fs.unlinkSync(lock); }
}

// Persist intent before requesting a send. An unknown result never causes an automatic resend.
export async function journalTransaction({ provider, signer, evidence, save, name, request, recoveryHash }) {
  const from = getAddress(await signer.getAddress());
  let entry = evidence.operations[name];
  if (!entry) {
    const latest = await provider.getTransactionCount(from, "latest");
    assert.equal(await provider.getTransactionCount(from, "pending"), latest, "Signer has pending transactions; resolve them first");
    const intent = { from, to: request.to ? getAddress(request.to) : null, data: request.data,
      value: String(request.value ?? 0), nonce: latest, chainId: String(evidence.chainId) };
    const estimated = await provider.estimateGas({ ...request, from });
    const gasLimit = (estimated * 120n + 99n) / 100n;
    const fees = await provider.getFeeData();
    const price = fees.maxFeePerGas ?? fees.gasPrice;
    assert(price !== null, "RPC did not provide a gas price");
    assert(await provider.getBalance(from) >= gasLimit * price + BigInt(intent.value), "Insufficient native test USDC for estimated maximum cost");
    entry = evidence.operations[name] = { intent, gasLimit: String(gasLimit), estimatedMaximumCost: String(gasLimit * price),
      status: "intent-recorded", recordedAt: new Date().toISOString() };
    save();
    try {
      const tx = await signer.sendTransaction({ ...request, nonce: latest, gasLimit, chainId: evidence.chainId,
        ...(fees.maxFeePerGas !== null ? { maxFeePerGas: fees.maxFeePerGas, maxPriorityFeePerGas: fees.maxPriorityFeePerGas ?? 0n }
          : { gasPrice: fees.gasPrice }) });
      entry.hash = tx.hash;
      entry.status = "submitted";
      save();
      console.log(`${name}: ${tx.hash}`);
    } catch {
      entry.status = "ambiguous-send";
      save();
      throw new Error(`${name}: result unknown. Do not resend. Inspect signer nonce/history; use V24_RECOVERY_TX only for the exact recorded transaction.`);
    }
  }
  assert(same(entry.intent.from, from) && same(entry.intent.to ?? ZeroAddress, request.to ?? ZeroAddress)
    && same(entry.intent.data, request.data) && BigInt(entry.intent.value) === BigInt(request.value ?? 0), "Recorded operation differs from requested operation");
  const hash = entry.hash ?? recoveryHash;
  assert(hash, "Recorded intent has no hash. Resolve it manually; automatic resend is forbidden");
  const tx = await provider.getTransaction(hash);
  assert(tx && same(tx.from, from) && same(tx.to ?? ZeroAddress, entry.intent.to ?? ZeroAddress)
    && same(tx.data, entry.intent.data) && tx.value === BigInt(entry.intent.value)
    && tx.nonce === entry.intent.nonce && tx.chainId === BigInt(entry.intent.chainId), "Recovery transaction does not match recorded intent");
  entry.hash = tx.hash;
  save();
  const receipt = await provider.waitForTransaction(hash, 1, 120_000);
  assert(receipt, "Transaction still unconfirmed; rerun the same phase, not a new send");
  assert.equal((await provider.getBlock(receipt.blockNumber))?.hash, receipt.blockHash, "Receipt is not canonical");
  entry.receipt = { hash, blockNumber: receipt.blockNumber, blockHash: receipt.blockHash,
    status: receipt.status, contractAddress: receipt.contractAddress, gasUsed: String(receipt.gasUsed) };
  entry.status = receipt.status === 1 ? "confirmed" : "reverted";
  save();
  assert.equal(receipt.status, 1, "Recorded transaction reverted. No automatic retry");
  return receipt;
}

export async function captureState(ctx, blockNumber, keys) {
  const { provider, config, manifest, baseline } = ctx;
  const header = await provider.getBlock(blockNumber);
  assert(header?.hash, "Pinned header unavailable");
  const at = { blockTag: header.number };
  const pool = new Contract(config.fundingPoolProxy, baseline.abi, provider);
  const admin = new Contract(config.expectedProxyAdmin, adminABI, provider);
  const state = { blockNumber: header.number, blockHash: header.hash, timestamp: header.timestamp,
    implementation: addressIn(await provider.getStorage(config.fundingPoolProxy, slot("implementation"), header.number)),
    proxyAdmin: addressIn(await provider.getStorage(config.fundingPoolProxy, slot("admin"), header.number)),
    owner: await admin.owner(at), values: {}, storage: {}, namespaces: {}, authorStakes: {}, donorBalances: {}, factories: [], modules: {}, authorities: {} };
  for (const getter of ["roles", "usdc", "ideaRegistry", "totalPoolBalance", "protocolReserve", "pledgeFeeBps", "communityFactory", "getDistributionCount"]) {
    state.values[getter] = String(await pool[getter](at));
  }
  state.actualBalance = String(await new Contract(config.usdc, ["function balanceOf(address) view returns(uint256)"], provider).balanceOf(config.fundingPoolProxy, at));
  // Includes every old ordinary slot and the complete reserved gap. Upgrade has empty calldata.
  for (let start = 0; start < 112; start += 8) {
    await Promise.all(Array.from({ length: Math.min(8, 112 - start) }, async (_, offset) => {
      const n = start + offset;
      state.storage[n] = await provider.getStorage(config.fundingPoolProxy, n, header.number);
    }));
  }
  for (const name of ["Initializable", "ReentrancyGuard"]) {
    const namespace = toBeHex(BigInt(keccak256(toBeHex(BigInt(id(`openzeppelin.storage.${name}`)) - 1n, 32))) & ~255n, 32);
    state.namespaces[name] = await provider.getStorage(config.fundingPoolProxy, namespace, header.number);
  }
  for (const idea of Object.keys(keys.authorStakes)) state.authorStakes[idea] = String(await pool.authorStakeByIdea(idea, at));
  for (const donor of Object.keys(keys.donorBalances)) state.donorBalances[donor] = String(await pool.donorBalances(donor, at));
  const count = Number(await pool.communityFactoryCount(at));
  assert(count > 0 && count <= 16, "Unexpected Factory list size");
  for (let i = 0; i < count; i++) {
    const address = await pool.communityFactoryAt(i, at);
    state.factories.push({ address, approved: await pool.isCommunityFactoryApproved(address, at), codeHash: keccak256(await provider.getCode(address, header.number)) });
    assert(state.factories.at(-1).approved, "Enumerated Factory is not approved");
  }
  const roles = new Contract(state.values.roles, ["function hasRole(bytes32,address) view returns(bool)"], provider);
  for (const [name, role] of [["votingSystem", "VOTING_ROLE"], ["grantManager", "DISTRIBUTOR_ROLE"], ["ideaRegistry", "IREGISTRY_ROLE"]]) {
    const address = manifest.v2[name].proxy;
    state.authorities[name] = await roles.hasRole(id(role), address, at);
    assert(state.authorities[name], `Missing system role: ${name}`);
  }
  state.authorities.ownerIsAdmin = await roles.hasRole(ZeroHash, state.owner, at);
  assert(state.authorities.ownerIsAdmin, "ProxyAdmin owner is not protocol admin");
  for (const [name, address] of [["pool", config.fundingPoolProxy], ["voting", manifest.v2.votingSystem.proxy], ["grants", manifest.v2.grantManager.proxy]]) {
    state.modules[name] = { address, paused: await new Contract(address, pausedABI, provider).isPaused(at),
      implementation: addressIn(await provider.getStorage(address, slot("implementation"), header.number)) };
    state.modules[name].codeHash = keccak256(await provider.getCode(state.modules[name].implementation, header.number));
    if (name !== "pool") {
      const target = new Contract(address, ["function fundingPool() view returns(address)", "function roles() view returns(address)",
        "function ideaRegistry() view returns(address)"], provider);
      state.modules[name].references = { pool: await target.fundingPool(at), roles: await target.roles(at), ideas: await target.ideaRegistry(at) };
      assert(same(state.modules[name].references.pool, config.fundingPoolProxy)
        && same(state.modules[name].references.roles, state.values.roles)
        && same(state.modules[name].references.ideas, state.values.ideaRegistry), `Broken module wiring: ${name}`);
    }
  }
  state.rolesCodeHash = keccak256(await provider.getCode(state.values.roles, header.number));
  state.rolesImplementation = addressIn(await provider.getStorage(state.values.roles, slot("implementation"), header.number));
  state.rolesImplementationHash = keccak256(await provider.getCode(state.rolesImplementation, header.number));
  state.totalIdeas = String(await new Contract(manifest.v2.ideaRegistry.proxy, ["function totalIdeas() view returns(uint256)"], provider).totalIdeas(at));
  state.currentRoundId = String(await new Contract(manifest.v2.votingSystem.proxy, ["function currentRoundId() view returns(uint256)"], provider).currentRoundId(at));
  assert.equal((await provider.getBlock(header.number))?.hash, header.hash, "Snapshot reorganized during reads");
  return JSON.parse(json(state));
}

export function assertPreserved(before, after, { upgraded = false, ignorePause = false } = {}) {
  const clean = (snapshot) => {
    const value = structuredClone(snapshot);
    delete value.blockNumber; delete value.blockHash; delete value.timestamp;
    if (upgraded) {
      delete value.implementation;
      delete value.modules.pool.implementation; delete value.modules.pool.codeHash;
    }
    if (ignorePause) for (const module of Object.values(value.modules)) delete module.paused;
    return value;
  };
  assert.deepEqual(clean(after), clean(before), "On-chain state changed from reviewed checkpoint; stop and reconcile");
}

export async function verifyUpgrade(ctx, evidence, state) {
  const address = evidence.implementationAddress;
  assert(address && same(state.implementation, address), "Expected deployed implementation is not installed");
  assert.equal(await ctx.provider.getCode(address, state.blockNumber), ctx.poolArtifact.deployedBytecode, "Implementation bytecode mismatch");
  assert(same(state.proxyAdmin, ctx.config.expectedProxyAdmin), "ProxyAdmin changed");
  const pool = new Contract(ctx.config.fundingPoolProxy, ctx.poolArtifact.abi, ctx.provider);
  const at = { blockTag: state.blockNumber };
  for (const getter of ["revenueAsset", "revenueTreasury", "scheduledRevenueTreasury"]) assert.equal(await pool[getter](at), ZeroAddress, `Nonzero ${getter}`);
  for (const getter of ["revenueShareBps", "scheduledRevenueShareBps", "revenuePolicyReadyAt", "totalPendingProtocolRevenue"]) assert.equal(await pool[getter](at), 0n, `Nonzero ${getter}`);
  assert.equal(await pool.REVENUE_POLICY_DELAY(at), 172800n);
  assertPreserved(evidence.baseline, state, { upgraded: true, ignorePause: true });
}

export async function verifyTreasury(ctx, address, blockNumber) {
  const { treasuryArtifact, config, provider } = ctx;
  const code = await provider.getCode(address, blockNumber);
  assert.equal(stripImmutables(code, treasuryArtifact.immutableReferences), stripImmutables(treasuryArtifact.deployedBytecode, treasuryArtifact.immutableReferences), "Treasury runtime mismatch");
  const treasury = new Contract(address, treasuryArtifact.abi, provider);
  const at = { blockTag: blockNumber };
  assert(same(await treasury.fundingPool(at), config.fundingPoolProxy) && same(await treasury.usdc(at), config.usdc), "Treasury pool/token mismatch");
  assert.equal(await treasury.payeeCount(at), BigInt(config.activation.beneficiaries.length));
  for (const [i, payee] of config.activation.beneficiaries.entries()) {
    assert(same(await treasury.payeeAt(i, at), payee.address), "Immutable payee mismatch");
    assert.equal(await treasury.shares(payee.address, at), BigInt(payee.shareBps), "Immutable share mismatch");
  }
  return keccak256(code);
}

export async function executePhase(ctx, evidence, phase, signer, save, recoveryHash) {
  const { provider, config, poolArtifact, treasuryArtifact } = ctx;
  assert(WRITE_PHASES.includes(phase), "Unknown write phase");
  for (const [name, operation] of Object.entries(evidence.operations)) {
    if (operation.status === "confirmed") continue;
    const belongsToPhase = phase === "pause" ? name.startsWith("pause-")
      : phase === "unpause" ? name.startsWith("unpause-") : name === phase;
    assert(belongsToPhase, `Resolve unfinished operation ${name} before another phase`);
  }
  let current = await captureState(ctx, "latest", evidence.inventory.snapshot);
  assert(same(await signer.getAddress(), evidence.baseline.owner), "Wrong signer; expected recorded ProxyAdmin owner");
  // A previous send can have succeeded even if the process never received its receipt.
  if (phase === "upgrade" && same(current.implementation, evidence.implementationAddress)
      && evidence.operations.upgrade && evidence.operations.upgrade.receipt?.status !== 1) {
    const request = await new Contract(config.expectedProxyAdmin, adminABI, signer)
      .upgradeAndCall.populateTransaction(config.fundingPoolProxy, evidence.implementationAddress, "0x");
    await journalTransaction({ provider, signer, evidence, save, name: "upgrade", request, recoveryHash });
  }
  const upgraded = Boolean(evidence.operations.upgrade?.receipt?.status === 1);
  if (upgraded) await verifyUpgrade(ctx, evidence, current);
  else {
    assert(same(current.implementation, config.expectedPreviousImplementation), "Unexpected previous implementation");
    assertPreserved(evidence.baseline, current, { ignorePause: true });
  }
  const send = async (name, request) => {
    if (!evidence.operations[name] && !upgraded) {
      const header = await provider.getBlock("latest");
      assert(header.timestamp - evidence.baseline.timestamp <= 3600, "Preflight is older than one hour; stop for a new reviewed checkpoint");
    }
    return journalTransaction({ provider, signer, evidence, save, name, request, recoveryHash });
  };
  const module = (address) => new Contract(address, pausedABI, signer);
  if (phase === "deploy-implementation") {
    assert(!upgraded, "Already upgraded; do not deploy another implementation");
    const request = await new ContractFactory(poolArtifact.abi, poolArtifact.bytecode, signer).getDeployTransaction();
    const receipt = await send(phase, request);
    assert(receipt.contractAddress, "Missing implementation deployment address");
    assert.equal(await provider.getCode(receipt.contractAddress), poolArtifact.deployedBytecode, "Deployed implementation mismatch");
    evidence.implementationAddress = receipt.contractAddress;
  } else if (phase === "pause") {
    assert(evidence.implementationAddress && !upgraded, "Deploy/verify implementation before maintenance");
    for (const name of ["pool", "voting", "grants"]) {
      current = await captureState(ctx, "latest", evidence.inventory.snapshot);
      assertPreserved(evidence.baseline, current, { ignorePause: true });
      if (!current.modules[name].paused || evidence.operations[`pause-${name}`]) {
        await send(`pause-${name}`, await module(current.modules[name].address).pause.populateTransaction());
      }
    }
    current = await captureState(ctx, "latest", evidence.inventory.snapshot);
    assert(Object.values(current.modules).every((v) => v.paused), "Maintenance pause incomplete");
  } else if (phase === "upgrade") {
    assert(Object.values(current.modules).every((v) => v.paused), "All three V2 modules must be paused");
    assert(evidence.implementationAddress, "No verified implementation evidence");
    assert.equal(await provider.getCode(evidence.implementationAddress), poolArtifact.deployedBytecode, "Target bytecode mismatch");
    if (!evidence.upgradeBefore) { evidence.upgradeBefore = current; save(); }
    const admin = new Contract(config.expectedProxyAdmin, adminABI, signer);
    await send("upgrade", await admin.upgradeAndCall.populateTransaction(config.fundingPoolProxy, evidence.implementationAddress, "0x"));
    current = await captureState(ctx, "latest", evidence.inventory.snapshot);
    await verifyUpgrade(ctx, evidence, current);
    assertPreserved(evidence.upgradeBefore, current, { upgraded: true });
    evidence.upgradeVerified = current;
  } else if (phase === "deploy-treasury") {
    assert(upgraded && evidence.upgradeVerified, "Upgrade postchecks must pass first");
    const payees = config.activation.beneficiaries;
    const args = [config.fundingPoolProxy, config.usdc, payees.map((p) => p.address), payees.map((p) => p.shareBps)];
    const receipt = await send(phase, await new ContractFactory(treasuryArtifact.abi, treasuryArtifact.bytecode, signer).getDeployTransaction(...args));
    const address = getCreateAddress({ from: await signer.getAddress(), nonce: evidence.operations[phase].intent.nonce });
    assert(same(receipt.contractAddress, address), "Unexpected Treasury creation address");
    evidence.treasury = { address, constructorArguments: args, runtimeHash: await verifyTreasury(ctx, address, "latest") };
  } else if (phase === "unpause") {
    assert(upgraded && evidence.upgradeVerified && evidence.treasury, "Verify upgrade and Treasury before reopening");
    await verifyTreasury(ctx, evidence.treasury.address, "latest");
    for (const name of ["grants", "voting", "pool"]) {
      current = await captureState(ctx, "latest", evidence.inventory.snapshot);
      await verifyUpgrade(ctx, evidence, current);
      // Restore only modules which were active at the original checkpoint.
      if (!evidence.baseline.modules[name].paused && (current.modules[name].paused || evidence.operations[`unpause-${name}`])) {
        await send(`unpause-${name}`, await module(current.modules[name].address).unpause.populateTransaction());
      }
    }
    current = await captureState(ctx, "latest", evidence.inventory.snapshot);
    await verifyUpgrade(ctx, evidence, current);
    for (const name of Object.keys(current.modules)) assert.equal(current.modules[name].paused, evidence.baseline.modules[name].paused);
    evidence.reopened = current;
  }
  evidence.lastCompletedPhase = phase;
  save();
  return evidence;
}
