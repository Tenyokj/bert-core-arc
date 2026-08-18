/**
 * @file verify-deploy.ts
 * @notice Quick post-deploy checks for core proxies and role wiring.
 * @dev Uses env vars to locate deployed proxies.
 * @dev Run with: npx hardhat run scripts/verify-deploy.ts --network localhost
 */
import { hre } from "../../test/setup.js";

type AddrMap = {
  ROLES?: string;
  IDEA?: string;
  FUNDING?: string;
  VOTING?: string;
  GRANT?: string;
  REPUTATION?: string;
  VOTER?: string;
  POP?: string;
};

function getEnv(...names: string[]): string | undefined {
  for (const name of names) {
    const v = process.env[name];
    if (v) return v;
  }
  return undefined;
}

function normalizeAddress(ethers: any, v: string): string {
  // Accept lowercase or any-case; normalize to checksummed.
  return ethers.getAddress(v.toLowerCase());
}

async function main() {
  const connection = await hre.network.connect();
  const { ethers } = connection;
  const { network } = hre;

  const votingAddress = getEnv("VOTING", "VOTING_PROXY_ADDRESS");
  if (!votingAddress) {
    throw new Error("Missing voting address: set VOTING or VOTING_PROXY_ADDRESS");
  }

  const addrs: AddrMap = {
    ROLES: getEnv("ROLES", "ROLES_REGISTRY_ADDRESS"),
    IDEA: getEnv("IDEA", "IDEA_REGISTRY_ADDRESS"),
    FUNDING: getEnv("FUNDING", "FUNDING_POOL_ADDRESS"),
    VOTING: votingAddress,
    GRANT: getEnv("GRANT", "GRANT_MANAGER_ADDRESS"),
    REPUTATION: getEnv("REPUTATION", "REPUTATION_SYSTEM_ADDRESS"),
    VOTER: getEnv("VOTER", "VOTER_PROGRESSION_ADDRESS"),
    POP: getEnv("POP", "POP_VERIFIER_ADDRESS"),
  };

  for (const key of Object.keys(addrs) as (keyof AddrMap)[]) {
    const value = addrs[key];
    if (value) {
      addrs[key] = normalizeAddress(ethers, value);
    }
  }

    let networkName = "unknown";

  try {
    const network = await ethers.provider.getNetwork();
    networkName = network.name;
    if (networkName === "unknown" && network.chainId) {
      networkName = `chain-${network.chainId}`;
    }
  } catch (e2) {
    const networkArgIndex = process.argv.indexOf("--network");
    if (networkArgIndex !== -1 && process.argv[networkArgIndex + 1]) {
      networkName = process.argv[networkArgIndex + 1];
    }
  }

  console.log("🔍 Verify Deployment");
  console.log("Network:", networkName);
  console.log("Addresses:", addrs);

  const voting = await ethers.getContractAt(
    "VotingSystemUpgradeable",
    addrs.VOTING!,
  );

  if (!addrs.ROLES) {
    addrs.ROLES = normalizeAddress(ethers, await voting.roles());
  }
  if (!addrs.FUNDING) {
    addrs.FUNDING = normalizeAddress(ethers, await voting.fundingPool());
  }
  if (!addrs.IDEA) {
    addrs.IDEA = normalizeAddress(ethers, await voting.ideaRegistry());
  }
  if (!addrs.REPUTATION) {
    addrs.REPUTATION = normalizeAddress(ethers, await voting.reputationSystem());
  }
  if (!addrs.VOTER) {
    addrs.VOTER = normalizeAddress(ethers, await voting.voterProgression());
  }
  if (!addrs.POP) {
    const verifierAddress = await voting.humanVerifier();
    if (verifierAddress !== ethers.ZeroAddress) {
      addrs.POP = normalizeAddress(ethers, verifierAddress);
    }
  }

  console.log("\nResolved addresses:", addrs);

  const roles = await ethers.getContractAt(
    "RolesRegistryUpgradeable",
    addrs.ROLES!
  );

  const VOTING_ROLE = await roles.VOTING_ROLE();
  const GRANT_ROLE = await roles.GRANT_ROLE();
  const DISTRIBUTOR_ROLE = await roles.DISTRIBUTOR_ROLE();
  const IREGISTRY_ROLE = await roles.IREGISTRY_ROLE();
  const REPUTATION_MANAGER_ROLE = await roles.REPUTATION_MANAGER_ROLE();
  const AUTO_GRANT_ROLE = await roles.AUTO_GRANT_ROLE();

  console.log("\n✅ Role wiring");
  console.log(
    "VOTING_ROLE -> VotingSystem:",
    await roles.hasRole(VOTING_ROLE, addrs.VOTING!)
  );
  if (addrs.GRANT) {
    console.log(
      "GRANT_ROLE -> GrantManager:",
      await roles.hasRole(GRANT_ROLE, addrs.GRANT)
    );
    console.log(
      "DISTRIBUTOR_ROLE -> GrantManager:",
      await roles.hasRole(DISTRIBUTOR_ROLE, addrs.GRANT)
    );
  } else {
    console.log("GRANT_ROLE -> GrantManager: skipped (grant address not provided)");
    console.log("DISTRIBUTOR_ROLE -> GrantManager: skipped (grant address not provided)");
  }
  console.log(
    "IREGISTRY_ROLE -> IdeaRegistry:",
    await roles.hasRole(IREGISTRY_ROLE, addrs.IDEA!)
  );
  console.log(
    "REPUTATION_MANAGER_ROLE -> VotingSystem:",
    await roles.hasRole(REPUTATION_MANAGER_ROLE, addrs.VOTING!)
  );
  console.log(
    "REPUTATION_MANAGER_ROLE -> IdeaRegistry:",
    await roles.hasRole(REPUTATION_MANAGER_ROLE, addrs.IDEA!)
  );
  console.log(
    "AUTO_GRANT_ROLE -> VoterProgression:",
    await roles.hasRole(AUTO_GRANT_ROLE, addrs.VOTER!)
  );

  console.log("\n✅ Pause status");
  const funding = await ethers.getContractAt(
    "FundingPoolUpgradeable",
    addrs.FUNDING!
  );
  console.log("FundingPool paused:", await funding.paused());
  console.log("VotingSystem paused:", await voting.paused());
  if (addrs.GRANT) {
    const grant = await ethers.getContractAt(
      "GrantManagerUpgradeable",
      addrs.GRANT
    );
    console.log("GrantManager paused:", await grant.paused());
  } else {
    console.log("GrantManager paused: skipped (grant address not provided)");
  }

  console.log("\n✅ Voting params");
  console.log("IDEAS_PER_ROUND:", await voting.IDEAS_PER_ROUND());
  console.log("VOTING_DURATION:", await voting.VOTING_DURATION());
  console.log("minStake:", await voting.minStake());
  console.log("humanOnlyVoting:", await voting.humanOnlyVoting());
  console.log("humanVerifier:", await voting.humanVerifier());
  console.log(
    "maxVoteAmount (USDC):",
    ethers.formatUnits(await voting.maxVoteAmount(), 6)
  );

  if (addrs.POP) {
    console.log("\n✅ PoP verifier");
    const pop = await ethers.getContractAt(
      "PoPVerifierUpgradeable",
      addrs.POP
    );
    console.log("trustedSigner:", await pop.trustedSigner());
  } else {
    console.log("\n✅ PoP verifier: skipped (verifier not configured)");
  }
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
