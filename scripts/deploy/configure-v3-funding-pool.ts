/**
 * @file configure-v3-funding-pool.ts
 * @notice Connects an already-upgraded V2 FundingPool proxy to BERT V3 CommunityFactory.
 * @dev Run this only after upgrade-proxy.ts has upgraded FundingPoolUpgradeable successfully.
 * @dev Run with: npx hardhat run scripts/deploy/configure-v3-funding-pool.ts --network <network>
 */
import { hre } from "../../test/setup.js";

function requiredAddress(name: string): string {
  const value = process.env[name]?.trim();
  if (!value) throw new Error(`Missing ${name}`);
  return value;
}

async function main() {
  const connection = await hre.network.connect();
  const { ethers } = connection;
  const [deployer] = await ethers.getSigners();
  const fundingPoolAddress = requiredAddress("FUNDING_POOL_ADDRESS");
  const factoryAddress = requiredAddress("V3_FACTORY_ADDRESS");

  if (!ethers.isAddress(fundingPoolAddress) || !ethers.isAddress(factoryAddress)) {
    throw new Error("FUNDING_POOL_ADDRESS and V3_FACTORY_ADDRESS must be valid addresses");
  }
  if ((await ethers.provider.getCode(factoryAddress)) === "0x") {
    throw new Error("V3_FACTORY_ADDRESS has no deployed contract code");
  }

  const fundingPool = await ethers.getContractAt(
    "FundingPoolUpgradeable",
    fundingPoolAddress,
    deployer
  );
  const currentFactory = await fundingPool.communityFactory();
  const expectedFactory = ethers.getAddress(factoryAddress);

  if (currentFactory !== ethers.ZeroAddress && ethers.getAddress(currentFactory) !== expectedFactory) {
    throw new Error(
      `FundingPool already points to ${currentFactory}; refusing to replace it automatically`
    );
  }
  if (ethers.getAddress(currentFactory) === expectedFactory) {
    console.log("FundingPool is already configured for this V3 Factory:", expectedFactory);
    return;
  }

  console.log("Configuring FundingPool V3 Factory");
  console.log("FundingPool:", fundingPoolAddress);
  console.log("CommunityFactory:", expectedFactory);
  console.log("Caller:", deployer.address);

  const tx = await fundingPool.setCommunityFactory(expectedFactory);
  console.log("Transaction:", tx.hash);
  await tx.wait();

  if (ethers.getAddress(await fundingPool.communityFactory()) !== expectedFactory) {
    throw new Error("FundingPool CommunityFactory verification failed");
  }
  console.log("FundingPool is configured for BERT V3.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
