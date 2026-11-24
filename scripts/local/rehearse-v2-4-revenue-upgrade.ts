import assert from "node:assert/strict";
import fs from "node:fs";
import hre from "hardhat";
import { Contract, FetchRequest, JsonRpcProvider, getAddress, id, keccak256, toBeHex } from "ethers";

const manifest = JSON.parse(fs.readFileSync("deployments/arc-testnet-v3.json", "utf8"));
const baseline = JSON.parse(fs.readFileSync("test/fixtures/FundingPoolV140.json", "utf8"));
const rpcUrl = process.env.REVENUE_FORK_RPC_URL;
const arcLocalRpc = process.env.REVENUE_ARC_LOCAL_RPC_URL;
const blockText = process.env.REVENUE_FORK_BLOCK;
const reportPath = process.env.REVENUE_FORK_REPORT ?? "/private/tmp/bert-v24-fork-report.json";
const adminSlot = toBeHex(BigInt(id("eip1967.proxy.admin")) - 1n, 32);
const implSlot = toBeHex(BigInt(id("eip1967.proxy.implementation")) - 1n, 32);
const addressFromWord = (word: string) => getAddress(`0x${word.slice(-40)}`);
const report: Record<string, any> = {
  recordedAt: new Date().toISOString(), status: "started", scope: "Pinned Arc snapshot and local-only upgrade rehearsal",
  publicTransactionsSent: false, fullHistoricalReconciliation: false,
  localUpgradePerformed: false,
  evmEmulation: "Generic EDR/Prague, not native Arc consensus or precompile emulation",
  arcUsdcTransferBehaviorVerified: false,
};
let stage = "validate inputs";

