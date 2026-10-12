/**
 * @file mint-v3-test-usdc.ts
 * @notice Mints MockUSDC for the local BERT V3 Community Layer test wallets.
 * @dev This script refuses every non-local network. It never interacts with real USDC.
 * @dev Run: MOCK_USDC_ADDRESS=<local MockUSDC> npx hardhat run scripts/local/mint-v3-test-usdc.ts --network localhost
 */
import { hre } from "../../test/setup.js";

async function main() {
  const connection = await hre.network.connect();
  const { ethers } = connection;
  const network = await ethers.provider.getNetwork();
  if (network.chainId !== 31337n) throw new Error("This MockUSDC mint script is restricted to local chain ID 31337.");

  const tokenAddress = process.env.MOCK_USDC_ADDRESS?.trim();
  if (!tokenAddress || !ethers.isAddress(tokenAddress)) throw new Error("Set MOCK_USDC_ADDRESS to the local MockUSDC address.");
  const amount = ethers.parseUnits(process.env.MOCK_USDC_AMOUNT?.trim() || "100000", 6);
  const signers = await ethers.getSigners();
  const requestedCount = Number(process.env.LOCAL_TEST_WALLET_COUNT?.trim() || "8");
  if (!Number.isSafeInteger(requestedCount) || requestedCount < 1) {
    throw new Error("LOCAL_TEST_WALLET_COUNT must be a positive whole number.");
  }
  const recipients = signers.slice(0, requestedCount);
  if (recipients.length !== requestedCount) {
    throw new Error(`Local node exposed ${signers.length} signer(s), but ${requestedCount} were requested.`);
  }
  const [minter] = signers;
  const usdc = await ethers.getContractAt("MockUSDC", tokenAddress, minter);

  console.log(`Minting ${ethers.formatUnits(amount, 6)} MockUSDC to ${recipients.length} local Hardhat wallets.`);
  for (const recipient of recipients) {
    const transaction = await usdc.mint(recipient.address, amount);
    await transaction.wait();
    console.log(`Minted ${ethers.formatUnits(amount, 6)} USDC to ${recipient.address}`);
  }
  console.log("Local V3 test balances are ready.");
}

main().catch((error) => { console.error(error); process.exitCode = 1; });
