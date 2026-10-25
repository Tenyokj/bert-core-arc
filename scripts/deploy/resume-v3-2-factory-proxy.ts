/**
 * Finishes only the Factory proxy from the recorded partial Arc deployment.
 * Defaults to read-only preflight; V3_2_RESUME_SEND=true explicitly enables one
 * creation transaction. It never redeploys components or alters the allowlist.
 */
import assert from "node:assert/strict";
import { mkdir, readFile, writeFile } from "node:fs/promises";
import { createRequire } from "node:module";
import { hre } from "../../test/setup.js";

const require = createRequire(import.meta.url);
const partial = require("../../deployments/arc-testnet-v3-2-1-partial.json");
const proxyArtifact = require("@openzeppelin/contracts/build/contracts/TransparentUpgradeableProxy.json");

async function main() {
  const { ethers } = await hre.network.connect();
  const provider = ethers.provider;
  assert.equal((await provider.getNetwork()).chainId, 5_042_002n, "This recovery is Arc Testnet only");
  const [deployer] = await ethers.getSigners();
  assert.equal(ethers.getAddress(deployer.address), ethers.getAddress(partial.deployer), "Wrong recovery signer");
  for (const [key, expected] of [["POP_VERIFIER_ADDRESS", partial.humanVerifier], ["V3_PROXY_ADMIN_OWNER", partial.proxyAdminOwner]]) {
    if (process.env[key]) assert.equal(ethers.getAddress(process.env[key]!), ethers.getAddress(expected), `${key} differs from the recorded deployment`);
  }
  assert.ok([undefined, "true", "false"].includes(process.env.V3_2_RESUME_SEND), "V3_2_RESUME_SEND must be true or false");
  assert.notEqual(await provider.getCode(partial.humanVerifier), "0x", "Verifier has no code");
  const addresses = new Map<string, string>();
  for (const component of partial.components) {
    assert.equal(ethers.getCreateAddress({ from: deployer.address, nonce: component.nonce }), ethers.getAddress(component.address), "Component creation address mismatch");
    const code = await provider.getCode(component.address);
    assert.equal(ethers.keccak256(code), component.runtimeHash, `${component.name}: on-chain bytecode changed or missing`);
    const artifact = JSON.parse(await readFile(new URL(`../../artifacts/contracts/BERT/V3/${component.directory}/${component.name}.sol/${component.name}.json`, import.meta.url), "utf8"));
    // Solidity libraries embed their own address into the first PUSH20 instruction.
    const expected = component.name === "CommunityAdminActions"
      ? "0x73" + component.address.slice(2) + artifact.deployedBytecode.slice(44)
      : artifact.deployedBytecode;
    assert.equal(ethers.keccak256(expected), component.runtimeHash, `${component.name}: compiled artifact is not the recovered release`);
    addresses.set(component.name, component.address);
    console.log("Verified existing component:", component.name, component.address);
  }
  const addressOf = (name: string) => {
    const address = addresses.get(name);
    assert.ok(address, `Missing ${name}`);
    return address;
  };
  const implementation = addressOf("CommunityFactory");
  const expectedProxy = ethers.getCreateAddress({ from: deployer.address, nonce: partial.proxyNonce });
  const factoryImplementation = await ethers.getContractAt("CommunityFactory", implementation, deployer);
  const initialization = [
    addressOf("CommunityTreasuryDeployer"), partial.humanVerifier,
    addressOf("CommunityMembershipModuleDeployer"), addressOf("CommunityProposalModuleDeployer"),
    addressOf("CommunityVotingModuleDeployer"), addressOf("CommunityMilestoneModuleDeployer"),
  ];
  async function verifyProxy() {
    const slot = (label: string) => ethers.toBeHex(BigInt(ethers.keccak256(ethers.toUtf8Bytes(label))) - 1n, 32);
    const storedImplementation = await provider.getStorage(expectedProxy, slot("eip1967.proxy.implementation"));
    assert.equal(ethers.getAddress(ethers.dataSlice(storedImplementation, 12)), implementation, "Wrong proxy implementation");
    const storedAdmin = await provider.getStorage(expectedProxy, slot("eip1967.proxy.admin"));
    const adminAddress = ethers.getAddress(ethers.dataSlice(storedAdmin, 12));
    const admin = new ethers.Contract(adminAddress, ["function owner() view returns (address)"], provider);
    assert.equal(ethers.getAddress(await admin.owner()), ethers.getAddress(partial.proxyAdminOwner), "Wrong ProxyAdmin owner");
    const factory = await ethers.getContractAt("CommunityFactory", expectedProxy, deployer);
    for (const [index, getter] of ["communityTreasuryDeployer", "humanVerifier", "membershipModuleDeployer", "proposalModuleDeployer", "votingModuleDeployer", "milestoneModuleDeployer"].entries()) {
      assert.equal(ethers.getAddress(await factory[getter]()), ethers.getAddress(initialization[index]), `Wrong ${getter}`);
    }
    console.log("Verified CommunityFactory ProxyAdmin:", adminAddress);
  }
  console.log("Factory proxy candidate (not deployment evidence):", expectedProxy);
  if (await provider.getCode(expectedProxy) !== "0x") {
    await verifyProxy();
    console.log("Matching Factory proxy already exists. No transaction sent.");
    console.log(`V3_2_FACTORY_ADDRESS=${expectedProxy}`);
    return;
  }
  async function checkNonce() {
    assert.equal(await provider.getTransactionCount(deployer.address, "latest"), partial.proxyNonce, "Sender nonce changed: stop and reassess; do not redeploy components");
    assert.equal(await provider.getTransactionCount(deployer.address, "pending"), partial.proxyNonce, "Pending transaction exists: do not broadcast again");
  }
  await checkNonce();
  const proxyFactory = new ethers.ContractFactory(proxyArtifact.abi, proxyArtifact.bytecode, deployer);
  const args = [implementation, partial.proxyAdminOwner, factoryImplementation.interface.encodeFunctionData("initialize", initialization)] as const;
  const request = await proxyFactory.getDeployTransaction(...args);
  const balance = await provider.getBalance(deployer.address);
  console.log("Native test USDC balance:", ethers.formatUnits(balance, 18));
  const estimatedGas = await provider.estimateGas({ ...request, from: deployer.address });
  const gasLimit = (estimatedGas * 120n + 99n) / 100n;
  const fees = await provider.getFeeData();
  const gasPrice = fees.maxFeePerGas ?? fees.gasPrice;
  assert.ok(gasPrice !== null && gasPrice > 0n, "Gas fee data unavailable");
  const required = gasLimit * gasPrice;
  console.log("Estimated maximum coverage with 20% gas-limit margin (test USDC):", ethers.formatUnits(required, 18));
  if (process.env.V3_2_RESUME_SEND !== "true") {
    console.log("Read-only preflight completed. No transaction sent.");
    return;
  }
  assert.ok(balance >= required, "Insufficient test USDC; fund the recorded deployer via the faucet first");
  await checkNonce();
  const feeOptions = fees.maxFeePerGas !== null
    ? { maxFeePerGas: fees.maxFeePerGas, maxPriorityFeePerGas: fees.maxPriorityFeePerGas ?? 0n }
    : { gasPrice };
  // Bind this send to the already checked next nonce; never bump or replace it.
  const proxy = await proxyFactory.deploy(...args, { nonce: partial.proxyNonce, gasLimit, ...feeOptions });
  const transaction = proxy.deploymentTransaction();
  assert.ok(transaction);
  await mkdir("cache", { recursive: true });
  const record = { chainId: partial.chainId, proxy: expectedProxy, implementation, transaction: transaction.hash };
  await writeFile("cache/v3-2-proxy-recovery.json", JSON.stringify(record, null, 2));
  console.log("Factory proxy transaction:", transaction.hash);
  const receipt = await transaction.wait();
  assert.ok(receipt && receipt.status === 1, "Factory proxy receipt was not successful");
  assert.equal(ethers.getAddress(receipt.contractAddress!), expectedProxy, "Unexpected creation address");
  await verifyProxy();
  await writeFile("cache/v3-2-proxy-recovery.json", JSON.stringify({ ...record, blockNumber: receipt.blockNumber, status: receipt.status }, null, 2));
  console.log(`V3_2_FACTORY_ADDRESS=${expectedProxy}`);
  console.log(`V3_2_FACTORY_DEPLOYMENT_TRANSACTION=${transaction.hash}`);
  console.log(`V3_2_FACTORY_START_BLOCK=${receipt.blockNumber}`);
  for (const component of partial.components) console.log(`${component.name}=${component.address}`);
  console.log("Factory verified. FundingPool allowlist has NOT been changed.");
}

main().catch((error) => { console.error(error); process.exitCode = 1; });