async function main() {
  assert(rpcUrl, "REVENUE_FORK_RPC_URL is required");
  assert(blockText && /^[1-9]\d*$/.test(blockText), "An explicit positive REVENUE_FORK_BLOCK is required");
  const block = Number(blockText);
  assert(Number.isSafeInteger(block), "Fork block exceeds safe integer range");
  assert.equal(hre.config.networks.hardhat.type, "edr-simulated", "Only the local EDR network is permitted");
  if (arcLocalRpc) {
    const local = new URL(arcLocalRpc);
    assert(local.protocol === "http:" && ["127.0.0.1", "localhost", "[::1]"].includes(local.hostname)
      && !local.username && !local.password, "Arc execution endpoint must be an unauthenticated loopback HTTP node");
  }
  report.blockNumber = block;
  const request = new FetchRequest(rpcUrl);
  request.timeout = 20_000;
  // No signer is ever attached to the upstream provider.
  const remote = new JsonRpcProvider(request);
  const connections: Awaited<ReturnType<typeof hre.network.create>>[] = [];
  try {
    stage = "read pinned public state";
    assert.equal(await remote.send("eth_chainId", []), "0x4cef52", "Expected Arc Testnet");
    const header = await remote.getBlock(block);
    assert(header?.hash, "Pinned block is unavailable");
    report.blockHash = header.hash;
    const proxy = manifest.v2.fundingPool.proxy;
    const implementation = addressFromWord(await remote.getStorage(proxy, implSlot, block));
    const proxyAdmin = addressFromWord(await remote.getStorage(proxy, adminSlot, block));
    assert.equal(implementation.toLowerCase(), manifest.v2.fundingPool.implementation.toLowerCase());
    assert.equal(proxyAdmin.toLowerCase(), manifest.v2.fundingPool.proxyAdmin.toLowerCase());
    const liveCode = await remote.getCode(implementation, block);
    const pool = new Contract(proxy, baseline.abi, remote);
    const token = new Contract(manifest.usdc, [
      "function balanceOf(address) view returns(uint256)",
      "function transfer(address,uint256) returns(bool)",
    ], remote);
    const owner = await new Contract(proxyAdmin, ["function owner() view returns(address)"], remote)
      .owner({ blockTag: block });
    const fields = ["usdc", "roles", "ideaRegistry", "totalPoolBalance", "protocolReserve",
      "pledgeFeeBps", "communityFactory", "communityFactoryCount", "paused", "getDistributionCount"];
    const snapshot: Record<string, any> = {};
    for (const field of fields) snapshot[field] = await pool[field]({ blockTag: block });
    const actual = await token.balanceOf(proxy, { blockTag: block });
    report.publicSnapshot = {
      proxy, implementation, proxyAdmin, proxyAdminOwner: owner,
      implementationCodeHash: keccak256(liveCode), runtimeBytes: (liveCode.length - 2) / 2,
      actual, fields: snapshot,
    };
    assert.equal(snapshot.usdc.toLowerCase(), manifest.usdc.toLowerCase());
    assert.equal(actual, snapshot.totalPoolBalance, "Actual custody differs from recorded custody; investigate before upgrade");
    assert(actual >= snapshot.protocolReserve, "Reserve exceeds custody");
    console.log(`Pinned public snapshot read at block ${block}; no public signer used`);

    stage = "compare frozen baseline runtime on disposable chain";
    const clean = await hre.network.create({ network: "hardhat", override: { chainId: 31337 } });
    connections.push(clean);
    assert.equal((await clean.ethers.provider.getNetwork()).chainId, 31337n);
    const [localDeployer] = await clean.ethers.getSigners();
    const frozen = await new clean.ethers.ContractFactory(baseline.abi, baseline.bytecode, localDeployer).deploy();
    await frozen.waitForDeployment();
    const frozenCode = await clean.ethers.provider.getCode(await frozen.getAddress());
    report.frozenBaseline = {
      commit: baseline.commit, runtimeBytes: (frozenCode.length - 2) / 2,
      runtimeCodeHash: keccak256(frozenCode), exactRuntimeMatch: frozenCode === liveCode,
    };
    // Metadata/source mismatch is a review gate, not permission to guess a live layout.
    assert(frozenCode === liveCode, "Live implementation runtime differs from the frozen upgrade baseline");
    console.log("Frozen baseline runtime exactly matches the public implementation");
    stage = "simulate upstream token transfer with read-only eth_call";
    const ownerAssetBalance = await token.balanceOf(owner, { blockTag: block });
    assert(ownerAssetBalance >= 1n, "Pinned owner lacks one token unit for an upstream read-only transfer simulation");
    const upstreamTransfer = await token.transfer.staticCall(localDeployer.address, 1n, { from: owner, blockTag: block });
    report.upstreamTransferSimulation = { method: "eth_call", amount: "1", sourceBalance: ownerAssetBalance,
      from: owner, to: localDeployer.address, returned: upstreamTransfer, publicStateChanged: false };
    assert.equal(upstreamTransfer, true);

    stage = "create pinned local fork and check Arc asset fidelity";
    const fork = arcLocalRpc ? await hre.network.create({ network: "localhost", override: { url: arcLocalRpc, chainId: 31337 } }) : await hre.network.create({
      network: "hardhat", override: { chainId: 31337, hardfork: "prague", forking: { enabled: true, url: rpcUrl, blockNumber: block } },
    });
    connections.push(fork);
    const { ethers, networkHelpers } = fork;
    if (arcLocalRpc) {
      const info = await ethers.provider.send("anvil_nodeInfo", []);
      assert.equal(info.network, "arc", "Local node must actually execute Arc semantics");
      assert.equal(Number(info.forkConfig?.forkBlockNumber), block, "Arc node must use the pinned fork block");
      report.evmEmulation = "Arc Foundry executing Arc semantics on a loopback-only fork";
      report.executionNode = { network: info.network, hardFork: info.hardFork,
        clientVersion: await ethers.provider.send("web3_clientVersion", []) };
    } else assert.equal(fork.networkConfig.type, "edr-simulated");
    assert.equal((await ethers.provider.getNetwork()).chainId, 31337n);
    const forkBlock = await ethers.provider.getBlock(block);
    assert.equal(forkBlock?.hash, header.hash, "Fork does not match the pinned public block");
    assert.equal(await ethers.provider.getCode(implementation), liveCode, "Fork implementation code differs from pinned public code");
    assert.equal(addressFromWord(await ethers.provider.getStorage(proxy, implSlot)), implementation,
      "Fork proxy is already modified; restart the isolated node before rehearsing");
    assert.equal(addressFromWord(await ethers.provider.getStorage(proxy, adminSlot)), proxyAdmin);
    const forkPool = await ethers.getContractAt("FundingPoolUpgradeable", proxy);
    const forkToken = new ethers.Contract(manifest.usdc, ["function balanceOf(address) view returns(uint256)"], ethers.provider);
    const forkActual = await forkToken.balanceOf(proxy);
    report.forkAsset = { actual: forkActual, matchesPinnedPublicBalance: forkActual === actual };
    assert.equal(forkActual, actual, "Local EVM does not reproduce Arc native-USDC balance; no token mocks or storage replacement allowed");
    for (const field of fields) assert.deepEqual(await forkPool[field](), snapshot[field], `Fork field mismatch: ${field}`);

    stage = "probe real Arc USDC transfers on local fork";
    const assetProbe = await networkHelpers.takeSnapshot();
    try {
      await networkHelpers.impersonateAccount(owner);
      await networkHelpers.setBalance(owner, 100n * 10n ** 18n);
      const holder = await ethers.getSigner(owner);
      const [recipient] = await ethers.getSigners();
      assert.notEqual(recipient.address.toLowerCase(), owner.toLowerCase());
      const transferable = new ethers.Contract(manifest.usdc, [
        "function balanceOf(address) view returns(uint256)",
        "function transfer(address,uint256) returns(bool)",
      ], holder);
      assert(await transferable.balanceOf(owner) > 0n, "Local gas funding did not provide a usable asset probe balance");
      const beforeRecipient = await transferable.balanceOf(recipient.address);
      await (await transferable.transfer(recipient.address, 1n)).wait();
      assert.equal(await transferable.balanceOf(recipient.address), beforeRecipient + 1n);
      const beforeReturn = await transferable.balanceOf(owner);
      await (await transferable.connect(recipient).getFunction("transfer")(owner, 1n)).wait();
      assert.equal(await transferable.balanceOf(owner), beforeReturn + 1n);
      assert.equal(await forkToken.balanceOf(proxy), actual);
      report.arcUsdcTransferBehaviorVerified = true;
      console.log("Real Arc USDC one-unit transfer and return passed locally");
    } finally {
      await networkHelpers.stopImpersonatingAccount(owner);
      await assetProbe.restore();
    }

    stage = "capture existing round, bond and allowlist mappings";
    const voting = await ethers.getContractAt("VotingSystemUpgradeable", manifest.v2.votingSystem.proxy);
    const ideas = await ethers.getContractAt("IdeaRegistryUpgradeable", manifest.v2.ideaRegistry.proxy);
    const nextRound = await voting.currentRoundId();
    const ideaCount = await ideas.totalIdeas();
    assert(nextRound <= 100n && ideaCount <= 200n && (nextRound + 1n) * (ideaCount + 1n) <= 2000n,
      "Snapshot exceeds bounded scan; prepare a separately reviewed event-based inventory");
    const roundFields = ["fundingRoundOpened", "fundingRoundSettled", "fundingRoundWinner", "fundingRoundFeeBps",
      "pendingProtocolFeeByRound", "fundingRoundFeeFinalized", "fundingRoundCancelled", "grantRefundActive",
      "winningGrossPledgeByRound", "winningPledgeCountByRound", "grantRefundTotalByRound", "grantRefundPaidByRound",
      "grantRefundClaimCountByRound", "progressiveFundingRoundFeeStarted", "progressiveFeeReleasedByRound",
      "progressiveFeeTrancheBpsByRound", "progressiveFeeRestoredForRefund", "distributed"];
    async function capture() {
      const state: Record<string, any> = { fields: {}, rounds: [], bonds: [], factories: [] };
      for (const field of fields) state.fields[field] = await forkPool[field]();
      for (let round = 1n; round <= nextRound; round++) {
        const row: Record<string, any> = { round, pools: [] };
        for (const field of roundFields) row[field] = await forkPool[field](round);
        for (let idea = 1n; idea <= ideaCount; idea++) row.pools.push(await forkPool.poolByRoundAndIdea(round, idea));
        state.rounds.push(row);
      }
      for (let idea = 1n; idea <= ideaCount; idea++) state.bonds.push(await forkPool.authorStakeByIdea(idea));
      for (let i = 0n; i < snapshot.communityFactoryCount; i++) {
        const factory = await forkPool.communityFactoryAt(i);
        state.factories.push([factory, await forkPool.isCommunityFactoryApproved(factory)]);
      }
      return state;
    }
    const initial = await capture();
    report.preUpgradeState = initial;
    console.log(`Captured known mappings: ${nextRound} round IDs, ${ideaCount} ideas`);
    report.inventoryLimits = "Bounded known round/idea getters only; not an event-complete liability inventory, donor/pledger enumeration or future arbitrary allocation-key scan";

    stage = "local-only maintenance and proxy upgrade";
    const registry = new ethers.Contract(snapshot.roles, ["function hasRole(bytes32,address) view returns(bool)"], ethers.provider);
    assert(await registry.hasRole(ethers.ZeroHash, owner), "ProxyAdmin owner is not protocol Admin; need separate maintenance authority");
    await networkHelpers.impersonateAccount(owner);
    await networkHelpers.setBalance(owner, 100n * 10n ** 18n);
    const localOwner = await ethers.getSigner(owner);
    if (!snapshot.paused) await (await forkPool.connect(localOwner).getFunction("pause")()).wait();
    const before = await capture();
    const candidate = await ethers.deployContract("FundingPoolUpgradeable");
    await candidate.waitForDeployment();
    const candidateCode = await ethers.provider.getCode(await candidate.getAddress());
    assert((candidateCode.length - 2) / 2 <= 24576, "Candidate exceeds EIP-170 size limit");
    const admin = new ethers.Contract(proxyAdmin,
      ["function upgradeAndCall(address,address,bytes) payable"], localOwner);
    const upgrade = await (await admin.upgradeAndCall(proxy, await candidate.getAddress(), "0x")).wait();
    report.localUpgradePerformed = true;
    report.localUpgrade = { transactionHash: upgrade.hash, implementationCodeHash: keccak256(candidateCode),
      runtimeBytes: (candidateCode.length - 2) / 2, oldStatePreserved: false, revenueStillDisabled: false };
    assert.equal(addressFromWord(await ethers.provider.getStorage(proxy, implSlot)), await candidate.getAddress());
    assert.deepEqual(await capture(), before, "Existing state changed across the upgrade");
    assert.equal(await forkPool.totalPendingProtocolRevenue(), 0n);
    assert.equal(await forkPool.revenueShareBps(), 0n);
    assert.equal(await forkPool.revenueTreasury(), ethers.ZeroAddress);
    const accounting = await forkPool.getTreasuryAccounting();
    assert.equal(accounting.actual, actual);
    assert.equal(accounting.accounted, snapshot.totalPoolBalance);
    for (let round = 0n; round <= nextRound; round++) {
      assert.equal((await forkPool.fundingRoundRevenue(round)).shareBps, 0n);
    }
    if (!snapshot.paused) await (await forkPool.connect(localOwner).getFunction("unpause")()).wait();
    assert.deepEqual(await capture(), initial, "Original pause state or old mappings were not restored");
    await networkHelpers.stopImpersonatingAccount(owner);
    report.localUpgrade.oldStatePreserved = true;
    report.localUpgrade.revenueStillDisabled = true;
    if (arcLocalRpc) {
      stage = "local native-USDC revenue, payout and failed-grant refund probe";
      const financialSnapshot = await networkHelpers.takeSnapshot();
      try {
        await networkHelpers.impersonateAccount(owner);
        const adminSigner = await ethers.getSigner(owner);
        const [relay, blockedExample, payeeA, payeeB, backer] = await ethers.getSigners();
        const relayToken = new ethers.Contract(manifest.usdc, [
          "function transfer(address,uint256) returns(bool)", "function balanceOf(address) view returns(uint256)",
        ], relay);
        // The pinned chain blocklists one public dev account. Test refusal; never clear the blocklist.
        let blocked = false;
        try { await relayToken.transfer.staticCall(blockedExample.address, 1n); }
        catch (error) { blocked = String(error).includes("Blocked address"); }
        assert(blocked, "Pinned blocked-payee fixture no longer matches; review the test accounts");
        for (const payee of [payeeA, payeeB, backer]) {
          assert.equal(await relayToken.transfer.staticCall(payee.address, 1n), true);
        }
        const blockedTreasury = await ethers.deployContract("ProtocolRevenueTreasury", [proxy, manifest.usdc,
          [blockedExample.address, payeeA.address], [5000, 5000]]);
        await blockedTreasury.waitForDeployment();
        await (await relayToken.transfer(await blockedTreasury.getAddress(), 2000n)).wait();
        let payoutBlocked = false;
        try { await blockedTreasury.release.staticCall(blockedExample.address); }
        catch (error) { payoutBlocked = String(error).includes("Blocked address"); }
        assert(payoutBlocked, "Blocked beneficiary payout unexpectedly succeeded");
        assert.equal(await blockedTreasury.released(blockedExample.address), 0n);
        assert.equal(await blockedTreasury.releasable(blockedExample.address), 1000n);
        await (await blockedTreasury.release(payeeA.address)).wait();
        assert.equal(await blockedTreasury.released(payeeA.address), 1000n);
        assert.equal(await relayToken.balanceOf(await blockedTreasury.getAddress()), 1000n);
        report.nativeBlocklistProbe = { passed: true, blockedPayee: blockedExample.address,
          source: "Direct test donation, not pool revenue", blockedEntitlementPreserved: "1000",
          otherBeneficiaryPaid: "1000", issuerBlocklistUnchanged: true };
        const treasury = await ethers.deployContract("ProtocolRevenueTreasury", [proxy, manifest.usdc,
          [payeeA.address, payeeB.address], [6000, 4000]]);
        await treasury.waitForDeployment();
        if (snapshot.paused) await (await forkPool.connect(adminSigner).getFunction("unpause")()).wait();
        await (await forkPool.connect(adminSigner).getFunction("scheduleRevenuePolicy")(await treasury.getAddress(), 4000)).wait();
        await networkHelpers.time.increaseTo(await forkPool.revenuePolicyReadyAt());
        await (await forkPool.connect(relay).getFunction("executeRevenuePolicy")()).wait();
        const votingAddress = manifest.v2.votingSystem.proxy;
        const distributorAddress = manifest.v2.grantManager.proxy;
        for (const address of [votingAddress, distributorAddress]) {
          await networkHelpers.impersonateAccount(address);
          await networkHelpers.setBalance(address, 10n ** 20n);
        }
        const votingSigner = await ethers.getSigner(votingAddress);
        const distributor = await ethers.getSigner(distributorAddress);
        const round = nextRound + 1_000_000n;
        assert.equal(await forkPool.fundingRoundOpened(round), false, "Probe round key is already in use");
        assert.equal(await forkPool.poolByRoundAndIdea(round, 1n), 0n);
        const token = new ethers.Contract(manifest.usdc, [
          "function approve(address,uint256) returns(bool)", "function balanceOf(address) view returns(uint256)",
        ], backer);
        const gross = 1_000_000n;
        await (await token.approve(proxy, gross)).wait();
        await (await forkPool.connect(votingSigner).getFunction("openFundingRound")(round)).wait();
        await (await forkPool.connect(votingSigner).getFunction("recordPledgeFrom")(backer.address, round, 1n, gross)).wait();
        await (await forkPool.connect(votingSigner).getFunction("settleFundingRound")(round, 1n)).wait();
        const fee = gross * snapshot.pledgeFeeBps / 10_000n;
        const initialNetPayment = (gross - fee) * 2000n / 10_000n;
        await (await forkPool.connect(distributor).getFunction("beginProgressiveFundingRoundFee")(round)).wait();
        await (await forkPool.connect(distributor).getFunction("distributeFunds")(round, 1n, initialNetPayment)).wait();
        await (await forkPool.connect(distributor).getFunction("releaseProgressiveFundingRoundFee")(round, 2000)).wait();
        const earnedFee = fee * 2000n / 10_000n;
        const revenue = earnedFee * 4000n / 10_000n;
        assert(revenue > 0n, "Pinned fee is too small for the probe");
        await (await treasury.collect(revenue)).wait();
        const beforeA = await token.balanceOf(payeeA.address), beforeB = await token.balanceOf(payeeB.address);
        await (await treasury.release(payeeA.address)).wait();
        await (await treasury.release(payeeB.address)).wait();
        assert.equal(await token.balanceOf(payeeA.address), beforeA + revenue * 6000n / 10_000n);
        assert.equal(await token.balanceOf(payeeB.address), beforeB + revenue * 4000n / 10_000n);
        await (await forkPool.connect(distributor).getFunction("activateGrantRefund")(round)).wait();
        const refund = await forkPool.grantRefundTotalByRound(round);
        const refundReceipt = await (await forkPool.connect(backer).getFunction("claimPledgeRefund")(round)).wait();
        assert.equal(refund, gross - initialNetPayment - earnedFee);
        assert.equal((await forkPool.getPledge(round, backer.address)).refundClaimed, true);
        assert.equal(await forkToken.balanceOf(proxy), actual + earnedFee - revenue);
        assert.equal(await forkPool.totalPoolBalance(), snapshot.totalPoolBalance + earnedFee - revenue);
        assert.equal(await forkPool.protocolReserve(), snapshot.protocolReserve + earnedFee - revenue);
        assert.equal(await forkPool.totalPendingProtocolRevenue(), 0n);
        assert.equal(await token.balanceOf(await treasury.getAddress()), 0n);
        report.nativeRevenueProbe = { passed: true, gross, fee, initialNetPayment, earnedFee, revenue, refund,
          refundTransactionHash: refundReceipt.hash, oldCapitalPreserved: true,
          scope: "Direct calls impersonating existing authorized modules; not browser E2E or the complete GrantManager lifecycle",
          exampleSplitsOnly: true };
      } finally {
        for (const address of [owner, manifest.v2.votingSystem.proxy, manifest.v2.grantManager.proxy]) {
          await networkHelpers.stopImpersonatingAccount(address);
        }
        await financialSnapshot.restore();
      }
      assert.deepEqual(await capture(), initial, "Financial probe did not restore the original mappings");
      assert.equal(await forkPool.revenueShareBps(), 0n);
    }
    report.status = "bounded local upgrade passed; not a full rollout approval";
    stage = "verify pinned public state was not changed by this script";
    assert.equal(await remote.getStorage(proxy, implSlot, block), toBeHex(BigInt(implementation), 32));
  } finally {
    remote.destroy();
    for (const connection of connections) await connection.close();
  }
}

try {
  await main();
} catch (error) {
  report.status = "blocked";
  report.failedStage = stage;
  // Do not put a private RPC URL or provider response body into a checked-in report.
  const message = error instanceof Error ? error.message : String(error);
  console.error((rpcUrl ? message.replaceAll(rpcUrl, "<RPC_URL>") : message).slice(0, 1200));
  process.exitCode = 1;
} finally {
  fs.writeFileSync(reportPath, JSON.stringify(report, (_, value) => typeof value === "bigint" ? value.toString() : value, 2) + "\n");
  console.log(`Rehearsal status: ${report.status}; stage: ${stage}`);
  console.log(`Report: ${reportPath}`);
}
