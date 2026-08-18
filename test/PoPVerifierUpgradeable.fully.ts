/**
 * @file PoPVerifierUpgradeable.fully.ts
 * @notice Proof-of-personhood verification signatures, expiry, nonce, and voting integration.
 * @dev NatSpec-style comment for test documentation.
 */

import { expect } from "./setup.js";
import { deploySystem, deployUpgradeable, getConnection, createIdeas } from "./helpers.js";

const PROVIDER_ID = "0x" + "11".repeat(32);
const CREDENTIAL_HASH = "0x" + "22".repeat(32);

async function signVerification(
  signer: any,
  verifierAddress: string,
  chainId: bigint,
  user: string,
  verifiedUntil: bigint,
  nonce: bigint,
  provider = PROVIDER_ID,
  credentialHash = CREDENTIAL_HASH
) {
  return signer.signTypedData(
    {
      name: "BERT PoP Verifier",
      version: "1",
      chainId,
      verifyingContract: verifierAddress,
    },
    {
      Verification: [
        { name: "user", type: "address" },
        { name: "verifiedUntil", type: "uint64" },
        { name: "nonce", type: "uint256" },
        { name: "provider", type: "bytes32" },
        { name: "credentialHash", type: "bytes32" },
      ],
    },
    {
      user,
      verifiedUntil,
      nonce,
      provider,
      credentialHash,
    }
  );
}

/** @notice describe: PoPVerifierUpgradeable */
describe("PoPVerifierUpgradeable", function () {
  /** @notice it: records valid proofs from the trusted signer */
  it("records valid proofs from the trusted signer", async function () {
    const { ethers, networkHelpers } = await getConnection();
    const [admin, user] = await ethers.getSigners();

    const roles = await deployUpgradeable(ethers, admin, "RolesRegistryUpgradeable", []);
    const verifier = await deployUpgradeable(
      ethers,
      admin,
      "PoPVerifierUpgradeable",
      [await roles.getAddress(), admin.address]
    );

    const chainId = (await ethers.provider.getNetwork()).chainId;
    const verifiedUntil = BigInt(await networkHelpers.time.latest()) + 3600n;
    const signature = await signVerification(
      admin,
      await verifier.getAddress(),
      chainId,
      user.address,
      verifiedUntil,
      1n
    );

    await expect(
      verifier
        .connect(user)
        .submitVerification(verifiedUntil, 1n, PROVIDER_ID, CREDENTIAL_HASH, signature)
    )
      .to.emit(verifier, "VerificationRecorded")
      .withArgs(user.address, verifiedUntil, 1n, PROVIDER_ID);

    expect(await verifier.isVerifiedHuman(user.address)).to.equal(true);
    const status = await verifier.getVerification(user.address);
    expect(status[0]).to.equal(true);
    expect(status[1]).to.equal(verifiedUntil);
    expect(status[2]).to.equal(1n);
  });

  /** @notice it: rejects proofs signed by the wrong signer */
  it("rejects proofs signed by the wrong signer", async function () {
    const { ethers, networkHelpers } = await getConnection();
    const [admin, user, otherSigner] = await ethers.getSigners();

    const roles = await deployUpgradeable(ethers, admin, "RolesRegistryUpgradeable", []);
    const verifier = await deployUpgradeable(
      ethers,
      admin,
      "PoPVerifierUpgradeable",
      [await roles.getAddress(), admin.address]
    );

    const chainId = (await ethers.provider.getNetwork()).chainId;
    const verifiedUntil = BigInt(await networkHelpers.time.latest()) + 3600n;
    const signature = await signVerification(
      otherSigner,
      await verifier.getAddress(),
      chainId,
      user.address,
      verifiedUntil,
      1n
    );

    await expect(
      verifier
        .connect(user)
        .submitVerification(verifiedUntil, 1n, PROVIDER_ID, CREDENTIAL_HASH, signature)
    ).to.be.revertedWithCustomError(verifier, "InvalidSignatureSigner");
  });

  /** @notice it: rejects expired proofs and invalid nonce progression */
  it("rejects expired proofs and invalid nonce progression", async function () {
    const { ethers, networkHelpers } = await getConnection();
    const [admin, user] = await ethers.getSigners();

    const roles = await deployUpgradeable(ethers, admin, "RolesRegistryUpgradeable", []);
    const verifier = await deployUpgradeable(
      ethers,
      admin,
      "PoPVerifierUpgradeable",
      [await roles.getAddress(), admin.address]
    );

    const chainId = (await ethers.provider.getNetwork()).chainId;
    const now = BigInt(await networkHelpers.time.latest());
    const expiredUntil = now - 1n;
    const expiredSignature = await signVerification(
      admin,
      await verifier.getAddress(),
      chainId,
      user.address,
      expiredUntil,
      1n
    );

    await expect(
      verifier
        .connect(user)
        .submitVerification(expiredUntil, 1n, PROVIDER_ID, CREDENTIAL_HASH, expiredSignature)
    ).to.be.revertedWithCustomError(verifier, "VerifiedTimeExpired");

    const validUntil = now + 3600n;
    const validSignature = await signVerification(
      admin,
      await verifier.getAddress(),
      chainId,
      user.address,
      validUntil,
      1n
    );
    await verifier
      .connect(user)
      .submitVerification(validUntil, 1n, PROVIDER_ID, CREDENTIAL_HASH, validSignature);

    const replaySignature = await signVerification(
      admin,
      await verifier.getAddress(),
      chainId,
      user.address,
      validUntil + 10n,
      1n
    );
    await expect(
      verifier
        .connect(user)
        .submitVerification(validUntil + 10n, 1n, PROVIDER_ID, CREDENTIAL_HASH, replaySignature)
    ).to.be.revertedWithCustomError(verifier, "InvalidNonce");
  });

  /** @notice it: allows admin signer rotation and manual revocation */
  it("allows admin signer rotation and manual revocation", async function () {
    const { ethers, networkHelpers } = await getConnection();
    const [admin, user, newSigner] = await ethers.getSigners();

    const roles = await deployUpgradeable(ethers, admin, "RolesRegistryUpgradeable", []);
    const verifier = await deployUpgradeable(
      ethers,
      admin,
      "PoPVerifierUpgradeable",
      [await roles.getAddress(), admin.address]
    );

    await expect(
      verifier.connect(admin).setTrustedSigner(newSigner.address)
    )
      .to.emit(verifier, "TrustedSignerUpdated")
      .withArgs(newSigner.address);

    expect(await verifier.trustedSigner()).to.equal(newSigner.address);

    const chainId = (await ethers.provider.getNetwork()).chainId;
    const verifiedUntil = BigInt(await networkHelpers.time.latest()) + 3600n;
    const signature = await signVerification(
      newSigner,
      await verifier.getAddress(),
      chainId,
      user.address,
      verifiedUntil,
      1n
    );

    await verifier
      .connect(user)
      .submitVerification(verifiedUntil, 1n, PROVIDER_ID, CREDENTIAL_HASH, signature);

    await expect(verifier.connect(admin).revokeVerification(user.address))
      .to.emit(verifier, "VerificationRevoked")
      .withArgs(user.address);

    expect(await verifier.isVerifiedHuman(user.address)).to.equal(false);
  });
});

