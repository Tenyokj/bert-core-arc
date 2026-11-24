import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { createRequire } from "node:module";
import { createHash } from "node:crypto";
import { Contract, ContractFactory, FetchRequest, JsonRpcProvider, MaxUint256, ZeroAddress, id, keccak256 } from "ethers";

const root = fileURLToPath(new URL("../../", import.meta.url));
const require = createRequire(import.meta.url);
const graphFixture = process.env.REVENUE_GRAPH_FIXTURE === "true";
const endpoint = graphFixture ? "http://127.0.0.1:19549" : "http://127.0.0.1:19548";
const block = 73753950;
const blockHash = "0xea1db9920001148186b76cc2504a73ca3da6b7697717d2aee9c6b4ffd9376dff";
let usdc = "0x3600000000000000000000000000000000000000";
const originalPool = "0x5eDdccd772a9E0F079cC6646b529C20e3D46e585";
const output = path.resolve(process.env.REVENUE_NATIVE_REPORT || (graphFixture ? "/private/tmp/bert-v24-graph-fixture.json" : "/private/tmp/bert-v24-native-grants.json"));
const request = new FetchRequest(endpoint);
request.timeout = 20_000;
const provider = new JsonRpcProvider(request, undefined, { cacheTimeout: -1 });
provider.pollingInterval = 100;
const report = { status: "started", recordedAt: new Date().toISOString(), chainId: 31337,
  publicTransactionsSent: false, freshLocalDeployment: true, populatedProxyUpgrade: false,
  walletBrowserTest: false, mockTokenUsed: graphFixture, block: graphFixture ? 0 : block, blockHash, asset: usdc,
  receipts: [], scenarios: [], fixtureChanges: ["Fresh local proxies; no public proxy changed",
    "Public development accounts funded by Arc Anvil", "Local PoP credentials, not proof of personhood",
    "Local block-time jumps; production Solidity deadlines unchanged"] };
