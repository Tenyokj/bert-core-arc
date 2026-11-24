import assert from "node:assert/strict";
import fs from "node:fs";
import { fileURLToPath } from "node:url";
import { Contract, FetchRequest, JsonRpcProvider, id, keccak256, toBeHex } from "ethers";
import { reconcilePreRoundInventory } from "./lib/revenue-inventory.mjs";

const root = fileURLToPath(new URL("../../", import.meta.url));
const read = (path) => JSON.parse(fs.readFileSync(`${root}${path}`, "utf8"));
const manifest = read("deployments/arc-testnet-v3.json");
const baseline = read("test/fixtures/FundingPoolV140.json");
const prior = read("docs/security-reports/v2.4-arc-fork-73753950.json");
const rpc = process.env.REVENUE_INVENTORY_RPC_URL;
const blockText = process.env.REVENUE_INVENTORY_BLOCK;
const output = process.env.REVENUE_INVENTORY_REPORT ?? "/private/tmp/bert-v24-historical-inventory.json";
const report = { recordedAt: new Date().toISOString(), status: "started", publicTransactionsSent: false,
  scope: "Pre-round FundingPool custody reconstructed from explorer discovery, canonical RPC receipts and pinned state",
  independentFullChainLogScan: false, completeProtocolAudit: false,
  discoveryLimit: "Explorer indexes discover transactions; receipt verification detects omissions within discovered transactions, not an independently exhaustive chain scan." };
const serialize = (value) => JSON.stringify(value, (_, v) => typeof v === "bigint" ? v.toString() : v, 2);
let provider;
let stage = "validate inputs";

async function pages(endpoint) {
  const items = [];
  let query = "";
  const visited = new Set();
  for (let page = 0; page < 20; page++) {
    assert(!visited.has(query), "Explorer pagination repeated a cursor");
    visited.add(query);
    const url = `https://testnet.arcscan.app/api/v2/addresses/${manifest.v2.fundingPool.proxy}/${endpoint}${query}`;
    const response = await fetch(url, { signal: AbortSignal.timeout(20_000) });
    assert(response.ok, `Explorer ${endpoint} HTTP ${response.status}`);
    const data = await response.json();
    assert(Array.isArray(data.items), `Invalid explorer ${endpoint} response`);
    items.push(...data.items);
    if (!data.next_page_params) return { items, pages: page + 1 };
    query = `?${new URLSearchParams(Object.entries(data.next_page_params).map(([k, v]) => [k, String(v)]))}`;
  }
  throw new Error(`Explorer ${endpoint} exceeded bounded pagination; no completeness claim`);
}

