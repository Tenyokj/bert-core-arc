/**
 * @file preflight-arc-v3.ts
 * @notice Read-only safety check before upgrading the live Arc V2 proxies for BERT V3.
 * @dev This script never submits a transaction. It validates the exact transparent proxy
 *      administration and captures the V2 values that must survive the upgrades.
 *
 * Required environment variables:
 *   ROLES_REGISTRY_ADDRESS, IDEA_REGISTRY_PROXY_ADDRESS, FUNDING_POOL_ADDRESS,
 *   VOTING_PROXY_ADDRESS, POP_VERIFIER_ADDRESS, USDC_ADDRESS
 *
 * Run with:
 *   npx hardhat run scripts/deploy/preflight-arc-v3.ts --network arcTestnet
 */
import { hre } from "../../test/setup.js";

const ARC_TESTNET_CHAIN_ID = 5_042_002n;
const EIP1967_ADMIN_SLOT =
  "0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103";
const EIP1967_IMPLEMENTATION_SLOT =
  "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc";

function requiredAddress(name: string): string {
  const value = process.env[name]?.trim();
  if (!value) throw new Error(`${name} is required`);
  return value;
}

function addressFromSlot(ethers: Awaited<ReturnType<typeof hre.network.connect>>["ethers"], value: string): string {
  return ethers.getAddress(ethers.dataSlice(value, 12));
}

async function inspectProxy(
  ethers: Awaited<ReturnType<typeof hre.network.connect>>["ethers"],
  label: string,
  address: string
) {
  const code = await ethers.provider.getCode(address);
  if (code === "0x") throw new Error(`${label} at ${address} has no deployed bytecode`);

  const [adminStorage, implementationStorage] = await Promise.all([
    ethers.provider.getStorage(address, EIP1967_ADMIN_SLOT),
    ethers.provider.getStorage(address, EIP1967_IMPLEMENTATION_SLOT),
  ]);
  const admin = addressFromSlot(ethers, adminStorage);
  const implementation = addressFromSlot(ethers, implementationStorage);
  const adminCode = await ethers.provider.getCode(admin);
  if (adminCode === "0x") throw new Error(`${label} ProxyAdmin ${admin} has no deployed bytecode`);

  const proxyAdmin = new ethers.Contract(admin, ["function owner() view returns (address)"], ethers.provider);
  const owner = await proxyAdmin.owner();
  console.log(`\n${label}`);
  console.log(`  Proxy:          ${address}`);
  console.log(`  Implementation: ${implementation}`);
  console.log(`  ProxyAdmin:     ${admin}`);
  console.log(`  Admin owner:    ${owner}`);
  return { admin, implementation, owner };
}

async function optionalRead<T>(label: string, read: () => Promise<T>): Promise<T | "not implemented"> {
  try {
    return await read();
  } catch {
    // Appended getters do not exist until the corresponding proxy has been upgraded.
    console.log(`  ${label}: not implemented by the current live implementation`);
    return "not implemented";
  }
}

