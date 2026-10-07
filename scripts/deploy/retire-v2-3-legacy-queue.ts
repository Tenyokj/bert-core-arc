/**
 * @file retire-v2-3-legacy-queue.ts
 * @notice Retires the fixed pre-V2.3 test queue after the IdeaRegistry and VotingSystem upgrades.
 * @dev The script returns legacy author bonds and advances the round cursor only while voting is paused.
 *
 * Run with:
 *   IDEA_REGISTRY_PROXY_ADDRESS=0x... VOTING_SYSTEM_PROXY_ADDRESS=0x... \
 *   npx hardhat run scripts/deploy/retire-v2-3-legacy-queue.ts --network arcTestnet
 */
import { hre } from "../../test/setup.js";

const ARC_TESTNET_CHAIN_ID = 5_042_002n;
const PENDING_STATUS = 0n;
const CANCELLED_STATUS = 7n;

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
  const ideaAddress = requiredAddress("IDEA_REGISTRY_PROXY_ADDRESS", "IDEA");
  const votingAddress = requiredAddress("VOTING_SYSTEM_PROXY_ADDRESS", "VOTING");
  const [idea, voting] = await Promise.all([
    ethers.getContractAt("IdeaRegistryUpgradeable", ideaAddress, admin),
    ethers.getContractAt("VotingSystemUpgradeable", votingAddress, admin),
  ]);

  const [boundary, registryRetired, votingSkipped, currentRoundId, lastUsedIdeaId, votingPaused] = await Promise.all([
    idea.firstConditionalFundingIdeaId(),
    idea.legacyFundingQueueRetired(),
    voting.legacyFundingQueueSkipped(),
    voting.currentRoundId(),
    voting.lastUsedIdeaId(),
    voting.paused(),
  ]);

  console.log("BERT V2.3 legacy queue retirement");
  console.log(`Network: ${network.name} (${network.chainId})`);
  console.log(`Protocol admin signer: ${admin.address}`);
  console.log(`Legacy/new boundary: ${boundary}`);
  console.log(`Voting paused: ${votingPaused}`);

  if (!votingPaused) throw new Error("VotingSystem must be paused before retiring the legacy queue");
  if (boundary <= 1n) throw new Error("No pre-V2.3 proposal range is available for retirement");
  if (registryRetired || votingSkipped) throw new Error("Legacy queue retirement was already processed");
  if (currentRoundId !== 1n || lastUsedIdeaId !== 0n) {
    throw new Error(`Queue cursor is no longer pristine: round=${currentRoundId}, lastUsedIdeaId=${lastUsedIdeaId}`);
  }

  for (let ideaId = 1n; ideaId < boundary; ideaId += 1n) {
    const status = await idea.getStatus(ideaId);
    if (status !== PENDING_STATUS) {
      throw new Error(`Legacy idea #${ideaId} is not pending (status ${status}); refusing to retire queue`);
    }
  }

  const retireTx = await idea.retireLegacyFundingQueue();
  console.log(`IdeaRegistry retirement submitted: ${retireTx.hash}`);
  await retireTx.wait();

  const skipTx = await voting.skipRetiredLegacyFundingQueue();
  console.log(`VotingSystem cursor migration submitted: ${skipTx.hash}`);
  await skipTx.wait();

  const [retiredAfter, skippedAfter, cursorAfter] = await Promise.all([
    idea.legacyFundingQueueRetired(),
    voting.legacyFundingQueueSkipped(),
    voting.lastUsedIdeaId(),
  ]);
  if (!retiredAfter || !skippedAfter || cursorAfter !== boundary - 1n) {
    throw new Error("Legacy queue retirement postcondition failed; do not unpause V2");
  }

  for (let ideaId = 1n; ideaId < boundary; ideaId += 1n) {
    const status = await idea.getStatus(ideaId);
    if (status !== CANCELLED_STATUS) {
      throw new Error(`Legacy idea #${ideaId} was not retired (status ${status}); do not unpause V2`);
    }
  }

  console.log(`Legacy queue retired successfully. The next eligible V2.3 proposal ID is ${boundary}.`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
