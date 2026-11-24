import assert from "node:assert/strict";
import { Interface } from "ethers";

const assetEvents = new Interface(["event Transfer(address indexed from,address indexed to,uint256 value)"]);
const depositCall = new Interface(["function deposit(uint256 amount)"]);
const same = (a, b) => a?.toLowerCase() === b?.toLowerCase();
const sum = (values) => [...values].reduce((a, b) => a + b, 0n);

// Deliberately bounded to pre-round custody: unfamiliar financial activity fails closed.
export function reconcilePreRoundInventory({ pool, token, abi, transactions, snapshot }) {
  const events = new Interface(abi);
  const bonds = new Map();
  const donors = new Map();
  const transfers = [];
  const missingFromAddressIndex = [];
  let deposits = 0n;
  let bonded = 0n;
  let returned = 0n;
  let accounted = 0n;
  let poolLogCount = 0;
  const neutral = new Set(["FundingPoolInitialized", "Initialized", "Paused", "Unpaused",
    "CommunityFactoryUpdated", "CommunityFactoryApprovalUpdated", "PledgeFeeUpdated"]);
  const proxyTopics = new Set([
    new Interface(["event Upgraded(address indexed implementation)"]).getEvent("Upgraded").topicHash,
    new Interface(["event AdminChanged(address previousAdmin,address newAdmin)"]).getEvent("AdminChanged").topicHash,
  ]);
  const ordered = [...transactions].sort((a, b) => a.blockNumber - b.blockNumber || a.index - b.index);
  const seen = new Set();
  for (const tx of ordered) {
    assert(!seen.has(tx.hash), "Duplicate transaction receipt");
    seen.add(tx.hash);
    const expected = [];
    const observed = [];
    for (const log of [...tx.logs].sort((a, b) => a.index - b.index)) {
      if (same(log.address, token)) {
        const event = assetEvents.parseLog(log);
        if (event?.name === "Transfer" && (same(event.args.from, pool) || same(event.args.to, pool))) {
          observed.push([event.args.from.toLowerCase(), event.args.to.toLowerCase(), event.args.value]);
        }
      }
      if (!same(log.address, pool)) continue;
      poolLogCount++;
      if (!log.inAddressIndex) missingFromAddressIndex.push({ transactionHash: tx.hash, logIndex: log.index });
      if (proxyTopics.has(log.topics[0])) continue;
      const event = events.parseLog(log);
      assert(event, `Unknown pool event ${log.topics[0]}`);
      const a = event.args;
      if (event.name === "FundsDeposited") {
        assert(same(tx.to, pool), "Non-direct deposit requires a conditional/legacy voting inventory");
        const call = depositCall.parseTransaction({ data: tx.data });
        assert(call?.name === "deposit" && call.args.amount === a.amount && same(tx.from, a[0]),
          "Deposit calldata/event mismatch");
        deposits += a.amount;
        accounted += a.amount;
        const donor = a[0].toLowerCase();
        donors.set(donor, (donors.get(donor) ?? 0n) + a.amount);
        expected.push([donor, pool.toLowerCase(), a.amount]);
      } else if (event.name === "AuthorStakeDeposited") {
        const key = a.ideaId.toString();
        const author = a.author.toLowerCase();
        const old = bonds.get(key);
        assert(!old || old.author === author, "Bond author changed");
        bonds.set(key, { author, amount: (old?.amount ?? 0n) + a.amount });
        donors.set(author, (donors.get(author) ?? 0n) + a.amount);
        bonded += a.amount;
        accounted += a.amount;
        expected.push([author, pool.toLowerCase(), a.amount]);
      } else if (event.name === "AuthorStakeReleased") {
        const bond = bonds.get(a.ideaId.toString());
        assert(bond && same(bond.author, a.author) && bond.amount >= a.amount, "Unmatched bond return");
        bond.amount -= a.amount;
        donors.set(bond.author, donors.get(bond.author) - a.amount);
        returned += a.amount;
        accounted -= a.amount;
        expected.push([pool.toLowerCase(), bond.author, a.amount]);
      } else if (event.name === "PoolBalanceUpdated") {
        assert.equal(accounted, a.newBalance, `Ledger replay diverged at ${tx.hash}:${log.index}`);
      } else assert(neutral.has(event.name), `Unsupported financial/configuration event: ${event.name}`);
    }
    assert.deepEqual(observed, expected, `Asset transfers do not match pool events in ${tx.hash}`);
    transfers.push(...observed.map(([from, to, amount]) => ({ transactionHash: tx.hash, from, to, amount })));
  }
  assert.equal(BigInt(snapshot.protocolReserve), 0n, "Nonzero reserve needs a broader inventory");
  assert.equal(BigInt(snapshot.currentRoundId), 1n, "Opened voting rounds need a broader inventory");
  assert.equal(BigInt(snapshot.distributionCount), 0n, "Historical grants need a broader inventory");
  assert.equal(snapshot.roundLedgersEmpty, true, "Round/grant ledgers are not empty");
  assert.equal(BigInt(snapshot.totalIdeas), BigInt(bonds.size), "Missing idea/bond history");
  for (const [idea, bond] of bonds) {
    assert.equal(bond.amount, BigInt(snapshot.authorStakes[idea]), `Bond mismatch for idea ${idea}`);
    assert(same(bond.author, snapshot.authors[idea]), `Author mismatch for idea ${idea}`);
  }
  assert.equal(donors.size, Object.keys(snapshot.donorBalances).length, "Donor inventory differs");
  for (const [donor, balance] of donors) {
    assert.equal(balance, BigInt(snapshot.donorBalances[donor]), `Donor ledger mismatch for ${donor}`);
  }
  const lockedBonds = sum([...bonds.values()].map((b) => b.amount));
  assert.equal(bonded - returned, lockedBonds);
  assert.equal(accounted, deposits + lockedBonds);
  assert.equal(accounted, BigInt(snapshot.totalPoolBalance), "Recorded custody differs from reconstructed flows");
  assert.equal(accounted, BigInt(snapshot.actualBalance), "Actual custody differs from reconstructed flows");
  return { directDeposits: deposits, authorBondsDeposited: bonded, authorBondsReturned: returned,
    lockedAuthorBonds: lockedBonds, accounted, reserve: 0n, teamRevenue: 0n,
    poolLogCount, transfers, missingFromAddressIndex,
    categories: { directDeposits: deposits, lockedAuthorBonds: lockedBonds },
    warning: "Direct deposits are historical contributions, not team revenue or automatically withdrawable donor claims." };
}
