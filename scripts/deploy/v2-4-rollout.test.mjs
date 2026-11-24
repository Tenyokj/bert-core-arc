import assert from "node:assert/strict";
import test from "node:test";
import { SEND_ACK, guardPhase, assertPreserved, stripImmutables, journalTransaction } from "./lib/v2-4-rollout.mjs";

test("send phases require exact explicit acknowledgement; read-only phases do not", () => {
  for (const phase of ["preflight", "verify"]) guardPhase(phase);
  for (const phase of ["deploy-implementation", "pause", "upgrade", "deploy-treasury", "unpause"]) {
    assert.throws(() => guardPhase(phase));
    assert.throws(() => guardPhase(phase, "true"));
    guardPhase(phase, SEND_ACK);
  }
  for (const phase of ["schedule", "activate", "", "upgrade-all"]) assert.throws(() => guardPhase(phase, SEND_ACK));
});

test("state comparator permits only explicit implementation and pause changes", () => {
  const before = { blockNumber: 1, blockHash: "a", timestamp: 1, implementation: "old",
    values: { balance: "1140" }, storage: { 1: "original" }, namespaces: { initialized: "3" },
    modules: { pool: { paused: false, implementation: "old", codeHash: "oldHash" }, voting: { paused: false } } };
  const after = structuredClone(before);
  Object.assign(after, { blockNumber: 2, blockHash: "b", timestamp: 2, implementation: "new" });
  Object.assign(after.modules.pool, { paused: true, implementation: "new", codeHash: "newHash" });
  assertPreserved(before, after, { upgraded: true, ignorePause: true });
  assert.throws(() => assertPreserved(before, after));
  for (const mutate of [
    (s) => { s.values.balance = "1139"; }, (s) => { s.storage[1] = "changed"; },
    (s) => { s.namespaces.initialized = "4"; }, (s) => { s.modules.voting.implementation = "foreign"; },
  ]) {
    const tampered = structuredClone(after); mutate(tampered);
    assert.throws(() => assertPreserved(before, tampered, { upgraded: true, ignorePause: true }));
  }
});

test("Treasury comparison masks immutable ranges only", () => {
  assert.equal(stripImmutables("0x11223344", { a: [{ start: 1, length: 2 }] }), "0x11000044");
  assert.throws(() => stripImmutables("0x11", { a: [{ start: 1, length: 2 }] }));
});

function journalFixture() {
  const from = "0x0000000000000000000000000000000000000001";
  const to = "0x0000000000000000000000000000000000000002";
  const tx = { hash: `0x${"a".repeat(64)}`, from, to, data: "0x1234", value: 0n, nonce: 7, chainId: 5042002n };
  const evidence = { chainId: 5042002, operations: {} };
  let sends = 0;
  const provider = { getTransactionCount: async () => 7, estimateGas: async () => 100n,
    getFeeData: async () => ({ maxFeePerGas: 2n, maxPriorityFeePerGas: 1n }), getBalance: async () => 1000n,
    getTransaction: async () => tx, waitForTransaction: async () => ({ status: 1, blockNumber: 10, blockHash: "canonical", gasUsed: 90n }),
    getBlock: async () => ({ hash: "canonical" }) };
  const signer = { getAddress: async () => from, sendTransaction: async () => {
    assert.equal(evidence.operations.test.status, "intent-recorded", "Intent must exist BEFORE send");
    sends++; return tx;
  } };
  const args = { provider, signer, evidence, save: () => {}, name: "test", request: { to, data: "0x1234" } };
  return { args, tx, sends: () => sends };
}

test("confirmed transaction is verified again without a second broadcast", async () => {
  const f = journalFixture();
  await journalTransaction(f.args);
  await journalTransaction(f.args);
  assert.equal(f.sends(), 1);
  assert.equal(f.args.evidence.operations.test.status, "confirmed");
});

test("ambiguous send never automatically resends; exact hash recovery works", async () => {
  const f = journalFixture();
  f.args.signer.sendTransaction = async () => { throw new Error("already known"); };
  await assert.rejects(journalTransaction(f.args), /result unknown/);
  await assert.rejects(journalTransaction(f.args), /automatic resend is forbidden/);
  await journalTransaction({ ...f.args, recoveryHash: f.tx.hash });
  assert.equal(f.args.evidence.operations.test.status, "confirmed");
});

test("foreign recovery nonce/calldata/chain/from/destination/value are rejected", async () => {
  for (const change of [{ nonce: 8 }, { data: "0x5678" }, { chainId: 1n }, { from: "0x0000000000000000000000000000000000000003" },
    { to: null }, { value: 1n }]) {
    const f = journalFixture();
    await journalTransaction(f.args);
    f.args.provider.getTransaction = async () => ({ ...f.tx, ...change });
    await assert.rejects(journalTransaction(f.args), /does not match/);
  }
});

test("pending nonce, insufficient gas balance, reverted and reorganized receipts fail closed", async () => {
  const pending = journalFixture();
  pending.args.provider.getTransactionCount = async (_, tag) => tag === "pending" ? 8 : 7;
  await assert.rejects(journalTransaction(pending.args), /pending transactions/);
  assert.equal(pending.sends(), 0);
  const poor = journalFixture(); poor.args.provider.getBalance = async () => 0n;
  await assert.rejects(journalTransaction(poor.args), /Insufficient/);
  assert.equal(poor.sends(), 0);
  const reverted = journalFixture();
  reverted.args.provider.waitForTransaction = async () => ({ status: 0, blockNumber: 10, blockHash: "canonical", gasUsed: 90n });
  await assert.rejects(journalTransaction(reverted.args), /reverted/);
  await assert.rejects(journalTransaction(reverted.args), /reverted/);
  assert.equal(reverted.sends(), 1);
  const reorg = journalFixture(); reorg.args.provider.getBlock = async () => ({ hash: "other" });
  await assert.rejects(journalTransaction(reorg.args), /not canonical/);
});
