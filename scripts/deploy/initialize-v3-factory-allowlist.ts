/**
 * @file initialize-v3-factory-allowlist.ts
 * @notice Seeds the FundingPool multi-Factory allowlist from its existing V3.0 Factory.
 * @dev Run once after upgrading FundingPoolUpgradeable to the V3.1-compatible
 *      implementation and before allowlisting a V3.1 CommunityFactory.
 * @dev Run with: npx hardhat run scripts/deploy/initialize-v3-factory-allowlist.ts --network arcTestnet
 */
import { hre } from "../../test/setup.js";

const ARC_TESTNET_CHAIN_ID = 5_042_002n;

function requiredAddress(name: string): string {
  const value = process.env[name]?.trim();
  if (!value) throw new Error(`Missing required environment variable: ${name}`);
  return value;
}

async function main() {
  const { ethers } = await hre.network.connect();
  const network = await ethers.provider.getNetwork();
  if (network.chainId !== ARC_TESTNET_CHAIN_ID) {
    throw new Error(`Wrong network: expected Arc Testnet (${ARC_TESTNET_CHAIN_ID}), got ${network.chainId}`);
  }

  const [admin] = await ethers.getSigners();
  const fundingPoolAddress = requiredAddress("FUNDING_POOL_ADDRESS");
  if (!ethers.isAddress(fundingPoolAddress)) {
    throw new Error("FUNDING_POOL_ADDRESS must be a valid address");
  }

  const fundingPool = await ethers.getContractAt(
    "FundingPoolUpgradeable",
    fundingPoolAddress,
    admin,
  );
  const [paused, legacyFactory] = await Promise.all([
    fundingPool.isPaused(),
    fundingPool.communityFactory(),
  ]);
  const normalizedLegacyFactory = ethers.getAddress(legacyFactory);

  if (!paused) {
    throw new Error("FundingPool must be paused before migrating Factory authorization");
  }
  if (normalizedLegacyFactory === ethers.ZeroAddress) {
    throw new Error("No legacy CommunityFactory is configured; do not run this migration");
  }
  if ((await ethers.provider.getCode(normalizedLegacyFactory)) === "0x") {
    throw new Error("Configured legacy CommunityFactory has no deployed code");
  }

  console.log("BERT V3.1 Factory allowlist migration");
  console.log(`Network: ${network.name} (${network.chainId})`);
  console.log(`Protocol admin signer: ${admin.address}`);
  console.log(`FundingPool: ${fundingPoolAddress}`);
  console.log(`Legacy V3.0 Factory: ${normalizedLegacyFactory}`);

  if (await fundingPool.isCommunityFactoryApproved(normalizedLegacyFactory)) {
    console.log("Legacy Factory is already allowlisted; no initializer transaction sent.");
    return;
  }

  const transaction = await fundingPool.initializeCommunityFactoryAllowlist();
  console.log(`Allowlist initializer submitted: ${transaction.hash}`);
  await transaction.wait();

  const [stillPaused, allowlisted] = await Promise.all([
    fundingPool.isPaused(),
    fundingPool.isCommunityFactoryApproved(normalizedLegacyFactory),
  ]);
  if (!stillPaused || !allowlisted) {
    throw new Error("Factory allowlist migration postcondition failed; do not unpause FundingPool");
  }

  console.log("Legacy V3.0 Factory is allowlisted and FundingPool remains paused.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
