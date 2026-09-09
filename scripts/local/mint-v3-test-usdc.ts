/**
 * @file mint-v3-test-usdc.ts
 * @notice Mints MockUSDC for the local BERT V3 Community Layer test wallets.
 * @dev This script refuses every non-local network. It never interacts with real USDC.
 * @dev Run: MOCK_USDC_ADDRESS=<local MockUSDC> npx hardhat run scripts/local/mint-v3-test-usdc.ts --network localhost
 */
import { hre } from "../../test/setup.js";

const RECIPIENTS = [
  "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
  "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a",
  "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec",
  "0x90F79bf6EB2c4f870365E785982E1f101E93b906",
  "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65",
  "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
  "0x4E79c65d4223d8A56aB6eD94D931CaF333Ac6D74",
] as const;

async function main() {
  const connection = await hre.network.connect();
  const { ethers } = connection;
  const network = await ethers.provider.getNetwork();
  if (network.chainId !== 31337n) throw new Error("This MockUSDC mint script is restricted to local chain ID 31337.");

  const tokenAddress = process.env.MOCK_USDC_ADDRESS?.trim();
  if (!tokenAddress || !ethers.isAddress(tokenAddress)) throw new Error("Set MOCK_USDC_ADDRESS to the local MockUSDC address.");
  const amount = ethers.parseUnits(process.env.MOCK_USDC_AMOUNT?.trim() || "100000", 6);
  const [minter] = await ethers.getSigners();
  const usdc = await ethers.getContractAt("MockUSDC", tokenAddress, minter);

  console.log(`Minting ${ethers.formatUnits(amount, 6)} MockUSDC to ${RECIPIENTS.length} local test wallets.`);
  for (const recipient of RECIPIENTS) {
    const transaction = await usdc.mint(recipient, amount);
    await transaction.wait();
    console.log(`Minted ${ethers.formatUnits(amount, 6)} USDC to ${recipient}`);
  }
  console.log("Local V3 test balances are ready.");
}

main().catch((error) => { console.error(error); process.exitCode = 1; });
