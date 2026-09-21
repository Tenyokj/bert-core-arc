/**
 * @file initialize-v2-conditional-pledges.ts
 * @notice Executes the two BERT V2.2 migration initializers after their proxies are upgraded.
 * @dev Must be run by a BERT protocol admin, while V2 remains paused.
 *
 * Transparent Proxy note: do not use ProxyAdmin.upgradeAndCall for these functions.
 * The delegated call would have ProxyAdmin as msg.sender, while these functions are
 * deliberately protected by the protocol's onlyAdmin role.
 *
 * Run with:
 *   V2_PLEDGE_FEE_BPS=500 npx hardhat run scripts/deploy/initialize-v2-conditional-pledges.ts --network arcTestnet
 */
import { hre } from "../../test/setup.js";

const ARC_TESTNET_CHAIN_ID = 5_042_002n;

function requiredAddress(...names: string[]): string {
  for (const name of names) {
    const value = process.env[name]?.trim();
    if (value) return value;
  }
  throw new Error(`Missing required address. Set one of: ${names.join(", ")}`);
}

async function main() {
  const connection = await hre.network.connect();
  const { ethers } = connection;
  const network = await ethers.provider.getNetwork();
  const feeBps = BigInt(process.env.V2_PLEDGE_FEE_BPS ?? "500");

  if (network.chainId !== ARC_TESTNET_CHAIN_ID) {
    throw new Error(`Wrong network: expected Arc Testnet (${ARC_TESTNET_CHAIN_ID}), got ${network.chainId}`);
  }
  if (feeBps > 1_000n) throw new Error("feeBps must not exceed 1000 (10 percent)");

  const [admin] = await ethers.getSigners();
  const fundingAddress = requiredAddress("FUNDING_POOL_ADDRESS", "FUNDING");
  const ideaAddress = requiredAddress("IDEA_REGISTRY_PROXY_ADDRESS", "IDEA");
  const [funding, idea] = await Promise.all([
    ethers.getContractAt("FundingPoolUpgradeable", fundingAddress, admin),
    ethers.getContractAt("IdeaRegistryUpgradeable", ideaAddress, admin),
  ]);

  console.log("BERT V2.2 migration initializer");
  console.log(`Network: ${network.name} (${network.chainId})`);
  console.log(`Protocol admin signer: ${admin.address}`);
  console.log(`Configured pledge fee: ${feeBps} bps`);

  const fundingTx = await funding.initializeConditionalPledges(feeBps);
  console.log(`FundingPool initializer submitted: ${fundingTx.hash}`);
  await fundingTx.wait();

  const registryTx = await idea.initializeConditionalPledgeMigration();
  console.log(`IdeaRegistry initializer submitted: ${registryTx.hash}`);
  await registryTx.wait();

  const [actualFeeBps, firstConditionalFundingIdeaId] = await Promise.all([
    funding.pledgeFeeBps(),
    idea.firstConditionalFundingIdeaId(),
  ]);
  if (actualFeeBps !== feeBps || firstConditionalFundingIdeaId === 0n) {
    throw new Error("Initializer postcondition failed; do not unpause V2");
  }

  console.log(`Migration initialized. Legacy/new idea boundary: ${firstConditionalFundingIdeaId}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
