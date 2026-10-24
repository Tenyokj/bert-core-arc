/**
 * Deploys the isolated BERT V3.2 Community Layer infrastructure.
 *
 * V3.2 is a new Factory deployment. It never upgrades or modifies the legacy
 * V3.0/V3.1 testnet Factories, communities, or their Treasuries.
 *
 * Required environment variables:
 *   POP_VERIFIER_ADDRESS          Deployed shared PoP verifier.
 * Optional:
 *   V3_PROXY_ADMIN_OWNER          TransparentProxy admin owner.
 */
import { createRequire } from "module";

import { hre, type HardhatEthers } from "../../test/setup.js";

const require = createRequire(import.meta.url);
const transparentProxyArtifact = require(
  "@openzeppelin/contracts/build/contracts/TransparentUpgradeableProxy.json",
);

function proxyAdminSlot(ethers: HardhatEthers): string {
  const slot = BigInt(ethers.keccak256(ethers.toUtf8Bytes("eip1967.proxy.admin"))) - 1n;
  return ethers.toBeHex(slot, 32);
}

async function readProxyAdmin(ethers: HardhatEthers, proxy: string): Promise<string> {
  const stored = await ethers.provider.getStorage(proxy, proxyAdminSlot(ethers));
  return ethers.getAddress(ethers.dataSlice(stored, 12));
}

async function deploy(name: string, deployer: Awaited<ReturnType<HardhatEthers["getSigners"]>>[number]) {
  const contract = await (await hre.network.connect()).ethers.getContractFactory(name, deployer);
  const instance = await contract.deploy();
  await instance.waitForDeployment();
  return instance;
}

async function main() {
  const { ethers } = await hre.network.connect();
  const [deployer] = await ethers.getSigners();
  const proxyAdminOwner = process.env.V3_PROXY_ADMIN_OWNER?.trim()
    || process.env.PROXY_ADMIN_OWNER?.trim()
    || deployer.address;
  const popVerifier = process.env.POP_VERIFIER_ADDRESS?.trim();

  if (!ethers.isAddress(proxyAdminOwner)) throw new Error("V3_PROXY_ADMIN_OWNER must be a valid address");
  if (!popVerifier || !ethers.isAddress(popVerifier)) {
    throw new Error("POP_VERIFIER_ADDRESS must be a deployed PoP verifier address");
  }
  if ((await ethers.provider.getCode(popVerifier)) === "0x") {
    throw new Error("POP_VERIFIER_ADDRESS has no deployed contract code");
  }

  console.log("Deploying BERT V3.2 Community Layer infrastructure");
  console.log("Deployer:", deployer.address);
  console.log("CommunityFactory ProxyAdmin owner:", proxyAdminOwner);

  const adminActions = await deploy("CommunityAdminActions", deployer);
  const treasuryDeployer = await deploy("CommunityTreasuryDeployer", deployer);
  const membershipDeployer = await deploy("CommunityMembershipModuleDeployer", deployer);
  const proposalDeployer = await deploy("CommunityProposalModuleDeployer", deployer);
  const votingDeployer = await deploy("CommunityVotingModuleDeployer", deployer);
  const milestoneDeployer = await deploy("CommunityMilestoneModuleDeployer", deployer);

  const factoryImplementation = await (
    await ethers.getContractFactory("CommunityFactory", deployer)
  ).deploy();
  await factoryImplementation.waitForDeployment();

  const initData = factoryImplementation.interface.encodeFunctionData("initialize", [
    await treasuryDeployer.getAddress(),
    popVerifier,
    await membershipDeployer.getAddress(),
    await proposalDeployer.getAddress(),
    await votingDeployer.getAddress(),
    await milestoneDeployer.getAddress(),
  ]);
  const proxyFactory = new ethers.ContractFactory(
    transparentProxyArtifact.abi,
    transparentProxyArtifact.bytecode,
    deployer,
  );
  const proxy = await proxyFactory.deploy(
    await factoryImplementation.getAddress(),
    proxyAdminOwner,
    initData,
  );
  await proxy.waitForDeployment();
  const factoryDeploymentTransaction = proxy.deploymentTransaction();
  if (factoryDeploymentTransaction == null) {
    throw new Error("Missing CommunityFactory proxy deployment transaction");
  }
  const factoryDeploymentReceipt = await factoryDeploymentTransaction.wait();
  if (factoryDeploymentReceipt == null) {
    throw new Error("Missing CommunityFactory proxy deployment receipt");
  }

  const factoryAddress = await proxy.getAddress();
  const factory = await ethers.getContractAt("CommunityFactory", factoryAddress, deployer);
  const expected = [
    ["communityTreasuryDeployer", await treasuryDeployer.getAddress()],
    ["humanVerifier", popVerifier],
    ["membershipModuleDeployer", await membershipDeployer.getAddress()],
    ["proposalModuleDeployer", await proposalDeployer.getAddress()],
    ["votingModuleDeployer", await votingDeployer.getAddress()],
    ["milestoneModuleDeployer", await milestoneDeployer.getAddress()],
  ] as const;
  for (const [getter, address] of expected) {
    if (ethers.getAddress(await factory[getter]()) !== ethers.getAddress(address)) {
      throw new Error(`V3.2 Factory initialization failed for ${getter}`);
    }
  }

  const network = await ethers.provider.getNetwork();
  console.log("\nBERT V3.2 deployment complete");
  console.log("Chain ID:", network.chainId.toString());
  console.log("CommunityAdminActions library:", await adminActions.getAddress());
  console.log("CommunityFactory implementation:", await factoryImplementation.getAddress());
  console.log("CommunityFactory proxy:", factoryAddress);
  console.log("CommunityFactory ProxyAdmin:", await readProxyAdmin(ethers, factoryAddress));
  console.log("CommunityFactory deployment transaction:", factoryDeploymentTransaction.hash);
  console.log("CommunityFactory deployment block:", factoryDeploymentReceipt.blockNumber);
  console.log("\nSave these values:");
  console.log(`V3_2_FACTORY_ADDRESS=${factoryAddress}`);
  console.log(`V3_2_FACTORY_DEPLOYMENT_TRANSACTION=${factoryDeploymentTransaction.hash}`);
  console.log(`V3_2_FACTORY_START_BLOCK=${factoryDeploymentReceipt.blockNumber}`);
  console.log(`V3_2_TREASURY_DEPLOYER_ADDRESS=${await treasuryDeployer.getAddress()}`);
  console.log(`V3_2_MEMBERSHIP_MODULE_DEPLOYER_ADDRESS=${await membershipDeployer.getAddress()}`);
  console.log(`V3_2_PROPOSAL_MODULE_DEPLOYER_ADDRESS=${await proposalDeployer.getAddress()}`);
  console.log(`V3_2_VOTING_MODULE_DEPLOYER_ADDRESS=${await votingDeployer.getAddress()}`);
  console.log(`V3_2_MILESTONE_MODULE_DEPLOYER_ADDRESS=${await milestoneDeployer.getAddress()}`);
  console.log(`V3_2_ADMIN_ACTIONS_LIBRARY_ADDRESS=${await adminActions.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