const json = (x) => JSON.stringify(x, (_k, v) => typeof v === "bigint" ? String(v) : v, 2);
const artifact = (name) => {
  const folders = { RolesRegistryUpgradeable: "extensions/Roles", ReputationSystemUpgradeable: "extensions",
    VoterProgressionUpgradeable: "extensions", PoPVerifierUpgradeable: "extensions" };
  return JSON.parse(fs.readFileSync(path.join(root, `artifacts/contracts/BERT/${folders[name] || "DAO"}/${name}.sol/${name}.json`)));
};
let stage = "read-only execution guard";
async function sent(action, label) {
  assert.equal((await provider.getNetwork()).chainId, 31337n);
  const receipt = await (await action).wait();
  assert.equal(receipt.status, 1, label);
  report.receipts.push({ label, hash: receipt.hash, blockNumber: receipt.blockNumber,
    blockHash: receipt.blockHash, gasUsed: receipt.gasUsed, gasPrice: receipt.gasPrice, status: receipt.status });
  return receipt;
}
async function advanceTo(timestamp) {
  await provider.send("evm_setNextBlockTimestamp", [Number(timestamp) + 1]);
  await provider.send("evm_mine", []);
}
try {
  assert.equal((await provider.getNetwork()).chainId, 31337n, "Refuse public chain");
  const node = await provider.send("anvil_nodeInfo", []);
  if (graphFixture) assert(node.network == null || node.network === "ethereum", "Non-Arc execution required");
  else assert.equal(node.network, "arc");
  if (graphFixture) {
    assert(!node.forkConfig?.forkUrl && !node.forkConfig?.forkBlockNumber, "Fresh non-fork Graph fixture only");
    report.blockHash = (await provider.getBlock(0)).hash;
  } else {
    assert.equal(Number(node.forkConfig?.forkBlockNumber), block);
    assert.equal((await provider.getBlock(block)).hash, blockHash);
  }
  report.execution = { network: graphFixture ? "ethereum" : node.network, hardFork: node.hardFork,
    client: await provider.send("web3_clientVersion", []) };
  const addresses = await provider.send("eth_accounts", []);
  assert.equal(addresses[0].toLowerCase(), "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266");
  assert(addresses.length >= 9);
  const [admin, author, loser, ...rest] = await Promise.all([0, 2, 3, 4, 5, 6, 7, 8].map(i => provider.getSigner(addresses[i])));
  const [a, b, c, payee, relayer] = rest;
  const backers = [a, b, c];
  if (graphFixture) {
    const mock = JSON.parse(fs.readFileSync(path.join(root, "artifacts/contracts/Mocks/MockUSDC.sol/MockUSDC.json")));
    const deployed = await new ContractFactory(mock.abi, mock.bytecode, admin).deploy();
    await sent(deployed.deploymentTransaction(), "deploy explicitly labeled MockUSDC");
    usdc = await deployed.getAddress();
    report.asset = usdc;
    report.fixtureChanges.push("MockUSDC on fresh Ethereum execution; not native Arc acceptance");
    for (const user of [admin, author, loser, ...rest]) await sent(deployed.mint(user.address, 10000_000000n), "mint disposable Graph fixture capital");
  }
  const token = new Contract(usdc, ["function balanceOf(address) view returns(uint256)",
    "function decimals() view returns(uint8)", "function approve(address,uint256) returns(bool)",
    "function transfer(address,uint256) returns(bool)"], admin);
  assert.equal(await token.decimals(), 6n);
  const originalCustody = await token.balanceOf(originalPool);
  if (!graphFixture) assert.equal(originalCustody, 1140000000n);
  for (const user of [admin, author, loser, ...rest]) {
    assert(await token.balanceOf(user.address) > 1000_000000n, "Insufficient local fixture capital");
    if (!graphFixture) assert.equal(await token.balanceOf(user.address), await provider.getBalance(user.address) / 10n ** 12n);
    assert.equal(await token.transfer.staticCall(user.address, 1n), true, "Fixture account is issuer-blocked");
  }
  if (!graphFixture) await assert.rejects(token.transfer.staticCall(addresses[1], 1n), /Blocked address/);
  console.log(graphFixture ? "[Graph fixture] Fresh non-fork chain with explicit MockUSDC." : "[Native E2E] Arc mode, pinned header, actual native-USDC balances and issuer restrictions verified.");
  stage = "deploy fresh production proxy wiring on local Arc fork";
  const proxyArtifact = require("@openzeppelin/contracts/build/contracts/TransparentUpgradeableProxy.json");
  async function proxy(name, args) {
    const art = artifact(name);
    const implementation = await new ContractFactory(art.abi, art.bytecode, admin).deploy();
    await sent(implementation.deploymentTransaction(), `deploy ${name}`);
    const instance = await new ContractFactory(proxyArtifact.abi, proxyArtifact.bytecode, admin).deploy(
      await implementation.getAddress(), admin.address, implementation.interface.encodeFunctionData("initialize", args));
    await sent(instance.deploymentTransaction(), `proxy ${name}`);
    return new Contract(await instance.getAddress(), art.abi, admin);
  }
  const roles = await proxy("RolesRegistryUpgradeable", []);
  const reputation = await proxy("ReputationSystemUpgradeable", [roles.target]);
  const progression = await proxy("VoterProgressionUpgradeable", [roles.target]);
  const ideas = await proxy("IdeaRegistryUpgradeable", [reputation.target, progression.target, roles.target]);
  const pool = await proxy("FundingPoolUpgradeable", [usdc, ideas.target, roles.target]);
  const voting = await proxy("VotingSystemUpgradeable", [pool.target, ideas.target, reputation.target, progression.target, roles.target]);
  const verifier = await proxy("PoPVerifierUpgradeable", [roles.target, admin.address]);
  const grant = await proxy("GrantManagerUpgradeable", [voting.target, pool.target, ideas.target, roles.target]);
  for (const [role, target] of [["VOTING_ROLE", voting.target], ["GRANT_ROLE", grant.target],
    ["DISTRIBUTOR_ROLE", grant.target], ["IREGISTRY_ROLE", ideas.target],
    ["REPUTATION_MANAGER_ROLE", voting.target], ["REPUTATION_MANAGER_ROLE", ideas.target]]) {
    await sent(roles.grantSystemRole(await roles[role](), target), `grant ${role}`);
  }
  await sent(roles.grantRole(await roles.AUTO_GRANT_ROLE(), progression.target), "grant progression role");
  await sent(ideas.setFundingPool(pool.target), "wire idea pool");
  await sent(voting.setHumanVerifier(verifier.target), "wire voter verifier");
  await sent(ideas.setHumanVerifier(verifier.target), "wire author verifier");
  await sent(voting.setHumanOnlyVoting(true), "require verified voters");
  await sent(ideas.setHumanOnlyIdeaCreation(true), "require verified authors");
  await sent(voting.setIdeaPerRound(5), "five ideas per round");
  await sent(voting.setBackerMilestonesEnabled(true), "enable real backer milestones");
  for (const contract of [pool, voting, grant]) await sent(contract.unpause(), "unpause local module");
  const domain = { name: "BERT PoP Verifier", version: "1", chainId: 31337, verifyingContract: verifier.target };
  const types = { Verification: [{ name: "user", type: "address" }, { name: "verifiedUntil", type: "uint64" },
    { name: "nonce", type: "uint256" }, { name: "provider", type: "bytes32" }, { name: "credentialHash", type: "bytes32" }] };
  const verifiedUntil = BigInt((await provider.getBlock("latest")).timestamp) + 365n * 86400n;
  for (const user of [author, loser, ...backers]) {
    const payload = { user: user.address, verifiedUntil, nonce: 1n, provider: id("BERT_LOCAL_NATIVE_E2E"), credentialHash: id(user.address) };
    const signature = await admin.signTypedData(domain, types, payload);
    await sent(verifier.connect(user).submitVerification(verifiedUntil, 1n, payload.provider, payload.credentialHash, signature), "local PoP credential");
    await sent(token.connect(user).approve(pool.target, MaxUint256), "approve actual native USDC");
  }
  const art = artifact("ProtocolRevenueTreasury");
  const treasury = await new ContractFactory(art.abi, art.bytecode, admin).deploy(pool.target, usdc, [payee.address], [10000]);
  await sent(treasury.deploymentTransaction(), "deploy immutable Treasury");
  report.contracts = { pool: pool.target, ideas: ideas.target, voting: voting.target, grant: grant.target,
    roles: roles.target, progression: progression.target, reputation: reputation.target,
    verifier: verifier.target, treasury: await treasury.getAddress(), payee: payee.address };
  report.poolRuntimeHash = keccak256(await provider.getCode(pool.target));
  async function policy(enabled) {
    await sent(pool.scheduleRevenuePolicy(enabled ? treasury.target : ZeroAddress, enabled ? 2000 : 0), "schedule policy");
    await assert.rejects(pool.executeRevenuePolicy.staticCall());
    await advanceTo(await pool.revenuePolicyReadyAt());
    await sent(pool.connect(relayer).executeRevenuePolicy(), "activate exact policy");
  }
  await policy(true);
  async function accounting() {
    const state = await pool.getTreasuryAccounting();
    assert.equal(state.actual, await token.balanceOf(pool.target));
    assert.equal(state.actual, state.accounted);
    assert.equal(state.accounted, state.reserve + state.revenue + state.otherFunds);
    assert.equal(state.surplus, 0n); assert.equal(state.shortfall, 0n);
  }
  // Arc spends native USDC on gas. Compare native precision, then verify its ERC-20 view.
  async function exactReceiptTransfer(action, recipient, amount, label) {
    if (graphFixture) {
      const before = await token.balanceOf(recipient);
      await sent(action(), label);
      assert.equal(await token.balanceOf(recipient) - before, amount, `${label}: exact MockUSDC transfer`);
      return;
    }
    const before = await provider.getBalance(recipient);
    const receipt = await sent(action(), label);
    const tx = await provider.getTransaction(receipt.hash);
    const gas = tx.from.toLowerCase() === recipient.toLowerCase() ? receipt.gasUsed * receipt.gasPrice : 0n;
    const after = await provider.getBalance(recipient);
    assert.equal(after - before + gas, amount * 10n ** 12n, `${label}: exact transfer after gas`);
    assert.equal(await token.balanceOf(recipient), after / 10n ** 12n);
  }
  const unit = 1000000n, pledge = 20n * unit, gross = pledge * 3n, fee = gross * 500n / 10000n, net = gross - fee;
  async function newRound(minimum = 20n * unit) {
    const winner = await ideas.totalIdeas() + 1n;
    for (let i = 0; i < 5; i++) {
      const next = await ideas.totalIdeas() + 1n;
      await sent(ideas.connect(author).createFundingProposal(`Native proposal ${next}`, "Actual native-asset grant acceptance", "", 50n * unit, minimum), "create funding proposal");
      await sent(ideas.connect(author).commitFundingMilestonePlan(next, `ipfs://native-plan-${next}`, id(`plan-${next}`)), "commit immutable plan");
    }
    const round = await voting.currentRoundId();
    await sent(voting.startFundingRound(), "start real funding round");
    for (const user of backers) await sent(voting.connect(user).vote(round, winner, pledge), "pledge to winner");
    await sent(voting.connect(loser).vote(round, winner + 1n, pledge), "pledge to alternative");
    const data = await voting.getRoundInfo(round);
    await advanceTo(data.endTime);
    await sent(voting.endVotingRound(round), "settle through VotingSystem");
    return { round, winner, reserve: await pool.protocolReserve() };
  }
  async function claim(s) {
    await exactReceiptTransfer(() => grant.connect(author).claimGrant(s.round), author.address, 50n * unit + net * 20n / 100n, "claim initial 20% and author bond");
    await accounting();
  }
  async function collect() {
    const pending = await pool.pendingRevenueByTreasury(treasury.target);
    assert(pending > 0n);
    await sent(treasury.connect(relayer).collect(pending), "collect earned fee");
    await exactReceiptTransfer(() => treasury.connect(relayer).release(payee.address), payee.address, pending, "pay immutable beneficiary");
    await accounting();
  }
  async function milestone(s, stage) {
    await sent(grant.connect(author).submitBackerMilestoneProof(s.round, stage, `ipfs://native-proof-${s.round}-${stage}`, "Delivered", id(`proof-${s.round}-${stage}`)), "submit actual milestone proof");
    for (const user of backers) await sent(grant.connect(user).castBackerMilestoneVote(s.round, stage, true), "independent backer review");
    const proof = await grant.getMilestoneRequest(s.round, stage);
    await advanceTo(proof.submittedAt + await grant.MILESTONE_REVIEW_WINDOW());
    await exactReceiptTransfer(() => grant.connect(relayer).finalizeBackerMilestone(s.round, stage), author.address, net * 40n / 100n, "release approved 40%");
    await accounting();
  }
  stage = `full ${graphFixture ? "MockUSDC" : "native"} GrantManager 20/40/40`;
  const full = await newRound();
  await claim(full); await collect();
  await milestone(full, 1); await collect();
  await policy(false);
  assert.equal((await pool.fundingRoundRevenue(full.round)).shareBps, 2000n);
  await milestone(full, 2); await collect();
  assert.equal((await grant.getGrantPayout(full.round)).released, net);
  assert.equal(await pool.protocolReserve(), full.reserve + fee * 8000n / 10000n);
  await exactReceiptTransfer(() => pool.connect(loser).claimPledgeRefund(full.round), loser.address, pledge, "losing pledge full refund");
  report.scenarios.push({ name: stage, passed: true, gross, fee, net, revenue: fee * 2000n / 10000n, historicalPolicyPreserved: true });
  console.log("[Native E2E] Full GrantManager 20/40/40, revenue and historical policy passed.");
  await policy(true);
  for (const paidPercent of [20n, 60n, 0n]) {
    stage = `${graphFixture ? "MockUSDC" : "native"} grant cancellation after ${paidPercent}%`;
    const s = await newRound();
    if (paidPercent) { await claim(s); await collect(); }
    if (paidPercent === 60n) { await milestone(s, 1); await collect(); }
    if (paidPercent) {
      const delay = paidPercent === 20n ? await grant.IN_PROCESS_SUBMISSION_WINDOW() : await grant.COMPLETION_SUBMISSION_WINDOW();
      await advanceTo(BigInt((await provider.getBlock("latest")).timestamp) + delay);
      await sent(grant.cancelExpiredGrant(s.round), "cancel overdue actual grant");
    } else {
      await advanceTo((await voting.getRoundInfo(s.round)).endTime + await grant.GRANT_CLAIM_WINDOW());
      await sent(grant.expireUnclaimedGrant(s.round), "expire unclaimed actual grant");
    }
    for (const user of backers) await exactReceiptTransfer(() => pool.connect(user).claimPledgeRefund(s.round), user.address,
      pledge * (100n - paidPercent) / 100n, "winning pledge gross refund");
    await exactReceiptTransfer(() => pool.connect(loser).claimPledgeRefund(s.round), loser.address, pledge, "losing pledge full refund");
    assert.equal(await pool.totalPendingProtocolRevenue(), 0n);
    const slashedUnclaimedBond = paidPercent === 0n ? 50n * unit : 0n;
    assert.equal(await pool.protocolReserve(), s.reserve + fee * paidPercent / 100n * 8000n / 10000n + slashedUnclaimedBond);
    await accounting();
    report.scenarios.push({ name: stage, passed: true, refundPercent: 100n - paidPercent, slashedUnclaimedBond });
    console.log(`[Native E2E] ${paidPercent}% paid: exact gross refunds and vested fees passed.`);
  }
  assert.equal(await treasury.totalReleased(), 1080000n);
  assert.equal(await token.balanceOf(treasury.target), 0n);
  assert.equal(await token.balanceOf(originalPool), originalCustody, "Original public-proxy custody changed on the fork");
  if (!graphFixture) await assert.rejects(token.transfer.staticCall(addresses[1], 1n), /Blocked address/);
  report.status = graphFixture ? "passed full local Graph fixture; MockUSDC, not native Arc" : "passed full native GrantManager scenarios; not public rollout authorization";
  report.originalPoolCustodyPreserved = originalCustody;
  report.nativeGasAdjustedBalanceAssertions = !graphFixture;
  report.revenuePaid = await treasury.totalReleased();
  report.finalAccounting = [...await pool.getTreasuryAccounting()];
  report.lastBlock = await provider.getBlockNumber();
  report.harnessSha256 = createHash("sha256").update(fs.readFileSync(fileURLToPath(import.meta.url))).digest("hex");
} catch (error) {
  report.status = "failed"; report.failureStage = stage;
  report.error = error instanceof Error ? error.message : String(error);
  process.exitCode = 1;
  console.error(`[Native E2E] ${stage}: ${report.error}`);
} finally {
  fs.writeFileSync(output, json(report) + "\n");
  provider.destroy();
  console.log(`[Native E2E] Evidence: ${output}`);
}
