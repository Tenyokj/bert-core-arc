/**
 * @file deploy-pop-verifier.ts
 * @notice Deploys only PoPVerifierUpgradeable behind a TransparentUpgradeableProxy.
 * @dev Reads ProxyAdmin owner from CLI or env and initializes the verifier with
 *      the existing RolesRegistry plus a trusted signer address.
 * @dev Run with: npx hardhat run scripts/deploy/deploy-pop-verifier.ts --network arcTestnet -- --roles <address> --trustedSigner <address>
 */
import { createRequire } from "module";
import { hre, type HardhatEthers } from "../../test/setup.js";

const require = createRequire(import.meta.url);
const transparentProxyArtifact = require(
  "@openzeppelin/contracts/build/contracts/TransparentUpgradeableProxy.json"
);

type DeployedProxy = {
  proxyAddress: string;
  implAddress: string;
  proxyAdminAddress: string;
};

function getArg(flag: string): string | undefined {
  const idx = process.argv.indexOf(flag);
  if (idx === -1) return undefined;
  return process.argv[idx + 1];
}

function getProxyAdminSlot(ethers: HardhatEthers) {
  const adminSlot =
    BigInt(ethers.keccak256(ethers.toUtf8Bytes("eip1967.proxy.admin"))) - 1n;
  return ethers.toBeHex(adminSlot, 32);
}

async function readProxyAdmin(
  ethers: HardhatEthers,
  proxyAddress: string
): Promise<string> {
  const adminSlot = getProxyAdminSlot(ethers);
  const adminStorage = await ethers.provider.getStorage(proxyAddress, adminSlot);
  return ethers.getAddress(ethers.dataSlice(adminStorage, 12));
}

function parseArgs() {
  const rolesRegistryAddress =
    getArg("--roles") || process.env.ROLES_REGISTRY_ADDRESS;
  const trustedSignerAddress =
    getArg("--trustedSigner") || process.env.TRUSTED_SIGNER_ADDRESS;
  const initialOwner =
    getArg("--owner") ||
    process.env.PROXY_ADMIN_OWNER ||
    process.env.DEPLOYER_ADDRESS;

  if (!rolesRegistryAddress || !trustedSignerAddress) {
    console.error(`
🚀 Usage: npx hardhat run scripts/deploy/deploy-pop-verifier.ts --network <network> -- [OPTIONS]

Required:
  --roles <address>          Existing RolesRegistry proxy address
  --trustedSigner <address>  Trusted signer EVM address for backend payloads

Optional:
  --owner <address>          Owner for the auto-created ProxyAdmin

Environment fallbacks:
  ROLES_REGISTRY_ADDRESS, TRUSTED_SIGNER_ADDRESS, PROXY_ADMIN_OWNER
`);
    process.exit(1);
  }

  return {
    rolesRegistryAddress,
    trustedSignerAddress,
    initialOwner,
  };
}

async function deployProxy(
  ethers: HardhatEthers,
  name: string,
  initArgs: unknown[],
  initialOwner: string
): Promise<DeployedProxy> {
  const [deployer] = await ethers.getSigners();

  const implFactory = await ethers.getContractFactory(name, deployer);
  const impl = await implFactory.deploy();
  await impl.waitForDeployment();

  const initData = implFactory.interface.encodeFunctionData(
    "initialize",
    initArgs
  );

  const proxyFactory = new ethers.ContractFactory(
    transparentProxyArtifact.abi,
    transparentProxyArtifact.bytecode,
    deployer
  );
  const proxy = await proxyFactory.deploy(
    await impl.getAddress(),
    initialOwner,
    initData
  );
  await proxy.waitForDeployment();

  const proxyAddress = await proxy.getAddress();
  const proxyAdminAddress = await readProxyAdmin(ethers, proxyAddress);

  return {
    proxyAddress,
    implAddress: await impl.getAddress(),
    proxyAdminAddress,
  };
}

async function main() {
  const args = parseArgs();
  const connection = await hre.network.connect();
  const { ethers } = connection;
  const [deployer] = await ethers.getSigners();

  const initialOwner = args.initialOwner || deployer.address;

  console.log("🚀 Deploying PoPVerifierUpgradeable only");
  console.log("Deployer:", deployer.address);
  console.log("RolesRegistry:", args.rolesRegistryAddress);
  console.log("Trusted signer:", args.trustedSignerAddress);
  console.log("ProxyAdmin owner:", initialOwner);

  const popVerifier = await deployProxy(
    ethers,
    "PoPVerifierUpgradeable",
    [args.rolesRegistryAddress, args.trustedSignerAddress],
    initialOwner
  );

  const verifier = await ethers.getContractAt(
    "PoPVerifierUpgradeable",
    popVerifier.proxyAddress,
    deployer
  );

  console.log("\nDeployment summary:");
  console.log("PoPVerifierUpgradeable proxy:", popVerifier.proxyAddress);
  console.log("PoPVerifierUpgradeable implementation:", popVerifier.implAddress);
  console.log("PoPVerifierUpgradeable proxy admin:", popVerifier.proxyAdminAddress);
  console.log("Configured trusted signer:", await verifier.trustedSigner());
  console.log("\n🎉 PoPVerifier deployment complete");
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
