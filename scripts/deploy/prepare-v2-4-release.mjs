import { readFileSync } from "node:fs";
import path from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";
import { getAddress, keccak256, ZeroAddress } from "ethers";

const root = fileURLToPath(new URL("../../", import.meta.url));
function requireCondition(condition, message) {
  if (!condition) throw new Error(message);
}
function address(value, label, allowZero = false) {
  let normalized;
  try { normalized = getAddress(value); } catch { throw new Error(`Invalid ${label}`); }
  requireCondition(allowZero || normalized !== ZeroAddress, `Zero ${label}`);
  return normalized;
}
function keys(value, allowed, label) {
  requireCondition(value && typeof value === "object" && !Array.isArray(value), `Invalid ${label}`);
  requireCondition(Object.keys(value).every((key) => allowed.includes(key)), `Unknown ${label} field`);
  requireCondition(allowed.every((key) => Object.hasOwn(value, key)), `Missing ${label} field`);
}

export function validateReleaseConfig(config, manifest, artifact) {
  keys(config, ["schemaVersion", "release", "status", "chainId", "fundingPoolProxy",
    "expectedPreviousImplementation", "expectedProxyAdmin", "usdc",
    "initialRevenueTreasury", "initialRevenueShareBps", "activation"], "config");
  requireCondition(config.schemaVersion === 1 && config.release === "V2.4" && config.status === "unreleased", "Not a V2.4 source candidate");
  requireCondition(config.chainId === 5042002 && manifest.chainId === config.chainId, "Arc Testnet chain mismatch");
  for (const [key, expected] of Object.entries({ fundingPoolProxy: manifest.v2.fundingPool.proxy,
    expectedPreviousImplementation: manifest.v2.fundingPool.implementation,
    expectedProxyAdmin: manifest.v2.fundingPool.proxyAdmin, usdc: manifest.usdc })) {
    requireCondition(address(config[key], key) === address(expected, key), `Manifest mismatch: ${key}`);
  }
  requireCondition(address(config.initialRevenueTreasury, "initial Treasury", true) === ZeroAddress &&
    config.initialRevenueShareBps === 0, "Upgrade must start with revenue disabled; activation is separate");
  const activation = config.activation;
  keys(activation, ["policyDelaySeconds", "delayApproved", "shareBps", "shareApproved",
    "treasuryAddress", "beneficiaries", "beneficiariesApproved"], "activation");
  requireCondition(activation.policyDelaySeconds === 172800, "Delay must match candidate 48-hour constant");
  for (const key of ["delayApproved", "shareApproved", "beneficiariesApproved"]) {
    requireCondition(typeof activation[key] === "boolean", `Invalid approval flag: ${key}`);
  }
  requireCondition(activation.shareBps === null || (Number.isSafeInteger(activation.shareBps) &&
    activation.shareBps >= 1 && activation.shareBps <= 10000), "Invalid eligible-fee share bps");
  requireCondition(!activation.shareApproved || activation.shareBps !== null, "Approved fee share is missing");
  const treasury = activation.treasuryAddress === null ? null : address(activation.treasuryAddress, "Treasury");
  requireCondition(treasury !== address(config.fundingPoolProxy, "pool"), "Treasury cannot be the pool");
  requireCondition(Array.isArray(activation.beneficiaries) && activation.beneficiaries.length <= 16, "At most 16 beneficiaries");
  const seen = new Set();
  let total = 0;
  for (const payee of activation.beneficiaries) {
    keys(payee, ["address", "shareBps"], "beneficiary");
    const destination = address(payee.address, "beneficiary");
    requireCondition(!seen.has(destination) && destination !== treasury && destination !== address(config.fundingPoolProxy, "pool"), "Duplicate or forbidden beneficiary");
    requireCondition(Number.isSafeInteger(payee.shareBps) && payee.shareBps > 0 && payee.shareBps <= 10000, "Invalid beneficiary share bps");
    seen.add(destination);
    total += payee.shareBps;
  }
  requireCondition(activation.beneficiaries.length === 0 || total === 10000, "Beneficiary shares must sum to 10000 bps");
  requireCondition(!activation.beneficiariesApproved || total === 10000, "Approved beneficiaries are missing");
  requireCondition(artifact.contractName === "FundingPoolUpgradeable" && /^0x[0-9a-f]+$/i.test(artifact.deployedBytecode), "Compile the ordinary FundingPool artifact first");
  const runtimeBytes = (artifact.deployedBytecode.length - 2) / 2;
  requireCondition(Number.isInteger(runtimeBytes) && runtimeBytes > 0 && runtimeBytes <= 24576, "FundingPool exceeds EIP-170 or bytecode is malformed");
  const decisions = [];
  if (!activation.delayApproved) decisions.push("Owner approval of policy delay");
  if (!activation.shareApproved) decisions.push("Owner selection/approval of eligible-fee share");
  if (!activation.beneficiariesApproved) decisions.push("Owner selection/approval of immutable beneficiaries");
  return {
    release: config.release, chainId: config.chainId, validation: "valid local candidate",
    readyToBroadcast: false, publicTransactionsSent: false,
    runtimeBytes, runtimeHash: keccak256(artifact.deployedBytecode),
    runtimeHeadroomBytes: 24576 - runtimeBytes,
    initialRevenue: "disabled; no revenue initializer",
    activationTermsComplete: decisions.length === 0,
    treasuryAddressRecorded: treasury !== null,
    pendingOwnerDecisions: decisions,
    remainingGates: ["Review recorded bounded acceptance against final reviewed source", "Fresh pinned accounting/authority/runtime preflight",
      "Separate authorization for public deployment/upgrade", "Verified Treasury deployment and constructor evidence",
      "Schedule the approved policy; wait actual 48 hours; execute and verify", "Graph/client rollout and public pilot"],
    warning: "Offline validation only. Local signoff flags and manifest entries are not live deployment evidence or transaction authorization.",
  };
}

if (process.argv[1] && pathToFileURL(path.resolve(process.argv[1])).href === import.meta.url) {
  try {
    requireCondition(process.argv.length <= 3, "Usage: node scripts/deploy/prepare-v2-4-release.mjs [config.json]");
    const read = (filename) => JSON.parse(readFileSync(filename, "utf8"));
    const config = read(process.argv[2] ? path.resolve(process.argv[2]) : path.join(root, "release-config/arc-testnet-v2.4.json"));
    console.log(JSON.stringify(validateReleaseConfig(config, read(path.join(root, "deployments/arc-testnet-v3.json")),
      read(path.join(root, "artifacts/contracts/BERT/DAO/FundingPoolUpgradeable.sol/FundingPoolUpgradeable.json"))), null, 2));
  } catch (error) {
    console.error(error.message);
    process.exitCode = 1;
  }
}
