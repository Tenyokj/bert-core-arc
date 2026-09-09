/**
 * @file deploy-v3.ts
 * @notice Deploys the reusable BERT V3 Community Layer infrastructure.
 * @dev Communities themselves are created later by their creators through CommunityFactory.
 * @dev Run with: npx hardhat run scripts/deploy/deploy-v3.ts --network <network>
 */
import { createRequire } from "module";
import { hre, type HardhatEthers } from "../../test/setup.js";

const require = createRequire(import.meta.url);
const transparentProxyArtifact = require(
  "@openzeppelin/contracts/build/contracts/TransparentUpgradeableProxy.json"
);

function getProxyAdminSlot(ethers: HardhatEthers): string {
  const slot = BigInt(ethers.keccak256(ethers.toUtf8Bytes("eip1967.proxy.admin"))) - 1n;
  return ethers.toBeHex(slot, 32);
}

async function readProxyAdmin(ethers: HardhatEthers, proxyAddress: string): Promise<string> {
  const stored = await ethers.provider.getStorage(proxyAddress, getProxyAdminSlot(ethers));
  return ethers.getAddress(ethers.dataSlice(stored, 12));
}

async function main() {
  const connection = await hre.network.connect();
  const { ethers } = connection;
  const [deployer] = await ethers.getSigners();
  const proxyAdminOwner =
    process.env.V3_PROXY_ADMIN_OWNER?.trim() ||
    process.env.PROXY_ADMIN_OWNER?.trim() ||
    deployer.address;
  const popVerifierAddress = process.env.POP_VERIFIER_ADDRESS?.trim();

  if (!ethers.isAddress(proxyAdminOwner)) {
    throw new Error("V3_PROXY_ADMIN_OWNER must be a valid address");
  }
  if (!popVerifierAddress || !ethers.isAddress(popVerifierAddress)) {
    throw new Error("POP_VERIFIER_ADDRESS must be a valid deployed PoPVerifier address");
  }
  if ((await ethers.provider.getCode(popVerifierAddress)) === "0x") {
    throw new Error("POP_VERIFIER_ADDRESS has no deployed contract code");
  }

  console.log("Deploying BERT V3 Community Layer infrastructure");
  console.log("Deployer:", deployer.address);
  console.log("CommunityFactory ProxyAdmin owner:", proxyAdminOwner);

  const adminActionsLibrary = await (
    await ethers.getContractFactory("CommunityAdminActions", deployer)
  ).deploy();
  await adminActionsLibrary.waitForDeployment();

  const treasuryDeployer = await (
    await ethers.getContractFactory("CommunityTreasuryDeployer", deployer)
  ).deploy();
  await treasuryDeployer.waitForDeployment();

  const factoryImplementation = await (
    await ethers.getContractFactory("CommunityFactory", deployer)
  ).deploy();
  await factoryImplementation.waitForDeployment();

  const initializeData = factoryImplementation.interface.encodeFunctionData("initialize", [
    await treasuryDeployer.getAddress(),
    popVerifierAddress,
  ]);
  const proxyFactory = new ethers.ContractFactory(
    transparentProxyArtifact.abi,
    transparentProxyArtifact.bytecode,
    deployer
  );
  const factoryProxy = await proxyFactory.deploy(
    await factoryImplementation.getAddress(),
    proxyAdminOwner,
    initializeData
  );
  await factoryProxy.waitForDeployment();

  const factoryProxyAddress = await factoryProxy.getAddress();
  const proxyAdminAddress = await readProxyAdmin(ethers, factoryProxyAddress);
  const factory = await ethers.getContractAt("CommunityFactory", factoryProxyAddress, deployer);

  if (
    ethers.getAddress(await factory.communityTreasuryDeployer()) !==
    ethers.getAddress(await treasuryDeployer.getAddress())
  ) {
    throw new Error("CommunityFactory initialization verification failed");
  }
  if (ethers.getAddress(await factory.humanVerifier()) !== ethers.getAddress(popVerifierAddress)) {
    throw new Error("CommunityFactory PoP verifier initialization verification failed");
  }

  const network = await ethers.provider.getNetwork();
  console.log("\nBERT V3 deployment complete");
  console.log("Chain ID:", network.chainId.toString());
  console.log("CommunityAdminActions library:", await adminActionsLibrary.getAddress());
  console.log("CommunityTreasuryDeployer:", await treasuryDeployer.getAddress());
  console.log("PoPVerifier:", await factory.humanVerifier());
  console.log("CommunityFactory implementation:", await factoryImplementation.getAddress());
  console.log("CommunityFactory proxy:", factoryProxyAddress);
  console.log("CommunityFactory ProxyAdmin:", proxyAdminAddress);
  console.log("\nSave these values:");
  console.log(`V3_TREASURY_DEPLOYER_ADDRESS=${await treasuryDeployer.getAddress()}`);
  console.log(`POP_VERIFIER_ADDRESS=${await factory.humanVerifier()}`);
  console.log(`V3_ADMIN_ACTIONS_LIBRARY_ADDRESS=${await adminActionsLibrary.getAddress()}`);
  console.log(`V3_FACTORY_ADDRESS=${factoryProxyAddress}`);
  console.log(`V3_FACTORY_IMPLEMENTATION_ADDRESS=${await factoryImplementation.getAddress()}`);
  console.log(`V3_FACTORY_PROXY_ADMIN_ADDRESS=${proxyAdminAddress}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
