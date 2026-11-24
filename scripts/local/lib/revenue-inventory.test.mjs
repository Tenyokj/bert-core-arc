import assert from "node:assert/strict";
import fs from "node:fs";
import test from "node:test";
import { Interface } from "ethers";
import { reconcilePreRoundInventory } from "./revenue-inventory.mjs";

const abi = JSON.parse(fs.readFileSync(new URL("../../../test/fixtures/FundingPoolV140.json", import.meta.url))).abi;
const pool = "0x1111111111111111111111111111111111111111";
const token = "0x2222222222222222222222222222222222222222";
const author = "0x3333333333333333333333333333333333333333";
const events = new Interface(abi);
const transfers = new Interface(["event Transfer(address indexed from,address indexed to,uint256 value)"]);
const calls = new Interface(["function deposit(uint256 amount)"]);
const log = (iface, name, values, address, index, inAddressIndex = true) => ({
  ...iface.encodeEventLog(iface.getEvent(name), values), address, index, inAddressIndex,
});
function fixture() {
  const transactions = [
    { hash: "deposit", from: author, to: pool, data: calls.encodeFunctionData("deposit", [100n]),
      blockNumber: 1, index: 0, logs: [log(transfers, "Transfer", [author, pool, 100n], token, 0),
        log(events, "FundsDeposited", [author, 100n], pool, 1), log(events, "PoolBalanceUpdated", [100n], pool, 2)] },
    { hash: "bond", blockNumber: 2, index: 0, logs: [log(transfers, "Transfer", [author, pool, 50n], token, 0),
      log(events, "AuthorStakeDeposited", [1, author, 50n], pool, 1),
      log(events, "PoolBalanceUpdated", [150n], pool, 2)] },
    { hash: "return", blockNumber: 3, index: 0, logs: [log(transfers, "Transfer", [pool, author, 20n], token, 0),
      log(events, "AuthorStakeReleased", [1, author, 20n], pool, 1, false),
      log(events, "PoolBalanceUpdated", [130n], pool, 2, false)] },
  ];
  return { pool, token, abi, transactions, snapshot: { actualBalance: 130n, totalPoolBalance: 130n,
    protocolReserve: 0n, currentRoundId: 1n, totalIdeas: 1n, distributionCount: 0n, roundLedgersEmpty: true,
    authorStakes: { 1: 30n }, authors: { 1: author }, donorBalances: { [author]: 130n } } };
}

test("reconstructs contributions/bonds/returns without calling deposits revenue", () => {
  const result = reconcilePreRoundInventory(fixture());
  assert.equal(result.directDeposits, 100n);
  assert.equal(result.lockedAuthorBonds, 30n);
  assert.equal(result.authorBondsReturned, 20n);
  assert.equal(result.teamRevenue, 0n);
  assert.equal(result.missingFromAddressIndex.length, 2);
});
test("does not double count the Arc native alias Transfer", () => {
  const f = fixture();
  f.transactions[0].logs.unshift(log(transfers, "Transfer", [author, pool, 100n],
    "0xfffffffffffffffffffffffffffffffffffffffe", -1));
  assert.equal(reconcilePreRoundInventory(f).accounted, 130n);
});
test("fails on missing return events even when total custody looks correct", () => {
  const f = fixture();
  f.transactions[2].logs = f.transactions[2].logs.filter((l) => l.address !== pool);
  assert.throws(() => reconcilePreRoundInventory(f), /transfers do not match/);
});
test("fails on a stale balance or an unmatched asset transfer", () => {
  const f = fixture();
  f.snapshot.actualBalance = 129n;
  assert.throws(() => reconcilePreRoundInventory(f), /Actual custody/);
  const g = fixture();
  g.transactions[0].logs.shift();
  assert.throws(() => reconcilePreRoundInventory(g), /transfers do not match/);
});
test("fails on duplicate receipts, unknown financial events and non-direct deposits", () => {
  const f = fixture();
  f.transactions.push(f.transactions[0]);
  assert.throws(() => reconcilePreRoundInventory(f), /Duplicate/);
  const g = fixture();
  g.transactions[0].logs.push(log(events, "FundingRoundOpened", [1, 500], pool, 3));
  assert.throws(() => reconcilePreRoundInventory(g), /Unsupported financial/);
  const h = fixture();
  h.transactions[0].to = author;
  assert.throws(() => reconcilePreRoundInventory(h), /Non-direct deposit/);
});
test("fails on wrong donor/bond state or an active round outside this scope", () => {
  for (const mutate of [
    (s) => { s.donorBalances[author] = 0n; },
    (s) => { s.authorStakes[1] = 0n; },
    (s) => { s.currentRoundId = 2n; },
    (s) => { s.roundLedgersEmpty = false; },
  ]) {
    const f = fixture(); mutate(f.snapshot);
    assert.throws(() => reconcilePreRoundInventory(f));
  }
});
