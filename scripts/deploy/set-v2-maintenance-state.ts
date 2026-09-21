/**
 * @file set-v2-maintenance-state.ts
 * @notice Pauses or unpauses the V2 modules as one operational unit.
 * @dev Must be run by a BERT protocol admin. It sends transactions.
 *
 * Run with:
 *   V2_MAINTENANCE_ACTION=pause npx hardhat run scripts/deploy/set-v2-maintenance-state.ts --network arcTestnet
 *   V2_MAINTENANCE_ACTION=unpause npx hardhat run scripts/deploy/set-v2-maintenance-state.ts --network arcTestnet
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
  const action = process.env.V2_MAINTENANCE_ACTION;
  if (action !== "pause" && action !== "unpause") {
    throw new Error("Set V2_MAINTENANCE_ACTION to exactly one of: pause, unpause");
  }

  const connection = await hre.network.connect();
  const { ethers } = connection;
  const network = await ethers.provider.getNetwork();
  if (network.chainId !== ARC_TESTNET_CHAIN_ID) {
    throw new Error(`Wrong network: expected Arc Testnet (${ARC_TESTNET_CHAIN_ID}), got ${network.chainId}`);
  }

  const [admin] = await ethers.getSigners();
  const modules = await Promise.all([
    ethers.getContractAt("FundingPoolUpgradeable", requiredAddress("FUNDING_POOL_ADDRESS", "FUNDING"), admin),
    ethers.getContractAt("VotingSystemUpgradeable", requiredAddress("VOTING_PROXY_ADDRESS", "VOTING"), admin),
    ethers.getContractAt("GrantManagerUpgradeable", requiredAddress("GRANT_MANAGER_ADDRESS", "GRANT"), admin),
  ]);

  console.log(`BERT V2 ${action}: ${admin.address}`);
  for (const module of modules) {
    const address = await module.getAddress();
    const paused = await module.isPaused();
    if ((action === "pause" && paused) || (action === "unpause" && !paused)) {
      console.log(`Skipping ${address}; already ${action === "pause" ? "paused" : "unpaused"}.`);
      continue;
    }
    const tx = await module[action]();
    console.log(`${action} submitted for ${address}: ${tx.hash}`);
    await tx.wait();
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
