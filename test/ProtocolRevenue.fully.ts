import fs from "node:fs";
import { createRequire } from "node:module";
import { expect } from "./setup.js";
import { createIdeas, deploySystem } from "./helpers.js";

const require = createRequire(import.meta.url);
const baseline = require("./fixtures/FundingPoolV140.json");
const transparent = require("@openzeppelin/contracts/build/contracts/TransparentUpgradeableProxy.json");
const proxyAdminABI = require("@openzeppelin/contracts/build/contracts/ProxyAdmin.json").abi;

describe("V2.4 protocol revenue", function () {
  async function treasuryFor(s: any, payees = [s.user4.address, s.user5.address], shares = [6000, 4000]) {
    return s.ethers.deployContract("ProtocolRevenueTreasury", [
      await s.fundingPool.getAddress(), await s.usdc.getAddress(), payees, shares,
    ]);
  }

  async function unit(tokenName?: string) {
    const s = await deploySystem();
    if (tokenName) {
      s.usdc = tokenName === "MockERC20Fail"
        ? await s.ethers.deployContract(tokenName, ["Failure", "FAIL"])
        : await s.ethers.deployContract(tokenName);
      await s.fundingPool.setUsdc(await s.usdc.getAddress());
      for (const user of [s.admin, s.user1, s.user2]) {
        await s.usdc.mint(user.address, 1_000_000n);
        await s.usdc.connect(user).approve(await s.fundingPool.getAddress(), s.ethers.MaxUint256);
      }
    }
    for (const role of ["VOTING_ROLE", "DISTRIBUTOR_ROLE", "IREGISTRY_ROLE"]) {
      await s.roles.grantSystemRole(await s.roles[role](), s.admin.address);
    }
    await s.fundingPool.unpause();
    s.treasury = await treasuryFor(s);
    return s;
  }

  async function enable(s: any, treasury = s.treasury, share = 4000n) {
    await s.fundingPool.scheduleRevenuePolicy(await treasury.getAddress(), share);
    await s.networkHelpers.time.increaseTo(await s.fundingPool.revenuePolicyReadyAt());
    await s.fundingPool.connect(s.user2).executeRevenuePolicy();
  }

  async function fund(s: any, id = 1n, gross = 1000n) {
    await s.fundingPool.openFundingRound(id);
    await s.fundingPool.recordPledgeFrom(s.user1.address, id, 1n, gross);
    await s.fundingPool.settleFundingRound(id, 1n);
    await s.fundingPool.beginProgressiveFundingRoundFee(id);
  }

  it("defaults to zero revenue and does not turn old reserve or pending fees into entitlement", async function () {
    const s = await unit();
    await fund(s);
    await s.fundingPool.releaseProgressiveFundingRoundFee(1n, 2000n);
    expect(await s.fundingPool.protocolReserve()).to.equal(10n);
    await enable(s);
    await s.fundingPool.releaseProgressiveFundingRoundFee(1n, 10_000n);
    expect(await s.fundingPool.protocolReserve()).to.equal(50n);
    expect(await s.fundingPool.totalPendingProtocolRevenue()).to.equal(0n);
    expect((await s.fundingPool.fundingRoundRevenue(1n))[1]).to.equal(0n);
  });

  it("requires Admin scheduling, the complete delay and permissionless exact execution", async function () {
    const s = await unit();
    await expect(s.fundingPool.connect(s.user1).scheduleRevenuePolicy(await s.treasury.getAddress(), 4000))
      .to.be.revertedWithCustomError(s.fundingPool, "NotAdmin");
    await expect(s.fundingPool.executeRevenuePolicy()).to.be.revertedWithCustomError(s.fundingPool, "RevenuePolicyNotReady");
    await s.fundingPool.scheduleRevenuePolicy(await s.treasury.getAddress(), 4000);
    const ready = await s.fundingPool.revenuePolicyReadyAt();
    await s.networkHelpers.time.setNextBlockTimestamp(ready - 1n);
    await expect(s.fundingPool.executeRevenuePolicy()).to.be.revertedWithCustomError(s.fundingPool, "RevenuePolicyNotReady");
    await s.networkHelpers.time.setNextBlockTimestamp(ready);
    await expect(s.fundingPool.connect(s.user1).executeRevenuePolicy())
      .to.emit(s.fundingPool, "RevenuePolicyActivated").withArgs(await s.treasury.getAddress(), 4000n);
    await expect(s.fundingPool.executeRevenuePolicy()).to.be.revertedWithCustomError(s.fundingPool, "RevenuePolicyNotReady");
  });

  it("restarts replaced proposals and cancellation leaves active rules unchanged", async function () {
    const s = await unit();
    await s.fundingPool.scheduleRevenuePolicy(await s.treasury.getAddress(), 4000);
    const firstReady = await s.fundingPool.revenuePolicyReadyAt();
    await s.networkHelpers.time.increase(100);
    await s.fundingPool.scheduleRevenuePolicy(await s.treasury.getAddress(), 5000);
    expect(await s.fundingPool.revenuePolicyReadyAt()).to.be.greaterThan(firstReady);
    await expect(s.fundingPool.connect(s.user1).cancelRevenuePolicy()).to.be.revertedWithCustomError(s.fundingPool, "NotAdmin");
    await s.fundingPool.cancelRevenuePolicy();
    expect(await s.fundingPool.revenueShareBps()).to.equal(0n);
    expect(await s.fundingPool.revenuePolicyReadyAt()).to.equal(0n);
    await expect(s.fundingPool.cancelRevenuePolicy()).to.be.revertedWithCustomError(s.fundingPool, "RevenuePolicyNotReady");
    expect(await s.fundingPool.revenueAsset()).to.equal(await s.usdc.getAddress());
  });

  it("rejects malformed policies, foreign pools and mismatched receiver assets", async function () {
    const s = await unit();
    for (const [target, bps] of [
      [s.ethers.ZeroAddress, 1], [await s.treasury.getAddress(), 0],
      [await s.treasury.getAddress(), 10001], [s.user1.address, 4000],
      [await s.fundingPool.getAddress(), 4000],
    ]) await expect(s.fundingPool.scheduleRevenuePolicy(target, bps)).to.be.revertedWithCustomError(s.fundingPool, "InvalidRevenuePolicy");
    const other = await deploySystem();
    const foreign = await treasuryFor(other);
    await expect(s.fundingPool.scheduleRevenuePolicy(await foreign.getAddress(), 4000))
      .to.be.revertedWithCustomError(s.fundingPool, "InvalidRevenuePolicy");
    const originalToken = s.usdc;
    const nextToken = await s.ethers.deployContract("MockUSDC");
    await s.fundingPool.setUsdc(await nextToken.getAddress());
    await expect(s.fundingPool.scheduleRevenuePolicy(await s.treasury.getAddress(), 4000))
      .to.be.revertedWithCustomError(s.fundingPool, "InvalidRevenuePolicy");
    await s.fundingPool.setUsdc(await originalToken.getAddress());
    await enable(s);
    await expect(s.fundingPool.setUsdc(await nextToken.getAddress())).to.be.revertedWithCustomError(s.fundingPool, "RevenueAssetLocked");
    await expect(s.fundingPool.setGovernanceToken(await nextToken.getAddress())).to.be.revertedWithCustomError(s.fundingPool, "RevenueAssetLocked");
    await s.fundingPool.setUsdc(await originalToken.getAddress());
  });

  it("accrues only 20/40/40 earned fees and cannot collect escrow or collect twice", async function () {
    const s = await unit();
    await enable(s);
    await fund(s);
    await expect(s.treasury.collect(1)).to.be.revertedWithCustomError(s.fundingPool, "RevenueUnavailable");
    await s.fundingPool.releaseProgressiveFundingRoundFee(1n, 2000n);
    expect(await s.fundingPool.pendingRevenueByTreasury(await s.treasury.getAddress())).to.equal(4n);
    expect(await s.fundingPool.protocolReserve()).to.equal(6n);
    await expect(s.fundingPool.connect(s.user2).claimProtocolRevenue(1)).to.be.revertedWithCustomError(s.fundingPool, "RevenueUnavailable");
    await expect(s.treasury.collect(5)).to.be.revertedWithCustomError(s.fundingPool, "RevenueUnavailable");
    await s.treasury.connect(s.user2).collect(4);
    await expect(s.treasury.collect(1)).to.be.revertedWithCustomError(s.fundingPool, "RevenueUnavailable");
    await s.fundingPool.releaseProgressiveFundingRoundFee(1n, 6000n);
    await s.fundingPool.releaseProgressiveFundingRoundFee(1n, 10_000n);
    expect(await s.fundingPool.totalPendingProtocolRevenue()).to.equal(16n);
    expect(await s.fundingPool.protocolReserve()).to.equal(30n);
    await s.treasury.collect(16);
    expect(await s.usdc.balanceOf(await s.treasury.getAddress())).to.equal(20n);
    expect(await s.fundingPool.totalPoolBalance()).to.equal(980n);
    expect(await s.fundingPool.poolByRoundAndIdea(1, 1)).to.equal(950n);
  });

  it("keeps old receivers and split snapshots after rotation and disabling", async function () {
    const s = await unit();
    await enable(s);
    await fund(s, 1n);
    const next = await treasuryFor(s, [s.user3.address], [10000]);
    await enable(s, next, 7000n);
    await fund(s, 2n);
    await s.fundingPool.scheduleRevenuePolicy(s.ethers.ZeroAddress, 0);
    await s.networkHelpers.time.increaseTo(await s.fundingPool.revenuePolicyReadyAt());
    await s.fundingPool.executeRevenuePolicy();
    await fund(s, 3n);
    for (const id of [1n, 2n, 3n]) await s.fundingPool.releaseProgressiveFundingRoundFee(id, 10_000n);
    expect(await s.fundingPool.pendingRevenueByTreasury(await s.treasury.getAddress())).to.equal(20n);
    expect(await s.fundingPool.pendingRevenueByTreasury(await next.getAddress())).to.equal(35n);
    expect((await s.fundingPool.fundingRoundRevenue(3n))[1]).to.equal(0n);
    await s.treasury.collect(20);
    await next.collect(35);
    expect(await s.fundingPool.protocolReserve()).to.equal(95n);
  });

  it("uses cumulative rounding rather than losing revenue on small tranches", async function () {
    const s = await unit();
    await enable(s, s.treasury, 3333n);
    await fund(s, 1n, 100n); // 5 units of fees: 1, 2, 2 across the tranches.
    for (const bps of [2000n, 6000n, 10_000n]) await s.fundingPool.releaseProgressiveFundingRoundFee(1n, bps);
    expect(await s.fundingPool.totalPendingProtocolRevenue()).to.equal(1n);
    expect(await s.fundingPool.protocolReserve()).to.equal(4n);
  });

  it("supports zero fee and the full fee-share boundary without touching net grant capital", async function () {
    const s = await unit();
    await enable(s, s.treasury, 10_000n);
    await fund(s);
    await s.fundingPool.releaseProgressiveFundingRoundFee(1, 10_000);
    expect(await s.fundingPool.totalPendingProtocolRevenue()).to.equal(50n);
    expect(await s.fundingPool.protocolReserve()).to.equal(0n);
    await s.fundingPool.setPledgeFeeBps(0);
    await fund(s, 2n);
    await s.fundingPool.releaseProgressiveFundingRoundFee(2, 10_000);
    expect(await s.fundingPool.totalPendingProtocolRevenue()).to.equal(50n);
    expect(await s.fundingPool.poolByRoundAndIdea(2, 1)).to.equal(1000n);
  });

  it("supports the legacy claim-time fee path for new rounds only", async function () {
    const s = await unit();
    await enable(s);
    await s.fundingPool.openFundingRound(1);
    await s.fundingPool.recordPledgeFrom(s.user1.address, 1, 1, 1000);
    await s.fundingPool.settleFundingRound(1, 1);
    await s.fundingPool.finalizeFundingRoundFee(1);
    expect(await s.fundingPool.totalPendingProtocolRevenue()).to.equal(20n);
    expect(await s.fundingPool.protocolReserve()).to.equal(30n);
    await expect(s.fundingPool.finalizeFundingRoundFee(1)).to.be.revertedWithCustomError(s.fundingPool, "FundingRoundStateInvalid");
  });

  it("does not classify deposits, donations, slashed bonds or V3 inflows as team revenue", async function () {
    const s = await unit();
    await enable(s);
    await s.fundingPool.deposit(1000);
    await s.fundingPool.depositAuthorStakeFrom(s.user1.address, 1, 200);
    await s.fundingPool.slashAuthorStakeToReserve(1);
    const factory = await s.ethers.deployContract("MockCommunityFactoryRegistry");
    const treasury = await s.ethers.deployContract("MockCommunityReserveTreasury", [await s.usdc.getAddress()]);
    await s.fundingPool.setCommunityFactory(await factory.getAddress());
    await factory.setActiveCommunityTreasury(await treasury.getAddress(), true);
    await s.usdc.mint(await treasury.getAddress(), 300);
    await treasury.routeReserve(await s.fundingPool.getAddress(), 300);
    await s.usdc.transfer(await s.fundingPool.getAddress(), 70);
    expect((await s.fundingPool.getTreasuryAccounting())[5]).to.equal(70n);
    await s.fundingPool.syncBalance();
    const a = await s.fundingPool.getTreasuryAccounting();
    expect([...a]).to.deep.equal([1570n, 1570n, 500n, 0n, 1070n, 0n, 0n]);
    await s.fundingPool.syncBalance();
    expect(await s.fundingPool.totalPoolBalance()).to.equal(1570n);
    await expect(s.treasury.collect(1)).to.be.revertedWithCustomError(s.fundingPool, "RevenueUnavailable");
  });

  it("prevents reserve allocation from spending the separately earmarked revenue", async function () {
    const s = await unit();
    await enable(s);
    await fund(s);
    await s.fundingPool.releaseProgressiveFundingRoundFee(1, 10_000);
    await expect(s.fundingPool.allocateReserveToIdea(2, 2, 31))
      .to.be.revertedWithCustomError(s.fundingPool, "InsufficientPoolBalance");
    await s.fundingPool.allocateReserveToIdea(2, 2, 30);
    await s.treasury.collect(20);
    expect(await s.fundingPool.poolByRoundAndIdea(1, 1)).to.equal(950n);
    expect(await s.fundingPool.poolByRoundAndIdea(2, 2)).to.equal(30n);
    expect(await s.fundingPool.totalPoolBalance()).to.equal(980n);
  });

  it("excludes reserve-funded top-ups from the team's fee base even when allocated before the round opens", async function () {
    const s = await unit();
    await enable(s);
    await s.fundingPool.depositAuthorStakeFrom(s.user2.address, 90, 200);
    await s.fundingPool.slashAuthorStakeToReserve(90);
    await s.fundingPool.allocateReserveToIdea(1, 1, 200);
    await fund(s);
    const policy = await s.fundingPool.fundingRoundRevenue(1);
    expect(policy[3]).to.equal(50n); // Pledge-backed fee, not the 60-unit gross fee.
    expect(policy[4]).to.equal(60n);
    for (const bps of [2000, 6000, 10000]) await s.fundingPool.releaseProgressiveFundingRoundFee(1, bps);
    expect(await s.fundingPool.totalPendingProtocolRevenue()).to.equal(20n);
    expect(await s.fundingPool.protocolReserve()).to.equal(40n);
    await s.treasury.collect(20);
    expect(await s.fundingPool.poolByRoundAndIdea(1, 1)).to.equal(1140n);
    expect(await s.fundingPool.totalPoolBalance()).to.equal(1180n);
  });

  it("blocks collection while paused without consuming receiver entitlement", async function () {
    const s = await unit();
    await enable(s);
    await fund(s);
    await s.fundingPool.releaseProgressiveFundingRoundFee(1, 2000);
    await s.fundingPool.pause();
    await expect(s.treasury.collect(4)).to.be.revertedWithCustomError(s.fundingPool, "EnforcedPause");
    expect(await s.fundingPool.totalPendingProtocolRevenue()).to.equal(4n);
    await s.fundingPool.unpause();
    await s.treasury.collect(4);
  });

  it("reports a custody shortfall and refuses to hide it via sync or revenue collection", async function () {
    const s = await unit();
    await enable(s);
    await fund(s);
    await s.fundingPool.releaseProgressiveFundingRoundFee(1, 2000);
    const tokenAddress = await s.usdc.getAddress();
    // Simulate a non-USDC balance loss; ordinary USDC users cannot perform this operation.
    await s.networkHelpers.impersonateAccount(await s.fundingPool.getAddress());
    await s.networkHelpers.setBalance(await s.fundingPool.getAddress(), 10n ** 18n);
    const poolSigner = await s.ethers.getSigner(await s.fundingPool.getAddress());
    await s.usdc.connect(poolSigner).transfer(s.user2.address, 1);
    await s.networkHelpers.stopImpersonatingAccount(await s.fundingPool.getAddress());
    expect((await s.fundingPool.getTreasuryAccounting())[6]).to.equal(1n);
    await expect(s.fundingPool.syncBalance()).to.be.revertedWithCustomError(s.fundingPool, "PoolBalanceShortfall");
    await expect(s.treasury.collect(4)).to.be.revertedWithCustomError(s.fundingPool, "PoolBalanceShortfall");
    expect(await s.fundingPool.totalPendingProtocolRevenue()).to.equal(4n);
    expect(await s.fundingPool.usdc()).to.equal(tokenAddress);
    await s.usdc.transfer(await s.fundingPool.getAddress(), 1);
    const custodySlot = baseline.storageLayout.storage.find((v: any) => v.label === "totalPoolBalance").slot;
    // Simulate a historically inconsistent accounting snapshot, not an authorized write path.
    await s.networkHelpers.setStorageAt(await s.fundingPool.getAddress(), BigInt(custodySlot), s.ethers.toBeHex(9n, 32));
    await expect(s.fundingPool.getTreasuryAccounting()).to.be.revertedWithCustomError(s.fundingPool, "InvalidRevenueAccounting");
    await expect(s.treasury.collect(4)).to.be.revertedWithCustomError(s.fundingPool, "InvalidRevenueAccounting");
    await s.fundingPool.syncBalance();
    await s.treasury.collect(4);
  });

  it("rolls back failed token collections and payouts without losing entitlement", async function () {
    const s = await unit("MockERC20Fail");
    await enable(s);
    await fund(s);
    await s.fundingPool.releaseProgressiveFundingRoundFee(1, 10_000);
    await s.usdc.setFailTransfer(true, true);
    await expect(s.treasury.collect(20)).to.revert(s.ethers);
    expect(await s.fundingPool.totalPendingProtocolRevenue()).to.equal(20n);
    expect(await s.fundingPool.totalPoolBalance()).to.equal(1000n);
    await s.usdc.setFailTransfer(false, false);
    await s.treasury.collect(20);
    await s.usdc.setFailTransfer(true, false);
    await expect(s.treasury.release(s.user4.address)).to.revert(s.ethers);
    expect(await s.treasury.totalReleased()).to.equal(0n);
    expect(await s.treasury.releasable(s.user4.address)).to.equal(12n);
    await s.usdc.setFailTransfer(false, false);
    await s.treasury.release(s.user4.address);
    expect(await s.treasury.released(s.user4.address)).to.equal(12n);
  });

  it("rejects callback collection and payout reentry while keeping the outer payment exact", async function () {
    const s = await unit("MockReentrantUSDC");
    await enable(s);
    await fund(s);
    await s.fundingPool.releaseProgressiveFundingRoundFee(1, 10_000);
    await s.usdc.configureCallback(await s.treasury.getAddress(), s.treasury.interface.encodeFunctionData("collect", [20]), false);
    await s.treasury.collect(20);
    expect(await s.usdc.callbackAttempted()).to.equal(true);
    expect(await s.usdc.lastCallbackSucceeded()).to.equal(false);
    await s.usdc.configureCallback(await s.treasury.getAddress(), s.treasury.interface.encodeFunctionData("release", [s.user4.address]), false);
    await s.treasury.release(s.user4.address);
    expect(await s.usdc.lastCallbackSucceeded()).to.equal(false);
    expect(await s.treasury.totalReleased()).to.equal(12n);
    expect(await s.fundingPool.totalPendingProtocolRevenue()).to.equal(0n);
  });

  it("rejects taxed or surcharged revenue transfers without consuming either party's entitlement", async function () {
    const s = await unit("MockRevenueTransferToken");
    await enable(s);
    await fund(s);
    await s.fundingPool.releaseProgressiveFundingRoundFee(1, 10_000);
    for (const mode of [1, 2]) {
      await s.usdc.configure(mode, s.ethers.ZeroAddress);
      await expect(s.treasury.collect(20)).to.be.revertedWithCustomError(s.fundingPool, "UnsupportedRevenueTransfer");
      expect(await s.fundingPool.totalPendingProtocolRevenue()).to.equal(20n);
      expect(await s.usdc.balanceOf(await s.fundingPool.getAddress())).to.equal(1000n);
    }
    await s.usdc.configure(0, s.ethers.ZeroAddress);
    await s.treasury.collect(20);
    for (const mode of [1, 2]) {
      await s.usdc.configure(mode, s.ethers.ZeroAddress);
      await expect(s.treasury.release(s.user4.address)).to.be.revertedWithCustomError(s.treasury, "UnsupportedRevenueTransfer");
      expect(await s.treasury.totalReleased()).to.equal(0n);
      expect(await s.usdc.balanceOf(await s.treasury.getAddress())).to.equal(20n);
    }
  });

  it("isolates receiver collection failures and each beneficiary's blocked transfer", async function () {
    const s = await unit("MockRevenueTransferToken");
    await enable(s);
    await fund(s);
    await s.usdc.configure(0, await s.treasury.getAddress());
    await s.fundingPool.releaseProgressiveFundingRoundFee(1, 2000);
    await expect(s.treasury.collect(4)).to.be.revertedWith("blocked payee");
    await s.fundingPool.releaseProgressiveFundingRoundFee(1, 10_000);
    expect(await s.fundingPool.totalPendingProtocolRevenue()).to.equal(20n);
    await s.usdc.configure(0, s.user4.address);
    await s.treasury.collect(20);
    await expect(s.treasury.release(s.user4.address)).to.be.revertedWith("blocked payee");
    await s.treasury.release(s.user5.address);
    expect(await s.treasury.released(s.user5.address)).to.equal(8n);
    expect(await s.treasury.released(s.user4.address)).to.equal(0n);
  });

  it("conserves every unit across 55 differently sized rounds and five snapshotted splits", async function () {
    const s = await unit();
    const receiver = await s.treasury.getAddress();
    let id = 0n;
    let netCapital = 0n;
    let cumulativeRevenue = 0n;
    let cumulativeReserve = 0n;
    for (const share of [1n, 3333n, 5000n, 9999n, 10000n]) {
      await enable(s, s.treasury, share);
      for (const gross of [1n, 19n, 20n, 21n, 99n, 100n, 101n, 999n, 1000n, 1001n, 12345n]) {
        id++;
        await fund(s, id, gross);
        const fee = gross * 500n / 10000n;
        netCapital += gross - fee;
        for (const bps of [2000n, 6000n, 10000n]) {
          await s.fundingPool.releaseProgressiveFundingRoundFee(id, bps);
          const earned = fee * bps / 10000n;
          const revenue = earned * share / 10000n;
          const pending = await s.fundingPool.pendingRevenueByTreasury(receiver);
          if (pending > 0n) await s.treasury.collect(pending);
          expect((await s.fundingPool.fundingRoundRevenue(id))[2]).to.equal(revenue);
          expect(await s.fundingPool.protocolReserve()).to.equal(cumulativeReserve + earned - revenue);
          const actual = await s.usdc.balanceOf(await s.fundingPool.getAddress());
          expect(actual).to.equal(netCapital + cumulativeReserve + earned - revenue + fee - earned);
          expect(await s.fundingPool.totalPoolBalance()).to.equal(actual);
          expect(await s.usdc.balanceOf(receiver)).to.equal(cumulativeRevenue + revenue);
        }
        cumulativeRevenue += fee * share / 10000n;
        cumulativeReserve += fee - fee * share / 10000n;
      }
    }
  });

  it("fixes beneficiaries, supports relayers and accounts for later receipts and rounding dust", async function () {
    const s = await unit();
    expect(await s.treasury.payeeCount()).to.equal(2n);
    expect(await s.treasury.payeeAt(0)).to.equal(s.user4.address);
    await expect(s.treasury.payeeAt(2)).to.revert(s.ethers);
    expect(await s.treasury.releasable(s.user2.address)).to.equal(0n);
    await expect(s.treasury.release(s.user2.address)).to.be.revertedWithCustomError(s.treasury, "NothingToRelease");
    await s.usdc.transfer(await s.treasury.getAddress(), 7);
    const before = await s.usdc.balanceOf(s.user4.address);
    await s.treasury.connect(s.user2).release(s.user4.address);
    expect(await s.usdc.balanceOf(s.user4.address)).to.equal(before + 4n);
    await s.treasury.release(s.user5.address);
    expect(await s.usdc.balanceOf(await s.treasury.getAddress())).to.equal(1n);
    await expect(s.treasury.release(s.user4.address)).to.be.revertedWithCustomError(s.treasury, "NothingToRelease");
    await s.usdc.transfer(await s.treasury.getAddress(), 3);
    await s.treasury.release(s.user4.address);
    await s.treasury.release(s.user5.address);
    expect(await s.treasury.totalReleased()).to.equal(10n);
    expect(await s.usdc.balanceOf(await s.treasury.getAddress())).to.equal(0n);
    expect(s.treasury.interface.hasFunction("upgradeToAndCall")).to.equal(false);
    expect(s.treasury.interface.hasFunction("withdraw")).to.equal(false);
  });

  it("rejects invalid immutable Treasury construction", async function () {
    const s = await unit();
    const pool = await s.fundingPool.getAddress();
    const token = await s.usdc.getAddress();
    const deploy = (p: string, t: string, payees: string[], shares: number[]) =>
      s.ethers.deployContract("ProtocolRevenueTreasury", [p, t, payees, shares]);
    for (const [p, t, payees, shares] of [
      [s.user1.address, token, [s.user4.address], [10000]],
      [pool, s.user1.address, [s.user4.address], [10000]],
      [pool, token, [], []], [pool, token, [s.user4.address], []],
      [pool, token, [s.ethers.ZeroAddress], [10000]],
      [pool, token, [pool], [10000]],
      [pool, token, [s.user4.address, s.user4.address], [5000, 5000]],
      [pool, token, [s.user4.address], [9999]],
      [pool, token, [s.user4.address], [0]],
      [pool, token, [s.user4.address], [10001]],
      [pool, token, Array(17).fill(s.user4.address), Array(17).fill(1000)],
    ] as [string, string, string[], number[]][]) {
      await expect(deploy(p, t, payees, shares)).to.be.revertedWithCustomError(s.treasury, "InvalidRevenueTreasury");
    }
    const otherToken = await s.ethers.deployContract("MockUSDC");
    await expect(deploy(pool, await otherToken.getAddress(), [s.user4.address], [10000]))
      .to.be.revertedWithCustomError(s.treasury, "InvalidRevenueTreasury");
  });

  async function realRound(legacy = false) {
    const s = await deploySystem();
    if (legacy) {
      const oldImpl = await new s.ethers.ContractFactory(baseline.abi, baseline.bytecode, s.admin).deploy();
      const init = oldImpl.interface.encodeFunctionData("initialize", [await s.usdc.getAddress(), await s.ideaRegistry.getAddress(), await s.roles.getAddress()]);
      const proxy = await new s.ethers.ContractFactory(transparent.abi, transparent.bytecode, s.admin)
        .deploy(await oldImpl.getAddress(), s.admin.address, init);
      s.fundingPool = new s.ethers.Contract(await proxy.getAddress(), baseline.abi, s.admin);
      for (const contract of [s.ideaRegistry, s.votingSystem, s.grantManager]) await contract.setFundingPool(await proxy.getAddress());
      for (const user of [s.admin, s.user1, s.user2, s.user3, s.user4, s.user5]) {
        await s.usdc.connect(user).approve(await proxy.getAddress(), s.ethers.MaxUint256);
      }
    }
    await s.fundingPool.unpause();
    await s.votingSystem.unpause();
    await s.votingSystem.setIdeaPerRound(5);
    await s.grantManager.unpause();
    const human = await s.ethers.deployContract("MockHumanVerifier");
    for (const user of [s.user2, s.user3, s.user4, s.user5]) await human.setVerified(user.address, true);
    await s.votingSystem.setHumanVerifier(await human.getAddress());
    await s.votingSystem.setHumanOnlyVoting(true);
    await s.votingSystem.setBackerMilestonesEnabled(true);
    s.treasury = await treasuryFor(s);
    return s;
  }

  async function settleReal(s: any) {
    await createIdeas(s.ideaRegistry, s.user1, 5);
    for (let i = 1; i <= 5; ++i) await s.ideaRegistry.connect(s.user1).commitFundingMilestonePlan(i, `ipfs://plan-${i}`, s.ethers.id(`plan-${i}`));
    await s.votingSystem.startFundingRound();
    s.pledge = s.ethers.parseUnits("20", 6);
    for (const user of [s.user2, s.user3, s.user4]) await s.votingSystem.connect(user).vote(1, 1, s.pledge);
    await s.votingSystem.connect(s.user5).vote(1, 2, s.pledge);
    const round = await s.votingSystem.getRoundInfo(1);
    await s.networkHelpers.time.increaseTo(round[3] + 1n);
    await s.votingSystem.endVotingRound(1);
    s.reserveAtSettlement = await s.fundingPool.protocolReserve();
  }

  it("preserves the full real V2.3 20/40/40 flow and losing refunds while revenue is collected between milestones", async function () {
    const s = await realRound();
    await enable(s);
    await settleReal(s);
    const gross = s.pledge * 3n;
    const fee = gross * 500n / 10_000n;
    const authorBefore = await s.usdc.balanceOf(s.user1.address);
    await s.grantManager.connect(s.user1).claimGrant(1);
    await s.treasury.collect(fee * 20n / 100n * 4000n / 10_000n);
    for (const stage of [1, 2]) {
      await s.grantManager.connect(s.user1).submitBackerMilestoneProof(1, stage, `ipfs://proof-${stage}`, "Delivered", s.ethers.id(`proof-${stage}`));
      for (const user of [s.user2, s.user3, s.user4]) await s.grantManager.connect(user).castBackerMilestoneVote(1, stage, true);
      const request = await s.grantManager.getMilestoneRequest(1, stage);
      await s.networkHelpers.time.increaseTo(request[3] + await s.grantManager.MILESTONE_REVIEW_WINDOW());
      await s.grantManager.finalizeBackerMilestone(1, stage);
      await s.treasury.collect(await s.fundingPool.pendingRevenueByTreasury(await s.treasury.getAddress()));
    }
    expect(await s.usdc.balanceOf(s.user1.address)).to.equal(authorBefore + 1n + gross - fee);
    const loserBefore = await s.usdc.balanceOf(s.user5.address);
    await s.fundingPool.connect(s.user5).claimPledgeRefund(1);
    expect(await s.usdc.balanceOf(s.user5.address)).to.equal(loserBefore + s.pledge);
    expect(await s.usdc.balanceOf(await s.treasury.getAddress())).to.equal(fee * 4000n / 10_000n);
    expect(await s.fundingPool.protocolReserve()).to.equal(s.reserveAtSettlement + fee * 6000n / 10_000n);
    expect(await s.fundingPool.totalPoolBalance()).to.equal(await s.usdc.balanceOf(await s.fundingPool.getAddress()));
  });

  it("restores all unearned fees on real grant failure after earned revenue was already paid", async function () {
    const s = await realRound();
    await enable(s);
    await settleReal(s);
    await s.grantManager.connect(s.user1).claimGrant(1);
    await s.treasury.collect(await s.fundingPool.totalPendingProtocolRevenue());
    await s.networkHelpers.time.increase(await s.grantManager.IN_PROCESS_SUBMISSION_WINDOW() + 1n);
    await s.grantManager.cancelExpiredGrant(1);
    for (const user of [s.user2, s.user3, s.user4]) {
      const before = await s.usdc.balanceOf(user.address);
      await s.fundingPool.connect(user).claimPledgeRefund(1);
      expect(await s.usdc.balanceOf(user.address)).to.equal(before + s.pledge * 80n / 100n);
    }
    expect(await s.fundingPool.pendingProtocolFeeByRound(1)).to.equal(0n);
    expect(await s.fundingPool.totalPendingProtocolRevenue()).to.equal(0n);
    expect(await s.fundingPool.protocolReserve()).to.equal(s.reserveAtSettlement + s.pledge * 3n * 500n / 10_000n * 20n / 100n * 6000n / 10_000n);
  });

  it("returns the entire gross real pledge when a winning grant is never claimed", async function () {
    const s = await realRound();
    await enable(s);
    await settleReal(s);
    const round = await s.votingSystem.getRoundInfo(1);
    await s.networkHelpers.time.increaseTo(round[3] + await s.grantManager.GRANT_CLAIM_WINDOW() + 1n);
    await s.grantManager.expireUnclaimedGrant(1);
    for (const user of [s.user2, s.user3, s.user4, s.user5]) {
      const before = await s.usdc.balanceOf(user.address);
      await s.fundingPool.connect(user).claimPledgeRefund(1);
      expect(await s.usdc.balanceOf(user.address)).to.equal(before + s.pledge);
    }
    expect(await s.fundingPool.totalPendingProtocolRevenue()).to.equal(0n);
  });

  it("preserves the final 40 percent real refund after both earlier fee shares were collected", async function () {
    const s = await realRound();
    await enable(s);
    await settleReal(s);
    await s.grantManager.connect(s.user1).claimGrant(1);
    await s.treasury.collect(await s.fundingPool.totalPendingProtocolRevenue());
    await s.grantManager.connect(s.user1).submitBackerMilestoneProof(1, 1, "ipfs://stage-one", "Delivered", s.ethers.id("stage-one"));
    for (const user of [s.user2, s.user3, s.user4]) await s.grantManager.connect(user).castBackerMilestoneVote(1, 1, true);
    const request = await s.grantManager.getMilestoneRequest(1, 1);
    await s.networkHelpers.time.increaseTo(request[3] + await s.grantManager.MILESTONE_REVIEW_WINDOW());
    await s.grantManager.finalizeBackerMilestone(1, 1);
    await s.treasury.collect(await s.fundingPool.totalPendingProtocolRevenue());
    await s.networkHelpers.time.increase(await s.grantManager.COMPLETION_SUBMISSION_WINDOW() + 1n);
    await s.grantManager.cancelExpiredGrant(1);
    for (const user of [s.user2, s.user3, s.user4]) {
      const before = await s.usdc.balanceOf(user.address);
      await s.fundingPool.connect(user).claimPledgeRefund(1);
      expect(await s.usdc.balanceOf(user.address)).to.equal(before + s.pledge * 40n / 100n);
    }
    expect(await s.fundingPool.totalPendingProtocolRevenue()).to.equal(0n);
    expect(await s.fundingPool.totalPoolBalance()).to.equal(await s.usdc.balanceOf(await s.fundingPool.getAddress()));
  });

  it("upgrades a populated real Transparent proxy without resetting old rounds, bonds, reserve or allowlist", async function () {
    const s = await realRound(true);
    await s.fundingPool.deposit(1234);
    const factory = await s.ethers.deployContract("MockCommunityFactoryRegistry");
    const v3 = await s.ethers.deployContract("MockCommunityReserveTreasury", [await s.usdc.getAddress()]);
    await s.fundingPool.setCommunityFactory(await factory.getAddress());
    await factory.setActiveCommunityTreasury(await v3.getAddress(), true);
    await s.usdc.mint(await v3.getAddress(), 70);
    await v3.routeReserve(await s.fundingPool.getAddress(), 70);
    await settleReal(s);
    await s.grantManager.connect(s.user1).claimGrant(1);
    const before = {
      balance: await s.fundingPool.totalPoolBalance(), reserve: await s.fundingPool.protocolReserve(),
      donor: await s.fundingPool.donorBalances(s.admin.address), pledge: [...await s.fundingPool.getPledge(1, s.user2.address)],
      pending: await s.fundingPool.pendingProtocolFeeByRound(1), released: await s.fundingPool.progressiveFeeReleasedByRound(1),
      bond: await s.fundingPool.authorStakeByIdea(2), net: await s.fundingPool.poolByRoundAndIdea(1, 1),
    };
    const poolAddress = await s.fundingPool.getAddress();
    const adminSlot = s.ethers.toBeHex(BigInt(s.ethers.id("eip1967.proxy.admin")) - 1n, 32);
    const adminWord = await s.ethers.provider.getStorage(poolAddress, adminSlot);
    const adminAddress = s.ethers.getAddress(`0x${adminWord.slice(-40)}`);
    const newImpl = await s.ethers.deployContract("FundingPoolUpgradeable");
    const proxyAdmin = new s.ethers.Contract(adminAddress, proxyAdminABI, s.admin);
    await proxyAdmin.upgradeAndCall(poolAddress, await newImpl.getAddress(), "0x");
    s.fundingPool = await s.ethers.getContractAt("FundingPoolUpgradeable", poolAddress);
    expect(await s.fundingPool.totalPoolBalance()).to.equal(before.balance);
    expect(await s.fundingPool.protocolReserve()).to.equal(before.reserve);
    expect(await s.fundingPool.donorBalances(s.admin.address)).to.equal(before.donor);
    expect([...await s.fundingPool.getPledge(1, s.user2.address)]).to.deep.equal(before.pledge);
    expect(await s.fundingPool.pendingProtocolFeeByRound(1)).to.equal(before.pending);
    expect(await s.fundingPool.progressiveFeeReleasedByRound(1)).to.equal(before.released);
    expect(await s.fundingPool.authorStakeByIdea(2)).to.equal(before.bond);
    expect(await s.fundingPool.poolByRoundAndIdea(1, 1)).to.equal(before.net);
    expect(await s.fundingPool.isCommunityFactoryApproved(await factory.getAddress())).to.equal(true);
    expect(await s.fundingPool.totalPendingProtocolRevenue()).to.equal(0n);
    await enable(s);
    await s.grantManager.connect(s.user1).submitBackerMilestoneProof(1, 1, "ipfs://old-proof", "Delivered", s.ethers.id("old-proof"));
    for (const user of [s.user2, s.user3, s.user4]) await s.grantManager.connect(user).castBackerMilestoneVote(1, 1, true);
    const request = await s.grantManager.getMilestoneRequest(1, 1);
    await s.networkHelpers.time.increaseTo(request[3] + await s.grantManager.MILESTONE_REVIEW_WINDOW());
    await s.grantManager.finalizeBackerMilestone(1, 1);
    expect(await s.fundingPool.totalPendingProtocolRevenue()).to.equal(0n);
    await s.networkHelpers.time.increase(await s.grantManager.COMPLETION_SUBMISSION_WINDOW() + 1n);
    await s.grantManager.cancelExpiredGrant(1);
    await s.fundingPool.connect(s.user2).claimPledgeRefund(1);
    await s.usdc.mint(await v3.getAddress(), 1);
    await v3.routeReserve(poolAddress, 1);
    expect(await s.fundingPool.totalPoolBalance()).to.equal(await s.usdc.balanceOf(poolAddress));
  });

  it("preserves every pre-existing storage type/slot and consumes exactly ten reserved slots", async function () {
    const artifact = JSON.parse(fs.readFileSync("artifacts/contracts/BERT/DAO/FundingPoolUpgradeable.sol/FundingPoolUpgradeable.json", "utf8"));
    const build = JSON.parse(fs.readFileSync(`artifacts/build-info/${artifact.buildInfoId}.output.json`, "utf8"));
    const next = build.output.contracts[artifact.inputSourceName].FundingPoolUpgradeable.storageLayout;
    expect(next, "current compiler storage output").not.to.equal(undefined);
    function shape(types: any, id: string): any {
      const t = types[id];
      return { encoding: t.encoding, label: t.label, bytes: t.numberOfBytes,
        key: t.key ? shape(types, t.key) : undefined, value: t.value ? shape(types, t.value) : undefined,
        base: t.base ? shape(types, t.base) : undefined,
        members: t.members?.map((m: any) => ({ label: m.label, slot: m.slot, offset: m.offset, type: shape(types, m.type) })),
      };
    }
    const old = baseline.storageLayout;
    for (const [index, prior] of old.storage.slice(0, -1).entries()) {
      const now = next.storage[index];
      expect(now.label).to.equal(prior.label);
      expect(now?.slot, prior.label).to.equal(prior.slot);
      expect(now?.offset, prior.label).to.equal(prior.offset);
      expect(shape(next.types, now.type), prior.label).to.deep.equal(shape(old.types, prior.type));
    }
    const oldGap = old.storage.at(-1);
    const nextGap = next.storage.at(-1);
    expect(BigInt(nextGap.slot)).to.equal(BigInt(oldGap.slot) + 10n);
    expect(BigInt(next.types[nextGap.type].numberOfBytes)).to.equal(19n * 32n);
    expect(BigInt(nextGap.slot) * 32n + BigInt(next.types[nextGap.type].numberOfBytes))
      .to.equal(BigInt(oldGap.slot) * 32n + BigInt(old.types[oldGap.type].numberOfBytes));
  });
});
