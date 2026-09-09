/**
 * @file configure-voting-pop.ts
 * @notice Configures V2 voting and idea creation to use one deployed PoP verifier.
 * @dev Sets the shared verifier and independently configurable human-only participation gates.
 * @dev Run with: npx hardhat run scripts/deploy/configure-voting-pop.ts --network arcTestnet -- --voting <address> --ideaRegistry <address> --verifier <address>
 */
import { hre } from "../../test/setup.js";

function getArg(flag: string): string | undefined {
  const idx = process.argv.indexOf(flag);
  if (idx === -1) return undefined;
  return process.argv[idx + 1];
}

function parseArgs() {
  const votingProxy = getArg("--voting") || process.env.VOTING_PROXY_ADDRESS;
  const ideaRegistryProxy =
    getArg("--ideaRegistry") || process.env.IDEA_REGISTRY_PROXY_ADDRESS;
  const verifierProxy =
    getArg("--verifier") || process.env.POP_VERIFIER_ADDRESS;
  const humanOnlyVoting =
    getArg("--humanOnly") || process.env.HUMAN_ONLY_VOTING || "true";
  const maxVoteAmountUsdc =
    getArg("--maxVoteAmountUsdc") ||
    process.env.MAX_VOTE_AMOUNT_USDC ||
    "10000";
  const humanOnlyIdeaCreation =
    getArg("--humanOnlyIdeaCreation") || process.env.HUMAN_ONLY_IDEA_CREATION || "true";

  if ((!votingProxy && !ideaRegistryProxy) || !verifierProxy) {
    console.error(`
🚀 Usage: npx hardhat run scripts/deploy/configure-voting-pop.ts --network <network> -- [OPTIONS]

Required:
  --verifier <address>          PoPVerifier proxy address

At least one target:
  --voting <address>            VotingSystem proxy address
  --ideaRegistry <address>      IdeaRegistry proxy address

Optional:
  --humanOnly <true|false>      Enable or disable human-only voting
  --humanOnlyIdeaCreation <true|false> Enable or disable human-only idea creation
  --maxVoteAmountUsdc <amount>  Per-vote cap in whole USDC units

Environment fallbacks:
  VOTING_PROXY_ADDRESS, IDEA_REGISTRY_PROXY_ADDRESS, POP_VERIFIER_ADDRESS,
  HUMAN_ONLY_VOTING, HUMAN_ONLY_IDEA_CREATION, MAX_VOTE_AMOUNT_USDC
`);
    process.exit(1);
  }

  return {
    votingProxy,
    ideaRegistryProxy,
    verifierProxy,
    humanOnlyVoting: humanOnlyVoting.toLowerCase() === "true",
    maxVoteAmountUsdc,
    humanOnlyIdeaCreation: humanOnlyIdeaCreation.toLowerCase() === "true",
  };
}

async function main() {
  const args = parseArgs();
  const connection = await hre.network.connect();
  const { ethers } = connection;
  const [deployer] = await ethers.getSigners();

  console.log("🚀 Configuring V2 PoP settings");
  console.log("Deployer:", deployer.address);
  console.log("VotingSystem:", args.votingProxy || "not configured");
  console.log("IdeaRegistry:", args.ideaRegistryProxy || "not configured");
  console.log("PoPVerifier:", args.verifierProxy);
  console.log("Human-only voting:", args.humanOnlyVoting);
  console.log("Human-only idea creation:", args.humanOnlyIdeaCreation);
  console.log("Max vote amount (USDC):", args.maxVoteAmountUsdc);

  if (args.votingProxy) {
    const voting = await ethers.getContractAt("VotingSystemUpgradeable", args.votingProxy, deployer);
    await (await voting.setHumanVerifier(args.verifierProxy)).wait();
    await (await voting.setHumanOnlyVoting(args.humanOnlyVoting)).wait();
    await (await voting.setMaxVoteAmount(ethers.parseUnits(args.maxVoteAmountUsdc, 6))).wait();
    console.log("✅ VotingSystem PoP settings configured");
  }

  if (args.ideaRegistryProxy) {
    const ideaRegistry = await ethers.getContractAt(
      "IdeaRegistryUpgradeable",
      args.ideaRegistryProxy,
      deployer
    );
    await (await ideaRegistry.setHumanVerifier(args.verifierProxy)).wait();
    await (await ideaRegistry.setHumanOnlyIdeaCreation(args.humanOnlyIdeaCreation)).wait();
    console.log("✅ IdeaRegistry PoP settings configured");
  }
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
