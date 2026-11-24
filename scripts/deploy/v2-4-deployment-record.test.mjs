import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import test from "node:test";

const read = (name) => JSON.parse(readFileSync(new URL(`../../${name}`, import.meta.url)));
const current = read("deployments/arc-testnet-v3.json");
const baseline = read("deployments/arc-testnet-pre-v2.4.json");
const record = read("deployments/arc-testnet-v2.4-rollout.json");

test("current manifest matches the receipt-backed V2.4 installation", () => {
  assert.equal(current.v2.fundingPool.proxy, record.fundingPool.proxy);
  assert.equal(current.v2.fundingPool.proxyAdmin, record.fundingPool.proxyAdmin);
  assert.equal(current.v2.fundingPool.implementation, record.fundingPool.implementation);
  assert.equal(current.v2.fundingPool.upgradeTransaction, record.fundingPool.upgrade.transaction);
  assert.equal(current.v2.fundingPool.upgradeBlock, record.fundingPool.upgrade.block);
  assert.equal(current.v2.protocolRevenueTreasury.address, record.treasury.address);
  assert.deepEqual(current.v2.protocolRevenueTreasury.beneficiaries, record.treasury.beneficiaries);
  assert.equal(current.v2.subgraph, record.v2Subgraph.endpoint);
  assert.equal(current.v2.subgraphDeployment, record.v2Subgraph.deployment);
});

test("historical manifest preserves the original upgrade input and unchanged contracts", () => {
  assert.equal(baseline.v2.fundingPool.implementation, record.fundingPool.previousImplementation);
  assert.notEqual(baseline.v2.fundingPool.implementation, current.v2.fundingPool.implementation);
  for (const key of ["ideaRegistry", "votingSystem", "grantManager", "voterProgression", "reputationSystem"]) {
    assert.deepEqual(current.v2[key], baseline.v2[key]);
  }
  for (const key of ["sharedProxies", "v3", "v3Previous", "v3PreviousV32", "v3Legacy"]) {
    assert.deepEqual(current[key], baseline[key]);
  }
});

test("published metadata distinguishes scheduling from activation", () => {
  const policy = current.v2.protocolRevenueTreasury;
  assert.equal(policy.policyStatus, "scheduled-not-active");
  assert.equal(policy.scheduleTransaction, record.revenueSchedule.transaction);
  assert.equal(policy.scheduledShareBps, record.revenueSchedule.shareBps);
  assert.equal(policy.readyAt, record.revenueSchedule.readyAt);
  assert.equal(record.revenueSchedule.readyAt - record.revenueSchedule.scheduledAt, 172800);
  assert.equal(record.revenueSchedule.activationConfirmed, false);
});