/** @notice describe: PoPVerifierUpgradeable integration */
describe("PoPVerifierUpgradeable integration", function () {
  /** @notice it: unlocks voting after a valid PoP verification is recorded */
  it("unlocks voting after a valid PoP verification is recorded", async function () {
    const {
      admin,
      user1,
      ideaRegistry,
      votingSystem,
      fundingPool,
      usdc,
      networkHelpers,
      ethers,
    } = await deploySystem();

    const roles = await votingSystem.roles();
    const verifier = await deployUpgradeable(
      ethers,
      admin,
      "PoPVerifierUpgradeable",
      [roles, admin.address]
    );

    await votingSystem.connect(admin).setHumanVerifier(await verifier.getAddress());
    await votingSystem.connect(admin).setHumanOnlyVoting(true);
    await fundingPool.connect(admin).unpause();
    await votingSystem.connect(admin).unpause();
    await createIdeas(ideaRegistry, admin, 30);

    const now = await networkHelpers.time.latest();
    await networkHelpers.time.increaseTo(now + 700);
    await votingSystem.startVotingRound();

    const chainId = (await ethers.provider.getNetwork()).chainId;
    const verifiedUntil = BigInt(now + 3600);
    const signature = await signVerification(
      admin,
      await verifier.getAddress(),
      chainId,
      user1.address,
      verifiedUntil,
      1n
    );

    await verifier
      .connect(user1)
      .submitVerification(verifiedUntil, 1n, PROVIDER_ID, CREDENTIAL_HASH, signature);

    const minStake = await votingSystem.minStake();
    await usdc.mint(user1.address, minStake * 2n);
    await usdc
      .connect(user1)
      .approve(await fundingPool.getAddress(), minStake * 2n);

    await expect(votingSystem.connect(user1).vote(1, 1, minStake))
      .to.emit(votingSystem, "VoteCast")
      .withArgs(user1.address, 1n, 1n, minStake);
  });
});
