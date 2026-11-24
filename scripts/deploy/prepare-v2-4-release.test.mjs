import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import test from "node:test";
import { validateReleaseConfig } from "./prepare-v2-4-release.mjs";

const read = (name) => JSON.parse(readFileSync(new URL(`../../${name}`, import.meta.url)));
const source = read("release-config/arc-testnet-v2.4.json");
const manifest = read("deployments/arc-testnet-v3.json");
const artifact = { contractName: "FundingPoolUpgradeable", deployedBytecode: "0x6000" };
const copy = () => structuredClone(source);

test("offline plan validates without permitting broadcast or fabricating a Treasury deployment", () => {
  const plan = validateReleaseConfig(copy(), manifest, artifact);
  assert.equal(plan.readyToBroadcast, false);
  assert.equal(plan.publicTransactionsSent, false);
  assert.equal(plan.treasuryAddressRecorded, false);
  assert.equal(plan.initialRevenue, "disabled; no revenue initializer");
  assert.equal(plan.runtimeBytes, 2);
});
test("wrong network, source target, unknown fields or automatic initial activation fail closed", () => {
  for (const [field, value] of [["chainId", 1], ["fundingPoolProxy", manifest.usdc],
    ["expectedPreviousImplementation", manifest.usdc], ["expectedProxyAdmin", manifest.usdc],
    ["usdc", source.fundingPoolProxy], ["initialRevenueTreasury", source.fundingPoolProxy],
    ["initialRevenueShareBps", 2000], ["send", true]]) {
    const config = copy(); config[field] = value;
    assert.throws(() => validateReleaseConfig(config, manifest, artifact));
  }
});
test("only actual owner-selected fee share and complete approvals make terms complete", () => {
  const config = copy(); config.activation.shareBps = null; config.activation.shareApproved = false;
  assert.equal(validateReleaseConfig(config, manifest, artifact).activationTermsComplete, false);
  config.activation.shareApproved = true;
  assert.throws(() => validateReleaseConfig(config, manifest, artifact), /missing/);
  config.activation.shareBps = 2000;
  config.activation.delayApproved = true;
  config.activation.beneficiariesApproved = true;
  assert.equal(validateReleaseConfig(config, manifest, artifact).activationTermsComplete, true);
  assert.equal(validateReleaseConfig(config, manifest, artifact).readyToBroadcast, false);
});
test("immutable split requires unique nonzero addresses and exact 10000 bps", () => {
  for (const beneficiaries of [[], [{ address: manifest.usdc, shareBps: 9999 }],
    [{ address: "0x0000000000000000000000000000000000000000", shareBps: 10000 }],
    [{ address: source.fundingPoolProxy, shareBps: 10000 }],
    Array(17).fill(source.activation.beneficiaries[0]),
    [{ ...source.activation.beneficiaries[0], shareBps: 5000 }, { ...source.activation.beneficiaries[0], shareBps: 5000 }]]) {
    const config = copy(); config.activation.beneficiaries = beneficiaries; config.activation.beneficiariesApproved = true;
    assert.throws(() => validateReleaseConfig(config, manifest, artifact));
  }
});
test("wrong delay, malformed or oversized artifact cannot produce a valid plan", () => {
  const config = copy(); config.activation.policyDelaySeconds = 60;
  assert.throws(() => validateReleaseConfig(config, manifest, artifact), /48-hour/);
  for (const bytecode of ["0x", "0x0", `0x${"00".repeat(24577)}`, "not bytecode"]) {
    assert.throws(() => validateReleaseConfig(copy(), manifest, { ...artifact, deployedBytecode: bytecode }));
  }
});