async function main() {
  const connection = await hre.network.connect();
  const { ethers } = connection;
  const [deployer] = await ethers.getSigners();
  const network = await ethers.provider.getNetwork();

  if (network.chainId !== ARC_TESTNET_CHAIN_ID) {
    throw new Error(`Wrong network: expected Arc Testnet (${ARC_TESTNET_CHAIN_ID}), got ${network.chainId}`);
  }

  const addresses = {
    roles: requiredAddress("ROLES_REGISTRY_ADDRESS"),
    idea: requiredAddress("IDEA_REGISTRY_PROXY_ADDRESS"),
    funding: requiredAddress("FUNDING_POOL_ADDRESS"),
    voting: requiredAddress("VOTING_PROXY_ADDRESS"),
    verifier: requiredAddress("POP_VERIFIER_ADDRESS"),
    usdc: requiredAddress("USDC_ADDRESS"),
  };

  for (const [label, address] of Object.entries(addresses)) {
    if (!ethers.isAddress(address)) throw new Error(`${label} is not a valid address: ${address}`);
  }

  console.log("BERT Arc V3 preflight (read-only)");
  console.log(`Network:  ${network.name} (${network.chainId})`);
  console.log(`Deployer: ${deployer.address}`);

  const [ideaProxy, fundingProxy, votingProxy] = await Promise.all([
    inspectProxy(ethers, "IdeaRegistryUpgradeable", addresses.idea),
    inspectProxy(ethers, "FundingPoolUpgradeable", addresses.funding),
    inspectProxy(ethers, "VotingSystemUpgradeable", addresses.voting),
  ]);

  const expectedOwner = process.env.PROXY_ADMIN_OWNER?.trim();
  if (expectedOwner && !ethers.isAddress(expectedOwner)) {
    throw new Error(`PROXY_ADMIN_OWNER is not a valid address: ${expectedOwner}`);
  }
  if (expectedOwner) {
    for (const proxy of [ideaProxy, fundingProxy, votingProxy]) {
      if (proxy.owner.toLowerCase() !== expectedOwner.toLowerCase()) {
        throw new Error(`ProxyAdmin owner ${proxy.owner} does not match PROXY_ADMIN_OWNER ${expectedOwner}`);
      }
    }
  }

  const [rolesCode, verifierCode, usdcCode] = await Promise.all([
    ethers.provider.getCode(addresses.roles),
    ethers.provider.getCode(addresses.verifier),
    ethers.provider.getCode(addresses.usdc),
  ]);
  if (rolesCode === "0x" || verifierCode === "0x" || usdcCode === "0x") {
    throw new Error("RolesRegistry, PoPVerifier, or configured USDC is not a deployed contract");
  }

  const [roles, idea, funding, voting, verifier] = await Promise.all([
    ethers.getContractAt("RolesRegistryUpgradeable", addresses.roles),
    ethers.getContractAt("IdeaRegistryUpgradeable", addresses.idea),
    ethers.getContractAt("FundingPoolUpgradeable", addresses.funding),
    ethers.getContractAt("VotingSystemUpgradeable", addresses.voting),
    ethers.getContractAt("PoPVerifierUpgradeable", addresses.verifier),
  ]);
  const [rolesOwner, ideaFundingPool, ideaMinStake, fundingUsdc, fundingReserve, fundingBalance, fundingPaused, votingPaused, trustedSigner] = await Promise.all([
    roles.owner(),
    idea.fundingPool(),
    idea.authorMinStake(),
    funding.usdc(),
    funding.protocolReserve(),
    funding.totalPoolBalance(),
    funding.isPaused(),
    voting.isPaused(),
    verifier.trustedSigner(),
  ]);
  const [ideaHumanVerifier, ideaHumanOnly, fundingFactory, votingHumanVerifier, votingHumanOnly] = await Promise.all([
    optionalRead("IdeaRegistry human verifier", () => idea.humanVerifier()),
    optionalRead("IdeaRegistry human-only", () => idea.humanOnlyIdeaCreation()),
    optionalRead("FundingPool V3 Factory", () => funding.communityFactory()),
    optionalRead("Voting human verifier", () => voting.humanVerifier()),
    optionalRead("Voting human-only", () => voting.humanOnlyVoting()),
  ]);

  if (fundingUsdc.toLowerCase() !== addresses.usdc.toLowerCase()) {
    throw new Error(`FundingPool USDC mismatch: ${fundingUsdc} != ${addresses.usdc}`);
  }

  console.log("\nV2 state snapshot");
  console.log(`  RolesRegistry owner:          ${rolesOwner}`);
  console.log(`  IdeaRegistry funding pool:    ${ideaFundingPool}`);
  console.log(`  IdeaRegistry min stake:       ${ideaMinStake}`);
  console.log(`  IdeaRegistry human verifier:  ${ideaHumanVerifier}`);
  console.log(`  IdeaRegistry human-only:      ${ideaHumanOnly}`);
  console.log(`  FundingPool USDC:             ${fundingUsdc}`);
  console.log(`  FundingPool reserve:          ${fundingReserve}`);
  console.log(`  FundingPool total balance:    ${fundingBalance}`);
  console.log(`  FundingPool paused:           ${fundingPaused}`);
  console.log(`  FundingPool V3 Factory:       ${fundingFactory}`);
  console.log(`  Voting human verifier:        ${votingHumanVerifier}`);
  console.log(`  Voting human-only:            ${votingHumanOnly}`);
  console.log(`  Voting paused:                ${votingPaused}`);
  console.log(`  PoP trusted signer:           ${trustedSigner}`);
  console.log("\nPreflight passed. No on-chain state was changed.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
