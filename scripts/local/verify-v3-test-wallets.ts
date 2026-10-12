/**
 * @file verify-v3-test-wallets.ts
 * @notice Creates local-only PoP attestations for Hardhat E2E wallets.
 * @dev The first node account must be configured as PoPVerifier.trustedSigner.
 *      This script never submits test attestations to a public network.
 * @dev Run: POP_VERIFIER_ADDRESS=<local verifier> npx hardhat run scripts/local/verify-v3-test-wallets.ts --network localhost
 */
import { hre } from "../../test/setup.js";

const verificationTypes = {
  Verification: [
    { name: "user", type: "address" },
    { name: "verifiedUntil", type: "uint64" },
    { name: "nonce", type: "uint256" },
    { name: "provider", type: "bytes32" },
    { name: "credentialHash", type: "bytes32" },
  ],
} as const;

async function main() {
  const { ethers } = await hre.network.connect();
  const network = await ethers.provider.getNetwork();
  if (network.chainId !== 31337n) {
    throw new Error("Local E2E attestations are restricted to chain ID 31337.");
  }

  const verifierAddress = process.env.POP_VERIFIER_ADDRESS?.trim();
  if (!verifierAddress || !ethers.isAddress(verifierAddress)) {
    throw new Error("Set POP_VERIFIER_ADDRESS to the local PoPVerifier proxy address.");
  }
  if ((await ethers.provider.getCode(verifierAddress)) === "0x") {
    throw new Error("POP_VERIFIER_ADDRESS has no contract code on the local node.");
  }

  const durationDays = BigInt(process.env.LOCAL_POP_VALIDITY_DAYS?.trim() || "30");
  const requestedCount = Number(process.env.LOCAL_TEST_WALLET_COUNT?.trim() || "8");
  if (durationDays < 1n) throw new Error("LOCAL_POP_VALIDITY_DAYS must be at least 1.");
  if (!Number.isSafeInteger(requestedCount) || requestedCount < 1) {
    throw new Error("LOCAL_TEST_WALLET_COUNT must be a positive whole number.");
  }

  const signers = await ethers.getSigners();
  const recipients = signers.slice(0, requestedCount);
  if (recipients.length !== requestedCount) {
    throw new Error(`Local node exposed ${signers.length} signer(s), but ${requestedCount} were requested.`);
  }

  const trustedSigner = signers[0];
  const verifier = await ethers.getContractAt("PoPVerifierUpgradeable", verifierAddress, trustedSigner);
  const configuredSigner = await verifier.trustedSigner();
  if (ethers.getAddress(configuredSigner) !== ethers.getAddress(trustedSigner.address)) {
    throw new Error(
      `PoP trusted signer mismatch. Deploy with TRUSTED_SIGNER_ADDRESS=${trustedSigner.address} or reconfigure the local verifier.`,
    );
  }

  const latestBlock = await ethers.provider.getBlock("latest");
  if (!latestBlock) throw new Error("Unable to read the local chain timestamp.");
  const verifiedUntil = BigInt(latestBlock.timestamp) + durationDays * 86_400n;
  const provider = ethers.keccak256(ethers.toUtf8Bytes("BERT_LOCAL_E2E"));
  const domain = {
    name: "BERT PoP Verifier",
    version: "1",
    chainId: network.chainId,
    verifyingContract: verifierAddress,
  };

  console.log(`Recording ${recipients.length} local PoP attestations until ${verifiedUntil.toString()}.`);
  for (const [index, recipient] of recipients.entries()) {
    const nonce = (await verifier.latestNonce(recipient.address)) + 1n;
    const credentialHash = ethers.keccak256(
      ethers.toUtf8Bytes(`BERT_LOCAL_E2E:${index}:${recipient.address.toLowerCase()}`),
    );
    const signature = await trustedSigner.signTypedData(domain, verificationTypes, {
      user: recipient.address,
      verifiedUntil,
      nonce,
      provider,
      credentialHash,
    });
    const transaction = await verifier
      .connect(recipient)
      .submitVerification(verifiedUntil, nonce, provider, credentialHash, signature);
    await transaction.wait();
    console.log(`Verified ${recipient.address} with nonce ${nonce.toString()}.`);
  }

  console.log("Local E2E PoP attestations are ready.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
