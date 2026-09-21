/**
 * @file preflight-v2-conditional-pledges.ts
 * @notice Read-only readiness check before the BERT V2.1 conditional-pledge proxy upgrade.
 * @dev It never sends a transaction. Its snapshot is the baseline for post-upgrade validation.
 *
 * Run with:
 *   npx hardhat run scripts/deploy/preflight-v2-conditional-pledges.ts --network arcTestnet
 */
import { hre } from "../../test/setup.js";

const ARC_TESTNET_CHAIN_ID = 5_042_002n;
const EIP1967_ADMIN_SLOT =
  "0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103";
const EIP1967_IMPLEMENTATION_SLOT =
  "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc";

function requiredAddress(...names: string[]): string {
  for (const name of names) {
    const value = process.env[name]?.trim();
    if (value) return value;
  }
  throw new Error(`Missing required address. Set one of: ${names.join(", ")}`);
}

function addressFromSlot(ethers: Awaited<ReturnType<typeof hre.network.connect>>["ethers"], value: string): string {
  return ethers.getAddress(ethers.dataSlice(value, 12));
}

async function inspectProxy(
  ethers: Awaited<ReturnType<typeof hre.network.connect>>["ethers"],
  label: string,
  proxy: string
) {
  const [adminStorage, implementationStorage] = await Promise.all([
    ethers.provider.getStorage(proxy, EIP1967_ADMIN_SLOT),
    ethers.provider.getStorage(proxy, EIP1967_IMPLEMENTATION_SLOT),
  ]);
  const admin = addressFromSlot(ethers, adminStorage);
  const implementation = addressFromSlot(ethers, implementationStorage);
  const proxyAdmin = new ethers.Contract(admin, ["function owner() view returns (address)"], ethers.provider);
  const owner = await proxyAdmin.owner();

  console.log(`\n${label}`);
  console.log(`  Proxy:          ${proxy}`);
  console.log(`  Implementation: ${implementation}`);
  console.log(`  ProxyAdmin:     ${admin}`);
  console.log(`  Admin owner:    ${owner}`);

  return { admin, implementation, owner };
}

