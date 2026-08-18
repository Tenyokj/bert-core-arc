/**
 * @file Upgradeability.edge.ts
 * @notice ERC1967 proxy upgrade and storage preservation.
 * @dev NatSpec-style comment for test documentation.
 */

import { expect, toBeHex } from "./setup.js";
import { deploySystem } from "./helpers.js";

const IMPLEMENTATION_SLOT = BigInt(
  "0x360894A13BA1A3210667C828492DB98DCA3E2076CC3735A920A3CA505D382BBC"
);

async function forceImplementation(
  ethers: Awaited<ReturnType<typeof deploySystem>>["ethers"],
  proxyAddress: string,
  implementationAddress: string
) {
  await ethers.provider.send("hardhat_setStorageAt", [
    proxyAddress,
    toBeHex(IMPLEMENTATION_SLOT, 32),
    ethers.zeroPadValue(implementationAddress, 32),
  ]);
}

/** @notice describe: Upgradeability edge cases */
describe("Upgradeability edge cases", function () {
  /** @notice it: upgrades ERC1967 proxy to V2 and preserves storage */
  it("upgrades ERC1967 proxy to V2 and preserves storage", async function () {
    const { ethers, admin, votingSystem } = await deploySystem();

    await votingSystem.connect(admin).setMinStake(123n);
    await votingSystem.connect(admin).setIdeaPerRound(15);

    const proxyAddress = await votingSystem.getAddress();

    const implV2 = await (
      await ethers.getContractFactory("MockVotingSystemV2", admin)
    ).deploy();
    await implV2.waitForDeployment();

    const slotHex = toBeHex(IMPLEMENTATION_SLOT, 32);
    const implBefore = await ethers.provider.getStorage(proxyAddress, slotHex);

    await forceImplementation(ethers, proxyAddress, await implV2.getAddress());

    const implAfter = await ethers.provider.getStorage(proxyAddress, slotHex);
    expect(implAfter).to.not.equal(implBefore);

    const votingV2 = await ethers.getContractAt(
      "MockVotingSystemV2",
      proxyAddress,
      admin
    );

    expect(await votingV2.minStake()).to.equal(123n);
    expect(await votingV2.IDEAS_PER_ROUND()).to.equal(15n);
    expect(await votingV2.v2Value()).to.equal(0n);

    await votingV2.setV2Value(999n);
    expect(await votingV2.v2Value()).to.equal(999n);
    expect(await votingV2.version()).to.equal(2n);
  });

  /** @notice it: restores legacy storage after upgrading away from the broken PoP layout */
  it("restores storage after upgrading away from the broken PoP layout", async function () {
    const { ethers, admin, votingSystem } = await deploySystem();

    const proxyAddress = await votingSystem.getAddress();
    const verifierAddress = "0x1111111111111111111111111111111111111111";
    const voteCap = 10_000n * 10n ** 6n;

    expect(await votingSystem.VOTING_DURATION()).to.equal(86_400n);
    expect(await votingSystem.minStake()).to.equal(10n * 10n ** 6n);
    expect(await votingSystem.IDEAS_PER_ROUND()).to.equal(30n);
    expect(await votingSystem.humanVerifier()).to.equal(ethers.ZeroAddress);
    expect(await votingSystem.humanOnlyVoting()).to.equal(false);
    expect(await votingSystem.maxVoteAmount()).to.equal(10_000n * 10n ** 6n);

    const brokenImpl = await (
      await ethers.getContractFactory("MockBrokenVotingSystemLayout", admin)
    ).deploy();
    await brokenImpl.waitForDeployment();

    await forceImplementation(ethers, proxyAddress, await brokenImpl.getAddress());

    const brokenVoting = await ethers.getContractAt(
      "MockBrokenVotingSystemLayout",
      proxyAddress,
      admin
    );

    await brokenVoting.setHumanVerifier(verifierAddress);
    await brokenVoting.setHumanOnlyVoting(true);
    await brokenVoting.setMaxVoteAmount(voteCap);

    const fixedImpl = await (
      await ethers.getContractFactory("VotingSystemUpgradeable", admin)
    ).deploy();
    await fixedImpl.waitForDeployment();

    await forceImplementation(ethers, proxyAddress, await fixedImpl.getAddress());

    const fixedVoting = await ethers.getContractAt(
      "VotingSystemUpgradeable",
      proxyAddress,
      admin
    );

    expect(await fixedVoting.VOTING_DURATION()).to.equal(86_400n);
    expect(await fixedVoting.minStake()).to.equal(10n * 10n ** 6n);
    expect(await fixedVoting.IDEAS_PER_ROUND()).to.equal(BigInt(verifierAddress));
    expect(await fixedVoting.humanVerifier()).to.equal(
      "0x0000000000000000000000000000000000000001"
    );
    expect(await fixedVoting.humanOnlyVoting()).to.equal(false);
    expect(await fixedVoting.maxVoteAmount()).to.equal(voteCap);

    await fixedVoting.setIdeaPerRound(30);
    await fixedVoting.setHumanVerifier(verifierAddress);
    await fixedVoting.setHumanOnlyVoting(true);
    await fixedVoting.setMaxVoteAmount(voteCap);

    expect(await fixedVoting.IDEAS_PER_ROUND()).to.equal(30n);
    expect(await fixedVoting.humanVerifier()).to.equal(verifierAddress);
    expect(await fixedVoting.humanOnlyVoting()).to.equal(true);
    expect(await fixedVoting.maxVoteAmount()).to.equal(voteCap);
    expect(await fixedVoting.VOTING_DURATION()).to.equal(86_400n);
    expect(await fixedVoting.minStake()).to.equal(10n * 10n ** 6n);
  });
});
