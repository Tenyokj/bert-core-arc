/**
 * @file configure-v2-3-backer-milestones.ts
 * @notice Applies the V2.3 settings that cannot be initialized through a proxy upgrade.
 * @dev Run only while VotingSystem is paused. Existing rounds keep their stored rules.
 *
 * Run with:
 *   VOTING_PROXY_ADDRESS=<proxy> \
 *   POP_VERIFIER_ADDRESS=<verifier> \
 *   npx hardhat run scripts/deploy/configure-v2-3-backer-milestones.ts --network arcTestnet
 */
import { hre } from "../../test/setup.js";

const ARC_TESTNET_CHAIN_ID = 5_042_002n;

function requiredAddress(...names: string[]): string {
  for (const name of names) {
    const value = process.env[name]?.trim();
    if (value) return value;
  }
  throw new Error(`Missing required address. Set one of: ${names.join(", ")}`);
}

async function main() {
  const connection = await hre.network.connect();
  const { ethers } = connection;
  const network = await ethers.provider.getNetwork();
  if (network.chainId !== ARC_TESTNET_CHAIN_ID) {
    throw new Error(`Wrong network: expected Arc Testnet (${ARC_TESTNET_CHAIN_ID}), got ${network.chainId}`);
  }

  const [admin] = await ethers.getSigners();
  const votingAddress = requiredAddress("VOTING_PROXY_ADDRESS", "VOTING");
  const desiredVerifier = process.env.POP_VERIFIER_ADDRESS?.trim();
  const durationDays = BigInt(process.env.V2_3_VOTING_DURATION_DAYS ?? "14");
  if (durationDays < 1n) throw new Error("V2_3_VOTING_DURATION_DAYS must be at least 1");

  const voting = await ethers.getContractAt("VotingSystemUpgradeable", votingAddress, admin);
  if (!(await voting.isPaused())) {
    throw new Error("VotingSystem must be paused before applying V2.3 configuration");
  }
  const nextRoundId = await voting.currentRoundId();
  if (nextRoundId > 1n) {
    const previousRound = await voting.getRoundInfo(nextRoundId - 1n);
    if (previousRound.active) {
      throw new Error("An active legacy round exists. End or cancel it before changing V2.3 participation rules.");
    }
  }

  console.log("BERT V2.3 backer-milestone configuration");
  console.log(`Network: ${network.name} (${network.chainId})`);
  console.log(`Protocol admin signer: ${admin.address}`);
  console.log(`VotingSystem proxy: ${votingAddress}`);

  let configuredVerifier = await voting.humanVerifier();
  if (desiredVerifier && ethers.getAddress(configuredVerifier) !== ethers.getAddress(desiredVerifier)) {
    const tx = await voting.setHumanVerifier(desiredVerifier);
    console.log(`Setting human verifier: ${tx.hash}`);
    await tx.wait();
    configuredVerifier = await voting.humanVerifier();
  }
  if (configuredVerifier === ethers.ZeroAddress) {
    throw new Error("VotingSystem has no human verifier. Set POP_VERIFIER_ADDRESS before enabling V2.3.");
  }

  if (!(await voting.humanOnlyVoting())) {
    const tx = await voting.setHumanOnlyVoting(true);
    console.log(`Enabling human-only voting: ${tx.hash}`);
    await tx.wait();
  }

  const desiredDuration = durationDays * 24n * 60n * 60n;
  if ((await voting.VOTING_DURATION()) !== desiredDuration) {
    const tx = await voting.setVotingDuration(desiredDuration);
    console.log(`Setting voting duration to ${durationDays} days: ${tx.hash}`);
    await tx.wait();
  }

  if (!(await voting.backerMilestonesEnabled())) {
    const tx = await voting.setBackerMilestonesEnabled(true);
    console.log(`Enabling backer milestones: ${tx.hash}`);
    await tx.wait();
  }

  const [paused, verifier, humanOnly, duration, backerMilestones] = await Promise.all([
    voting.isPaused(),
    voting.humanVerifier(),
    voting.humanOnlyVoting(),
    voting.VOTING_DURATION(),
    voting.backerMilestonesEnabled(),
  ]);
  if (!paused || verifier === ethers.ZeroAddress || !humanOnly || duration !== desiredDuration || !backerMilestones) {
    throw new Error("V2.3 postcondition failed; do not unpause VotingSystem");
  }

  console.log("V2.3 configuration complete.");
  console.log(`Human verifier: ${verifier}`);
  console.log(`Voting duration: ${duration / (24n * 60n * 60n)} days`);
  console.log("Backer milestones: enabled for subsequently started rounds only");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