async function optionalRead<T>(label: string, read: () => Promise<T>): Promise<T | "not implemented"> {
  try {
    return await read();
  } catch {
    console.log(`  ${label}: not implemented by the current live implementation`);
    return "not implemented";
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

  for (const [label, value] of Object.entries(addresses)) {
    if (!ethers.isAddress(value)) throw new Error(`${label} is not a valid address: ${value}`);
  }

  console.log("BERT V2.1 conditional-pledge preflight (read-only)");
  console.log(`Network: ${network.name} (${network.chainId})`);

  const [ideaProxy, fundingProxy, votingProxy, grantProxy] = await Promise.all([
    inspectProxy(ethers, "IdeaRegistryUpgradeable", addresses.idea),
    inspectProxy(ethers, "FundingPoolUpgradeable", addresses.funding),
    inspectProxy(ethers, "VotingSystemUpgradeable", addresses.voting),
    inspectProxy(ethers, "GrantManagerUpgradeable", addresses.grant),
  ]);

  const expectedAdminOwner = process.env.PROXY_ADMIN_OWNER?.trim();
  if (expectedAdminOwner) {
    if (!ethers.isAddress(expectedAdminOwner)) throw new Error("PROXY_ADMIN_OWNER is not a valid address");
    for (const proxy of [ideaProxy, fundingProxy, votingProxy, grantProxy]) {
      if (proxy.owner.toLowerCase() !== expectedAdminOwner.toLowerCase()) {
        throw new Error(`ProxyAdmin owner mismatch: ${proxy.owner} != ${expectedAdminOwner}`);
      }
    }
  }

  const [idea, funding, voting, usdc] = await Promise.all([
    ethers.getContractAt("IdeaRegistryUpgradeable", addresses.idea),
    ethers.getContractAt("FundingPoolUpgradeable", addresses.funding),
    ethers.getContractAt("VotingSystemUpgradeable", addresses.voting),
    new ethers.Contract(addresses.usdc, ["function balanceOf(address) view returns (uint256)"], ethers.provider),
  ]);

  const [
    totalIdeas,
    lastUsedIdeaId,
    currentRoundId,
    ideasPerRound,
    votingDuration,
    fundingBalance,
    protocolReserve,
    usdcBalance,
    fundingPaused,
    votingPaused,
  ] = await Promise.all([
    idea.totalIdeas(),
    voting.lastUsedIdeaId(),
    voting.currentRoundId(),
    voting.IDEAS_PER_ROUND(),
    voting.VOTING_DURATION(),
    funding.totalPoolBalance(),
    funding.protocolReserve(),
    usdc.balanceOf(addresses.funding),
    funding.isPaused(),
    voting.isPaused(),
  ]);

  const latestRoundId = currentRoundId > 1n ? currentRoundId - 1n : 0n;
  const latestRound = latestRoundId > 0n
    ? await voting.getRoundInfo(latestRoundId)
    : undefined;
  const legacyQueueSize = totalIdeas > lastUsedIdeaId ? totalIdeas - lastUsedIdeaId : 0n;
  const pledgeFeeBps = await optionalRead("FundingPool pledge fee", () => funding.pledgeFeeBps());

  console.log("\nState snapshot - record these values before upgrade");
  console.log(`  USDC balance held by FundingPool: ${usdcBalance}`);
  console.log(`  FundingPool totalPoolBalance:     ${fundingBalance}`);
  console.log(`  FundingPool protocolReserve:      ${protocolReserve}`);
  console.log(`  FundingPool paused:               ${fundingPaused}`);
  console.log(`  FundingPool pledgeFeeBps:         ${pledgeFeeBps}`);
  console.log(`  Total ideas:                      ${totalIdeas}`);
  console.log(`  Last used legacy idea ID:          ${lastUsedIdeaId}`);
  console.log(`  Pending legacy queue size:         ${legacyQueueSize}`);
  console.log(`  Current round ID:                  ${currentRoundId}`);
  console.log(`  Ideas per round:                   ${ideasPerRound}`);
  console.log(`  Voting duration:                   ${votingDuration}`);
  console.log(`  VotingSystem paused:               ${votingPaused}`);

  if (latestRound) {
    const [, ideaIds, startTime, endTime, active, ended, totalVotes, winner] = latestRound;
    console.log("\nLatest legacy round");
    console.log(`  ID:          ${latestRoundId}`);
    console.log(`  Idea count:  ${ideaIds.length}`);
    console.log(`  Start:       ${startTime}`);
    console.log(`  End:         ${endTime}`);
    console.log(`  Active:      ${active}`);
    console.log(`  Ended:       ${ended}`);
    console.log(`  Total votes: ${totalVotes}`);
    console.log(`  Winner:      ${winner}`);
    if (active) {
      console.log("\nBLOCKER: an active legacy round must be resolved before the V2.1 upgrade.");
    }
  }

  if (legacyQueueSize > 0n) {
    console.log("\nLegacy proposal queue");
    const reportLimit = 50n;
    const reportCount = legacyQueueSize > reportLimit ? reportLimit : legacyQueueSize;

    for (let offset = 1n; offset <= reportCount; offset += 1n) {
      const ideaId = lastUsedIdeaId + offset;
      const [ideaData, authorBond] = await Promise.all([
        idea.getIdea(ideaId),
        funding.authorStakeByIdea(ideaId),
      ]);
      const [, author, title, , , , , status] = ideaData;
      console.log(`  #${ideaId} | author: ${author} | status: ${status} | author bond: ${authorBond}`);
      console.log(`       title: ${title}`);
    }

    if (legacyQueueSize > reportLimit) {
      console.log(`  ... ${legacyQueueSize - reportLimit} additional legacy ideas omitted.`);
    }

    console.log("\nMIGRATION REQUIRED: each eligible legacy proposal author must explicitly set a minimum net funding target after the upgrade.");
  }
  console.log("\nPreflight finished. No transaction was sent and no state was changed.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
