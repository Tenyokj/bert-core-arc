import hre from "hardhat";
import "@nomicfoundation/hardhat-ethers";
import { runRollout } from "./rollout-v2-4.mjs";

async function main() {
  const { ethers } = await hre.network.getOrCreate();
  await runRollout(ethers.provider, async () => {
    const [signer] = await ethers.getSigners();
    if (!signer) throw new Error("No configured deployer signer");
    return signer;
  });
}

main().catch((error) => {
  console.error(error.shortMessage ?? error.message);
  process.exitCode = 1;
});
