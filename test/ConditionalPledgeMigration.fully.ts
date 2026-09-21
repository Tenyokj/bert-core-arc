/**
 * @file ConditionalPledgeMigration.fully.ts
 * @notice Rehearses upgrading a legacy V2 state into conditional pledges without fund loss.
 */

import { expect, toBeHex } from "./setup.js";
import { deploySystem } from "./helpers.js";

const IMPLEMENTATION_SLOT = BigInt(
  "0x360894A13BA1A3210667C828492DB98DCA3E2076CC3735A920A3CA505D382BBC"
);

async function replaceImplementation(ethers: any, proxyAddress: string, implementationAddress: string) {
  await ethers.provider.send("hardhat_setStorageAt", [
    proxyAddress,
    toBeHex(IMPLEMENTATION_SLOT, 32),
    ethers.zeroPadValue(implementationAddress, 32),
  ]);
}

describe("BERT V2.1 conditional-pledge migration", function () {
  it("preserves the legacy pool and starts a round only after every queued legacy idea is configured", async function () {
    const system = await deploySystem();
    const { ethers, admin, user3, ideaRegistry, fundingPool, votingSystem } = system;
    const unit = 10n ** 6n;
    const legacyBond = 50n * unit;
    const legacyPoolSnapshot = 1_234n * unit;

    await fundingPool.connect(admin).unpause();
    await ideaRegistry.connect(admin).setAuthorMinStake(legacyBond);

    const legacyFactory = await ethers.getContractFactory("MockLegacyIdeaRegistry", admin);
    const legacyImplementation = await legacyFactory.deploy();
    await legacyImplementation.waitForDeployment();
    const ideaProxy = await ideaRegistry.getAddress();
    await replaceImplementation(ethers, ideaProxy, await legacyImplementation.getAddress());
    const legacyRegistry = await ethers.getContractAt("MockLegacyIdeaRegistry", ideaProxy, admin);

    for (let index = 0; index < 4; index += 1) {
      await legacyRegistry
        .connect(user3)
        .createLegacyProposal(`Legacy ${index + 1}`, "Legacy proposal", "", legacyBond);
    }
    await fundingPool.connect(admin).deposit(legacyPoolSnapshot - 4n * legacyBond);
    expect(await fundingPool.totalPoolBalance()).to.equal(legacyPoolSnapshot);
    expect(await legacyRegistry.totalIdeas()).to.equal(4n);
    expect(await legacyRegistry.minimumNetFundingByIdea(1n)).to.equal(0n);

    const currentFactory = await ethers.getContractFactory("IdeaRegistryUpgradeable", admin);
    const currentImplementation = await currentFactory.deploy();
    await currentImplementation.waitForDeployment();
    await replaceImplementation(ethers, ideaProxy, await currentImplementation.getAddress());
    const migratedRegistry = await ethers.getContractAt("IdeaRegistryUpgradeable", ideaProxy, admin);

    await fundingPool.connect(admin).setPledgeFeeBps(0);
    await fundingPool.connect(admin).initializeConditionalPledges(500);
    await migratedRegistry.connect(admin).initializeConditionalPledgeMigration();

    expect(await fundingPool.pledgeFeeBps()).to.equal(500n);
    expect(await fundingPool.totalPoolBalance()).to.equal(legacyPoolSnapshot);
    expect(await migratedRegistry.firstConditionalFundingIdeaId()).to.equal(5n);

    for (let ideaId = 1n; ideaId <= 4n; ideaId += 1n) {
      await migratedRegistry.connect(user3).configureLegacyFundingProposal(ideaId, 100n * unit);
      expect(await migratedRegistry.minimumNetFundingByIdea(ideaId)).to.equal(100n * unit);
      expect(await migratedRegistry.isFundingProposal(ideaId)).to.equal(true);
    }

    expect(await fundingPool.totalPoolBalance()).to.equal(legacyPoolSnapshot);

    // The legacy queue contains four ideas. A fifth conditional proposal is needed to meet
    // the new safe minimum of five ideas per round.
    await migratedRegistry
      .connect(user3)
      .createFundingProposal("First V2.1 proposal", "Conditional pledge proposal", "", legacyBond, 100n * unit);
    await votingSystem.connect(admin).setIdeaPerRound(5);
    await votingSystem.connect(admin).unpause();
    await votingSystem.startFundingRound();

    const [, ideaIds, , , active] = await votingSystem.getRoundInfo(1n);
    expect(ideaIds).to.deep.equal([1n, 2n, 3n, 4n, 5n]);
    expect(active).to.equal(true);
  });
});
