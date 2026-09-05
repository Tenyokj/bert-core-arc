/**
 * @file verify-v3.ts
 * @notice Verifies deployed BERT V3 infrastructure and optional FundingPool integration.
 * @dev Run with: npx hardhat run scripts/deploy/verify-v3.ts --network <network>
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
  const factoryAddress = requiredAddress("V3_FACTORY_ADDRESS");
  const treasuryDeployerAddress = requiredAddress("V3_TREASURY_DEPLOYER_ADDRESS");

  if (!ethers.isAddress(factoryAddress) || !ethers.isAddress(treasuryDeployerAddress)) {
    throw new Error("V3 deployment addresses must be valid addresses");
  }

  const [factoryCode, treasuryDeployerCode] = await Promise.all([
    ethers.provider.getCode(factoryAddress),
    ethers.provider.getCode(treasuryDeployerAddress),
  ]);
  if (factoryCode === "0x" || treasuryDeployerCode === "0x") {
    throw new Error("V3 Factory or TreasuryDeployer has no deployed contract code");
  }

  const factory = await ethers.getContractAt("CommunityFactory", factoryAddress);
  const configuredTreasuryDeployer = await factory.communityTreasuryDeployer();
  if (ethers.getAddress(configuredTreasuryDeployer) !== ethers.getAddress(treasuryDeployerAddress)) {
    throw new Error("Factory points to a different CommunityTreasuryDeployer");
  }

  console.log("BERT V3 infrastructure verified");
  console.log("CommunityFactory:", ethers.getAddress(factoryAddress));
  console.log("CommunityTreasuryDeployer:", ethers.getAddress(treasuryDeployerAddress));
  console.log("Community count:", (await factory.communityCount()).toString());

  const fundingPoolAddress = process.env.FUNDING_POOL_ADDRESS?.trim();
  if (!fundingPoolAddress) return;
  if (!ethers.isAddress(fundingPoolAddress)) throw new Error("FUNDING_POOL_ADDRESS must be valid");

  const fundingPool = await ethers.getContractAt("FundingPoolUpgradeable", fundingPoolAddress);
  const configuredFactory = await fundingPool.communityFactory();
  if (ethers.getAddress(configuredFactory) !== ethers.getAddress(factoryAddress)) {
    throw new Error(`FundingPool is not configured for this Factory: ${configuredFactory}`);
  }

  console.log("FundingPool V3 integration verified");
  console.log("FundingPool:", ethers.getAddress(fundingPoolAddress));
  console.log("USDC:", await fundingPool.usdc());
  console.log("Protocol reserve:", (await fundingPool.protocolReserve()).toString());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
