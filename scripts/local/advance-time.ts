/**
 * @file advance-time.ts
 * @notice Advances a local Hardhat node clock for E2E deadline testing.
 * @dev This script cannot run outside chain ID 31337.
 * @dev Run: LOCAL_ADVANCE_SECONDS=86401 npx hardhat run scripts/local/advance-time.ts --network localhost
 */
import { hre } from "../../test/setup.js";

async function main() {
  const { ethers } = await hre.network.connect();
  const network = await ethers.provider.getNetwork();
  if (network.chainId !== 31337n) {
    throw new Error("Local time advancement is restricted to chain ID 31337.");
  }

  const rawSeconds = process.env.LOCAL_ADVANCE_SECONDS?.trim();
  if (!rawSeconds || !/^\d+$/.test(rawSeconds) || BigInt(rawSeconds) < 1n) {
    throw new Error("Set LOCAL_ADVANCE_SECONDS to a positive whole number.");
  }
  const seconds = Number(rawSeconds);
  if (!Number.isSafeInteger(seconds)) {
    throw new Error("LOCAL_ADVANCE_SECONDS is too large for the local RPC request.");
  }

  const before = await ethers.provider.getBlock("latest");
  await ethers.provider.send("evm_increaseTime", [seconds]);
  await ethers.provider.send("evm_mine", []);
  const after = await ethers.provider.getBlock("latest");
  console.log(`Advanced local time by ${seconds} seconds: ${before?.timestamp ?? "?"} -> ${after?.timestamp ?? "?"}.`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
