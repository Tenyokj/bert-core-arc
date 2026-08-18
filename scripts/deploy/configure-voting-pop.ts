/**
 * @file configure-voting-pop.ts
 * @notice Configures VotingSystemUpgradeable to use a deployed PoP verifier.
 * @dev Sets humanVerifier, humanOnlyVoting, and maxVoteAmount.
 * @dev Run with: npx hardhat run scripts/deploy/configure-voting-pop.ts --network arcTestnet -- --voting <address> --verifier <address>
 */
import { hre } from "../../test/setup.js";

function getArg(flag: string): string | undefined {
  const idx = process.argv.indexOf(flag);
  if (idx === -1) return undefined;
  return process.argv[idx + 1];
}

function parseArgs() {
  const votingProxy = getArg("--voting") || process.env.VOTING_PROXY_ADDRESS;
  const verifierProxy =
    getArg("--verifier") || process.env.POP_VERIFIER_ADDRESS;
  const humanOnlyVoting =
    getArg("--humanOnly") || process.env.HUMAN_ONLY_VOTING || "true";
  const maxVoteAmountUsdc =
    getArg("--maxVoteAmountUsdc") ||
    process.env.MAX_VOTE_AMOUNT_USDC ||
    "10000";

  if (!votingProxy || !verifierProxy) {
    console.error(`
🚀 Usage: npx hardhat run scripts/deploy/configure-voting-pop.ts --network <network> -- [OPTIONS]

Required:
  --voting <address>            VotingSystem proxy address
  --verifier <address>          PoPVerifier proxy address

Optional:
  --humanOnly <true|false>      Enable or disable human-only voting
  --maxVoteAmountUsdc <amount>  Per-vote cap in whole USDC units

Environment fallbacks:
  VOTING_PROXY_ADDRESS, POP_VERIFIER_ADDRESS, HUMAN_ONLY_VOTING, MAX_VOTE_AMOUNT_USDC
`);
    process.exit(1);
  }

  return {
    votingProxy,
    verifierProxy,
    humanOnlyVoting: humanOnlyVoting.toLowerCase() === "true",
    maxVoteAmountUsdc,
  };
}

async function main() {
  const args = parseArgs();
  const connection = await hre.network.connect();
  const { ethers } = connection;
  const [deployer] = await ethers.getSigners();

  console.log("🚀 Configuring voting PoP settings");
  console.log("Deployer:", deployer.address);
  console.log("VotingSystem:", args.votingProxy);
  console.log("PoPVerifier:", args.verifierProxy);
  console.log("Human-only voting:", args.humanOnlyVoting);
  console.log("Max vote amount (USDC):", args.maxVoteAmountUsdc);

  const voting = await ethers.getContractAt(
    "VotingSystemUpgradeable",
    args.votingProxy,
    deployer
  );

  await (await voting.setHumanVerifier(args.verifierProxy)).wait();
  console.log("✅ setHumanVerifier complete");

  await (await voting.setHumanOnlyVoting(args.humanOnlyVoting)).wait();
  console.log("✅ setHumanOnlyVoting complete");

  await (
    await voting.setMaxVoteAmount(
      ethers.parseUnits(args.maxVoteAmountUsdc, 6)
    )
  ).wait();
  console.log("✅ setMaxVoteAmount complete");

  console.log("\nFinal on-chain values:");
  console.log("humanVerifier:", await voting.humanVerifier());
  console.log("humanOnlyVoting:", await voting.humanOnlyVoting());
  console.log(
    "maxVoteAmount (USDC):",
    ethers.formatUnits(await voting.maxVoteAmount(), 6)
  );
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
