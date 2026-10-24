/**
 * @file configure-v3-2-funding-pool.ts
 * @notice Additively authorizes the BERT V3.2 CommunityFactory to route
 *         Community protocol reserve into the V2 FundingPool.
 * @dev The FundingPool accepts reserve transfers only from active Treasuries
 *      registered by an explicitly approved Factory. This script never replaces
 *      a previously authorized V3.0/V3.1 Factory.
 * @dev Run with: npx hardhat run scripts/deploy/configure-v3-2-funding-pool.ts --network <network>
 */
import { hre } from "../../test/setup.js";

function requiredAddress(name: string): string {
  const value = process.env[name]?.trim();
  if (!value) throw new Error(`Missing required environment variable: ${name}`);
  return value;
}

async function main() {
  const { ethers } = await hre.network.connect();
  const [admin] = await ethers.getSigners();
  const fundingPoolAddress = requiredAddress("FUNDING_POOL_ADDRESS");
  const factoryAddress = requiredAddress("V3_2_FACTORY_ADDRESS");

  if (!ethers.isAddress(fundingPoolAddress) || !ethers.isAddress(factoryAddress)) {
    throw new Error("FUNDING_POOL_ADDRESS and V3_2_FACTORY_ADDRESS must be valid addresses");
  }
  if ((await ethers.provider.getCode(factoryAddress)) === "0x") {
    throw new Error("V3_2_FACTORY_ADDRESS has no deployed contract code");
  }

  const fundingPool = await ethers.getContractAt(
    "FundingPoolUpgradeable",
    fundingPoolAddress,
    admin,
  );
  const expectedFactory = ethers.getAddress(factoryAddress);
  const currentFactory = ethers.getAddress(await fundingPool.communityFactory());
  const alreadyApproved = await fundingPool.isCommunityFactoryApproved(expectedFactory);

  if (alreadyApproved) {
    console.log("FundingPool already allows V3.2 Factory:", expectedFactory);
    return;
  }

  console.log("Configuring FundingPool for BERT V3.2");
  console.log("FundingPool:", fundingPoolAddress);
  console.log("CommunityFactory:", expectedFactory);
  console.log("Protocol admin:", admin.address);

  const transaction = currentFactory === ethers.ZeroAddress
    ? await fundingPool.setCommunityFactory(expectedFactory)
    : await fundingPool.setCommunityFactoryApproval(expectedFactory, true);
  console.log("Transaction submitted:", transaction.hash);
  await transaction.wait();

  if (!(await fundingPool.isCommunityFactoryApproved(expectedFactory))) {
    throw new Error("FundingPool V3.2 Factory allowlist verification failed");
  }
  console.log("FundingPool now allows reserve transfers from active V3.2 Community Treasuries.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
