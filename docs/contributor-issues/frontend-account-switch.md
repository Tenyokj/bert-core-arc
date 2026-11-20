# Frontend QA: verify account-switch state isolation in one V3.2.1 Community

Volunteer task for `Tenyokj/bert-front-arc`; suggested label: `help wanted`.
Requires React/Web3 or experienced QA skills. This is a verification request,
not a claim that an account-switch bug currently exists. Suggested first session:
45-90 minutes; report blockers rather than attempting the whole protocol.

## Scope

Use one V3.2.1 Community and two fresh test wallets with different roles. Record
Factory, Community ID, Hub, chain ID and app commit. If no suitable Community
is available, ask the maintainer for a fixture before doing any setup.
Do not silently substitute an older Community generation.

1. Open `https://bertdao.vercel.app/v3` as wallet A. Record membership, role,
   displayed balance/allowance, and Join/proposal/vote controls.
2. Switch to wallet B without reloading. Check that A's permissions and values
   do not appear as B's confirmed state while reads are pending.
3. Compare membership and permissions with the owning contract/module's reads.
   Record the block or read time; distinguish indexer lag from RPC failure.
4. Switch back to A, then disconnect. Check stale permissions disappear and
   the page does not report a disconnected wallet as eligible to submit.
5. Optional: open one action prompt and reject it. No transaction is required;
   stop if the wallet does not show a safe cancellation path. Rejection must
   not become success or trigger an automatic resend.

This is Arc Testnet (5042002) or a disposable local chain (31337), never mainnet.
Use fresh wallets, no valuable assets, no private keys or credentials in reports.
An `already known`/timeout outcome is uncertain until receipt/state checks,
not automatically a revert or success. Never work around it by guessing a nonce.

## Deliverable

Comment before starting. Submit a report even if everything is consistent:

```text
App commit / URL / browser / device:
Chain / Factory / Community ID / Hub:
Wallet A role / wallet B role (test-only addresses):
Steps and read timestamps / blocks:
Expected / actual state:
Screenshot or redacted logs:
Classification: consistent / UI issue / indexer lag / RPC / blocked:
```

If a bug is reproducible, propose a narrow fix and one regression test; do not
redesign the app or upgrade the wallet stack. No fix is required for an unproven
problem. For a local PR, fork the frontend, branch from `arc-front-migration`,
install with `npm ci`, then run `npm test`, `npm run typecheck`, `npm run lint`
and `npm run build`. See that repository's CONTRIBUTING and DEPENDENCY-SECURITY.
Known dependency findings remain open; this task is not a dependency migration.

Done: reproducible evidence for the account transitions above, or a precise
fixture/setup blocker. If changed, include check results and scope limits.
This is voluntary open-source work, not a paid vacancy or token/role offer.
Possible exploits go to the frontend repository's private security advisory,
not this public issue. No production deployment credentials are needed.
