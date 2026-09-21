/**
 * @file set-v2-ideas-per-round.ts
 * @notice Updates the V2 round size through the protocol-admin role.
 * @dev The V2.1 contract enforces the inclusive range 5..50. This script sends one transaction.
 *
 * Run with:
 *   V2_IDEAS_PER_ROUND=5 npx hardhat run scripts/deploy/set-v2-ideas-per-round.ts --network arcTestnet
 */
import { hre } from "../../test/setup.js";

const ARC_TESTNET_CHAIN_ID = 5_042_002n;

async function main() {
  const quantity = BigInt(process.env.V2_IDEAS_PER_ROUND ?? "");
  if (quantity < 5n || quantity > 50n) {
    throw new Error("V2_IDEAS_PER_ROUND must be between 5 and 50");
  }

  const connection = await hre.network.connect();
  const { ethers } = connection;
  const network = await ethers.provider.getNetwork();
  if (network.chainId !== ARC_TESTNET_CHAIN_ID) {
    throw new Error(`Wrong network: expected Arc Testnet (${ARC_TESTNET_CHAIN_ID}), got ${network.chainId}`);
  }

  const votingAddress = process.env.VOTING_PROXY_ADDRESS?.trim() || process.env.VOTING?.trim();
  if (!votingAddress) throw new Error("Set VOTING_PROXY_ADDRESS or VOTING");

  const [admin] = await ethers.getSigners();
  const voting = await ethers.getContractAt("VotingSystemUpgradeable", votingAddress, admin);
  const current = await voting.IDEAS_PER_ROUND();
  if (current === quantity) {
    console.log(`IDEAS_PER_ROUND is already ${quantity}; no transaction sent.`);
    return;
  }

  console.log(`Updating IDEAS_PER_ROUND: ${current} -> ${quantity}`);
  const tx = await voting.setIdeaPerRound(quantity);
  console.log(`Transaction submitted: ${tx.hash}`);
  await tx.wait();
  console.log(`IDEAS_PER_ROUND is now ${await voting.IDEAS_PER_ROUND()}.`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