async function main() {
  assert(rpc, "REVENUE_INVENTORY_RPC_URL is required (read-only)");
  assert(blockText && /^[1-9]\d*$/.test(blockText), "Explicit REVENUE_INVENTORY_BLOCK is required");
  const block = Number(blockText);
  assert(Number.isSafeInteger(block));
  const request = new FetchRequest(rpc);
  request.timeout = 20_000;
  provider = new JsonRpcProvider(request);
  assert.equal(await provider.send("eth_chainId", []), "0x4cef52", "Expected Arc Testnet");
  const header = await provider.getBlock(block);
  assert(header?.hash, "Pinned block unavailable");
  report.blockNumber = block;
  report.blockHash = header.hash;
  report.harnessSha256 = (await import("node:crypto")).createHash("sha256")
    .update(fs.readFileSync(fileURLToPath(import.meta.url))).digest("hex");
  report.reducerSha256 = (await import("node:crypto")).createHash("sha256")
    .update(fs.readFileSync(new URL("./lib/revenue-inventory.mjs", import.meta.url))).digest("hex");
  const poolAddress = manifest.v2.fundingPool.proxy;
  const pool = new Contract(poolAddress, baseline.abi, provider);
  const slot = toBeHex(BigInt(id("eip1967.proxy.implementation")) - 1n, 32);
  const implementation = `0x${(await provider.getStorage(poolAddress, slot, block)).slice(-40)}`;
  assert.equal(implementation.toLowerCase(), manifest.v2.fundingPool.implementation.toLowerCase());
  const implementationHash = keccak256(await provider.getCode(implementation, block));
  assert.equal(implementationHash, prior.publicSnapshot.implementationCodeHash, "Unreviewed pool implementation");
  report.pool = poolAddress;
  report.implementationCodeHash = implementationHash;

  stage = "discover historical transactions with bounded pagination";
  const discoveries = {};
  const hashes = new Set();
  const indexedLogs = new Map();
  for (const endpoint of ["logs", "token-transfers", "transactions", "internal-transactions"]) {
    const result = await pages(endpoint);
    discoveries[endpoint] = { pages: result.pages, indexedItems: result.items.length };
    for (const item of result.items) {
      // Direct transaction responses use block_number too; receipts enforce the pin again.
      if (Number(item.block_number) > block) continue;
      const hash = item.transaction_hash ?? item.hash;
      assert(/^0x[0-9a-f]{64}$/i.test(hash), "Invalid explorer transaction hash");
      hashes.add(hash);
      if (endpoint === "logs") indexedLogs.set(`${hash}:${item.index}`, item);
    }
  }
  assert(hashes.size <= 150, "Snapshot exceeds bounded pre-round inventory scope");
  report.discovery = discoveries;
  stage = "verify discovered receipts against canonical RPC";
  const transactions = [];
  for (const hash of hashes) {
    const receipt = await provider.getTransactionReceipt(hash);
    assert(receipt && receipt.blockNumber <= block, "Missing/post-pin receipt");
    const tx = await provider.getTransaction(hash);
    assert(tx && tx.blockHash === receipt.blockHash, "Receipt/transaction mismatch");
    const canonical = await provider.getBlock(receipt.blockNumber);
    assert.equal(canonical?.hash, receipt.blockHash, "Receipt block is not canonical");
    const logs = receipt.logs.map((log) => {
      const indexed = indexedLogs.get(`${hash}:${log.index}`);
      if (indexed) {
        assert.equal(indexed.block_hash, receipt.blockHash);
        assert.equal(indexed.data, log.data);
        assert.deepEqual(indexed.topics.filter(Boolean), [...log.topics]);
        indexedLogs.delete(`${hash}:${log.index}`);
      }
      return { address: log.address, topics: [...log.topics], data: log.data, index: log.index,
        inAddressIndex: Boolean(indexed) };
    });
    transactions.push({ hash, from: tx.from, to: tx.to, data: tx.data,
      blockNumber: receipt.blockNumber, blockHash: receipt.blockHash, index: receipt.index,
      status: receipt.status, logs });
  }
  assert.equal(indexedLogs.size, 0, "Explorer claimed logs absent from RPC receipts");
  report.transactions = transactions;
  console.log(`Verified ${transactions.length} canonical receipts; reading state at block ${block}`);

  stage = "read pinned liabilities and rule out opened rounds";
  const ideas = new Contract(manifest.v2.ideaRegistry.proxy, [
    "function totalIdeas() view returns(uint256)", "function getIdeaAuthor(uint256) view returns(address)",
  ], provider);
  const voting = new Contract(manifest.v2.votingSystem.proxy, [
    "function currentRoundId() view returns(uint256)",
    "function getRoundInfo(uint256) view returns(uint256,uint256[],uint256,uint256,bool,bool,uint256,uint256,uint256)",
    "error RoundDoesNotExist(uint256 roundId)",
  ], provider);
  const grants = new Contract(manifest.v2.grantManager.proxy, [
    "function getGrantPayout(uint256) view returns(uint256,address,uint256,uint256,bool,bool,bool,uint256,uint256,bool)",
  ], provider);
  const token = new Contract(manifest.usdc, ["function balanceOf(address) view returns(uint256)"], provider);
  const at = { blockTag: block };
  const snapshot = { totalIdeas: await ideas.totalIdeas(at), currentRoundId: await voting.currentRoundId(at),
    totalPoolBalance: await pool.totalPoolBalance(at), protocolReserve: await pool.protocolReserve(at),
    actualBalance: await token.balanceOf(poolAddress, at), distributionCount: await pool.getDistributionCount(at),
    authorStakes: {}, authors: {}, donorBalances: {}, roundChecks: {}, roundLedgersEmpty: false };
  report.snapshot = snapshot;
  assert(snapshot.totalIdeas <= 100n && snapshot.currentRoundId === 1n, "Outside pre-round scope");
  assert.equal((await pool.usdc(at)).toLowerCase(), manifest.usdc.toLowerCase());
  for (let idea = 1n; idea <= snapshot.totalIdeas; idea++) {
    snapshot.authorStakes[idea] = await pool.authorStakeByIdea(idea, at);
    snapshot.authors[idea] = await ideas.getIdeaAuthor(idea, at);
  }
  const donors = new Set(transactions.flatMap((tx) => tx.logs.filter((l) =>
    l.address.toLowerCase() === manifest.usdc.toLowerCase() && l.topics.length === 3
      && l.topics[0] === id("Transfer(address,address,uint256)")
      && l.topics[2].slice(-40).toLowerCase() === poolAddress.slice(2).toLowerCase())
    .map((l) => `0x${l.topics[1].slice(-40)}`)));
  for (const donor of donors) snapshot.donorBalances[donor] = await pool.donorBalances(donor, at);
  for (const round of [0n, 1n]) {
    const check = snapshot.roundChecks[round] = { allocations: {} };
    if (round === 0n) {
      const info = await voting.getRoundInfo(round, at);
      check.voting = Array.from(info);
      assert(info[1].length === 0 && info[2] === 0n && info[3] === 0n && !info[4] && !info[5]
        && info[6] === 0n && info[7] === 0n && info[8] === 0n, "Nonempty legacy round zero");
    } else {
      await assert.rejects(voting.getRoundInfo(round, at), (error) =>
        error.revert?.name === "RoundDoesNotExist" && error.revert.args[0] === round,
      "Next round must not exist; a transport failure is not proof of absence");
      check.voting = "RoundDoesNotExist(1)";
    }
    const grant = await grants.getGrantPayout(round, at);
    check.grant = Array.from(grant);
    assert(grant[0] === 0n && grant[2] === 0n && grant[3] === 0n && !grant[4] && !grant[5]
      && !grant[6] && grant[7] === 0n && grant[8] === 0n && !grant[9], "Nonempty grant");
    for (const field of ["fundingRoundOpened", "fundingRoundSettled", "grantRefundActive"]) {
      assert.equal(await pool[field](round, at), false, `Unexpected ${field}`);
    }
    for (const field of ["pendingProtocolFeeByRound", "winningGrossPledgeByRound", "grantRefundTotalByRound"]) {
      assert.equal(await pool[field](round, at), 0n, `Unexpected ${field}`);
    }
    for (let idea = 1n; idea <= snapshot.totalIdeas; idea++) {
      // The validated wrapper rejects round zero; inspect its public mapping getter.
      check.allocations[idea] = await pool._poolByRoundAndIdea(round, idea, at);
      assert.equal(check.allocations[idea], 0n, "Allocated idea funds require broader inventory");
    }
  }
  snapshot.roundLedgersEmpty = true;
  report.snapshot = snapshot;
  stage = "reconstruct custody and compare pinned state";
  report.inventory = reconcilePreRoundInventory({ pool: poolAddress, token: manifest.usdc,
    abi: baseline.abi, transactions, snapshot });
  assert.equal((await provider.getBlock(block))?.hash, header.hash, "Pinned block changed during inspection");
  report.status = "reconciled-snapshot";
  console.log(serialize({ status: report.status, block, categories: report.inventory.categories,
    recoveredPoolLogs: report.inventory.missingFromAddressIndex.length, publicTransactionsSent: false }));
}

try { await main(); } catch (error) {
  report.status = "blocked";
  report.failure = { stage, message: error.shortMessage ?? error.message };
  console.error(`${stage}: ${report.failure.message}`);
  process.exitCode = 1;
} finally {
  provider?.destroy();
  fs.writeFileSync(output, `${serialize(report)}\n`);
}
