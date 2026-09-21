/**
 * @file configure-legacy-funding-proposal.ts
 * @notice Lets a legacy proposal author opt its own pending idea into BERT V2.2.
 * @dev The signer must be that idea's original author. This script sends one transaction.
 *
 * Run with:
 *   V2_LEGACY_IDEA_ID=1 V2_MINIMUM_NET_FUNDING_USDC=100 \
 *   npx hardhat run scripts/deploy/configure-legacy-funding-proposal.ts --network arcTestnet
 */
import { hre } from "../../test/setup.js";

const ARC_TESTNET_CHAIN_ID = 5_042_002n;

function requiredEnv(...names: string[]): string {
  for (const name of names) {
    const value = process.env[name]?.trim();
    if (value) return value;
  }
  throw new Error(`Missing required environment variable. Set one of: ${names.join(", ")}`);
}

async function main() {
  const connection = await hre.network.connect();
  const { ethers } = connection;
  const network = await ethers.provider.getNetwork();
  if (network.chainId !== ARC_TESTNET_CHAIN_ID) {
    throw new Error(`Wrong network: expected Arc Testnet (${ARC_TESTNET_CHAIN_ID}), got ${network.chainId}`);
  }

  const ideaId = BigInt(requiredEnv("V2_LEGACY_IDEA_ID"));
  const minimumNetFunding = ethers.parseUnits(requiredEnv("V2_MINIMUM_NET_FUNDING_USDC"), 6);
  if (ideaId === 0n || minimumNetFunding === 0n) {
    throw new Error("Idea ID and minimum net funding must both be greater than zero");
  }

  const ideaRegistryAddress = requiredEnv("IDEA_REGISTRY_PROXY_ADDRESS", "IDEA");
  const [signer] = await ethers.getSigners();
  const ideaRegistry = await ethers.getContractAt("IdeaRegistryUpgradeable", ideaRegistryAddress, signer);
  const [idea, firstConditionalFundingIdeaId, existingTarget] = await Promise.all([
    ideaRegistry.getIdea(ideaId),
    ideaRegistry.firstConditionalFundingIdeaId(),
    ideaRegistry.minimumNetFundingByIdea(ideaId),
  ]);
  const [, author, title, , , , , status] = idea;

  if (ideaId >= firstConditionalFundingIdeaId) {
    throw new Error(`Idea #${ideaId} is not a legacy idea; create it with createFundingProposal instead`);
  }
  if (author.toLowerCase() !== signer.address.toLowerCase()) {
    throw new Error(`Signer ${signer.address} is not the author of idea #${ideaId} (${author})`);
  }
  if (status !== 0n) throw new Error(`Idea #${ideaId} is not Pending (status ${status})`);
  if (existingTarget !== 0n) throw new Error(`Idea #${ideaId} already has target ${existingTarget}`);

  console.log(`Configuring legacy idea #${ideaId}: ${title}`);
  console.log(`Author: ${author}`);
  console.log(`Minimum net funding: ${minimumNetFunding} USDC base units`);
  const tx = await ideaRegistry.configureLegacyFundingProposal(ideaId, minimumNetFunding);
  console.log(`Transaction submitted: ${tx.hash}`);
  await tx.wait();
  console.log("Legacy proposal configured successfully.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
