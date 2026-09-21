/**
 * @file verify-v2-conditional-pledges.ts
 * @notice Read-only validation after the BERT V2.1 conditional-pledge upgrade.
 * @dev Run this before unpausing V2. It never sends a transaction.
 *
 * Run with:
 *   npx hardhat run scripts/deploy/verify-v2-conditional-pledges.ts --network arcTestnet
 */
import { hre } from "../../test/setup.js";

const ARC_TESTNET_CHAIN_ID = 5_042_002n;
const EIP1967_IMPLEMENTATION_SLOT =
  "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc";

function requiredAddress(...names: string[]): string {
  for (const name of names) {
    const value = process.env[name]?.trim();
    if (value) return value;
  }
  throw new Error(`Missing required address. Set one of: ${names.join(", ")}`);
}

function implementationFromSlot(ethers: Awaited<ReturnType<typeof hre.network.connect>>["ethers"], value: string): string {
  return ethers.getAddress(ethers.dataSlice(value, 12));
}

function assertAddress(label: string, actual: string, expected: string) {
  if (actual.toLowerCase() !== expected.toLowerCase()) {
    throw new Error(`${label} mismatch: ${actual} != ${expected}`);
  }
}

async function main() {
  const connection = await hre.network.connect();
  const { ethers } = connection;
  const network = await ethers.provider.getNetwork();

  if (network.chainId !== ARC_TESTNET_CHAIN_ID) {
    throw new Error(`Wrong network: expected Arc Testnet (${ARC_TESTNET_CHAIN_ID}), got ${network.chainId}`);
  }

  const addresses = {
    idea: requiredAddress("IDEA_REGISTRY_PROXY_ADDRESS", "IDEA"),
    funding: requiredAddress("FUNDING_POOL_ADDRESS", "FUNDING"),
    voting: requiredAddress("VOTING_PROXY_ADDRESS", "VOTING"),
    grant: requiredAddress("GRANT_MANAGER_ADDRESS", "GRANT"),
    usdc: requiredAddress("USDC_ADDRESS"),
  };

  const [idea, funding, voting, grant, usdc] = await Promise.all([
    ethers.getContractAt("IdeaRegistryUpgradeable", addresses.idea),
    ethers.getContractAt("FundingPoolUpgradeable", addresses.funding),
    ethers.getContractAt("VotingSystemUpgradeable", addresses.voting),
    ethers.getContractAt("GrantManagerUpgradeable", addresses.grant),
    new ethers.Contract(addresses.usdc, ["function balanceOf(address) view returns (uint256)"], ethers.provider),
  ]);

  const [ideaSlot, fundingSlot, votingSlot, grantSlot] = await Promise.all([
    ethers.provider.getStorage(addresses.idea, EIP1967_IMPLEMENTATION_SLOT),
    ethers.provider.getStorage(addresses.funding, EIP1967_IMPLEMENTATION_SLOT),
    ethers.provider.getStorage(addresses.voting, EIP1967_IMPLEMENTATION_SLOT),
    ethers.provider.getStorage(addresses.grant, EIP1967_IMPLEMENTATION_SLOT),
  ]);

  const [
    firstConditionalFundingIdeaId,
    pledgeFeeBps,
    totalPoolBalance,
    protocolReserve,
    usdcBalance,
    fundingIdeaRegistry,
    registryFundingPool,
    votingFundingPool,
    votingIdeaRegistry,
    grantVotingSystem,
    grantFundingPool,
    grantIdeaRegistry,
    fundingPaused,
    votingPaused,
    grantPaused,
  ] = await Promise.all([
    idea.firstConditionalFundingIdeaId(),
    funding.pledgeFeeBps(),
    funding.totalPoolBalance(),
    funding.protocolReserve(),
    usdc.balanceOf(addresses.funding),
    funding.ideaRegistry(),
    idea.fundingPool(),
    voting.fundingPool(),
    voting.ideaRegistry(),
    grant.votingSystem(),
    grant.fundingPool(),
    grant.ideaRegistry(),
    funding.isPaused(),
    voting.isPaused(),
    grant.isPaused(),
  ]);

  assertAddress("FundingPool.ideaRegistry", fundingIdeaRegistry, addresses.idea);
  assertAddress("IdeaRegistry.fundingPool", registryFundingPool, addresses.funding);
  assertAddress("VotingSystem.fundingPool", votingFundingPool, addresses.funding);
  assertAddress("VotingSystem.ideaRegistry", votingIdeaRegistry, addresses.idea);
  assertAddress("GrantManager.votingSystem", grantVotingSystem, addresses.voting);
  assertAddress("GrantManager.fundingPool", grantFundingPool, addresses.funding);
  assertAddress("GrantManager.ideaRegistry", grantIdeaRegistry, addresses.idea);

  if (firstConditionalFundingIdeaId === 0n) {
    throw new Error("IdeaRegistry migration initializer was not executed");
  }
  if (pledgeFeeBps > 1_000n) {
    throw new Error(`Unsafe pledge fee: ${pledgeFeeBps} bps`);
  }

  console.log("BERT V2.1 conditional-pledge postflight (read-only)");
  console.log(`Network: ${network.name} (${network.chainId})`);
  console.log("\nImplementations");
  console.log(`  IdeaRegistry: ${implementationFromSlot(ethers, ideaSlot)}`);
  console.log(`  FundingPool:  ${implementationFromSlot(ethers, fundingSlot)}`);
  console.log(`  VotingSystem: ${implementationFromSlot(ethers, votingSlot)}`);
  console.log(`  GrantManager: ${implementationFromSlot(ethers, grantSlot)}`);
  console.log("\nConditional-pledge configuration");
  console.log(`  Legacy/new idea boundary: ${firstConditionalFundingIdeaId}`);
  console.log(`  Pledge fee:               ${pledgeFeeBps} bps`);
  console.log("\nTreasury snapshot");
  console.log(`  FundingPool USDC:         ${usdcBalance}`);
  console.log(`  totalPoolBalance:         ${totalPoolBalance}`);
  console.log(`  protocolReserve:          ${protocolReserve}`);
  console.log("\nMaintenance state");
  console.log(`  FundingPool paused:       ${fundingPaused}`);
  console.log(`  VotingSystem paused:      ${votingPaused}`);
  console.log(`  GrantManager paused:      ${grantPaused}`);
  console.log("\nPostflight passed. Review the printed values before unpausing V2.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
