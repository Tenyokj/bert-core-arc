# Contributing to BERT Core

BERT is active on Arc Testnet. Contributions are welcome, but Core controls
real testnet contract state and is security-sensitive. A pull request is not a
promise of merge, payment, token allocation, role assignment, or deployment
access.

## Where Help Is Needed

| Contribution area | Current need | Good first contribution |
| --- | --- | --- |
| Protocol QA | Testers for V2.3 and V3.2 flows (plus legacy V3.1 compatibility), negative cases and UX/chain mismatches | Execute a matrix case from [`docs/TESTING.md`](docs/TESTING.md) and submit reproducible evidence. |
| Solidity | Developers who can improve tests, invariants, tooling and reviewed protocol changes | Add a focused regression test or improve a documented developer tool. |
| Security | Smart-contract reviewers and auditors | Reproduce a realistic finding locally; use private disclosure for exploitable issues. |
| Frontend | Developers who can improve wallet UX, live reads, ABI synchronization and accessibility | Contribute in [`bert-front-arc`](https://github.com/Tenyokj/bert-front-arc), then document any Core dependency. |
| Documentation | Developers and technical writers who can make contract behavior reproducible | Correct a claim against source and test it with the current deployment record. |
| Community and SMM | People who can translate verified protocol work into accurate public education | Coordinate a factual content proposal before publishing; never promise returns, audits, mainnet dates or rewards. |

Use a focused GitHub issue in the affected repository to share a reproducible
test result or proposed task. Community organizers can request a pilot via
[bertdaoarc@gmail.com](mailto:bertdaoarc@gmail.com); the
[Telegram channel](https://t.me/bertdao) carries public updates. Do not share
secrets, seed phrases, private keys or unreported exploit details.

If you are new to BERT, start with the focused
[contributor issue drafts](docs/STARTER-ISSUES.md) rather than the full protocol
matrix. Community organizers can first review the
[Arc Testnet pilot](docs/COMMUNITY-PILOT.md) without connecting a wallet.

## Before You Start

1. Read [`docs/TESTING.md`](docs/TESTING.md), [`SECURITY.md`](SECURITY.md), and
   the relevant V2.3 or current V3 documentation.
2. For a substantial feature, architecture change, deployment change or UX
   flow, open an issue or discuss the proposal before writing a large patch.
3. Fork the repository and create a focused branch. Protected branches accept
   changes through pull requests only.
4. Keep unrelated formatting, generated artifacts and personal editor files out
   of the pull request.
5. Never commit `.env` files, deployer keys, RPC credentials, Graph deploy
   keys, test-wallet private keys, provider signatures or production secrets.

## Local Checks

```bash
npm install
npx hardhat compile
npx hardhat test
npx hardhat --coverage
slither . --filter-paths "node_modules|test|legacy"
```

The V3.2 local lab is documented in
[`docs/LOCAL-V3.1-E2E.md`](docs/LOCAL-V3.1-E2E.md). It uses an isolated
Hardhat chain, MockUSDC and public development accounts only. Do not lower
Solidity timing constraints merely to make a demo faster; use the provided
time-travel helper.

## Smart-Contract Requirements

- Preserve storage layout and initializer safety for upgradeable V2 contracts.
- Treat V3.2 as a separate Community Factory deployment; do not reinterpret,
  overwrite or silently migrate historical V3.0 Communities.
- Keep USDC accounting purpose-specific. A successful ERC-20 transfer alone
  does not prove correct protocol accounting.
- Preserve role, Factory/Hub/module capability and pause boundaries. Every
  sensitive path needs a negative test with an unrelated caller.
- Test both success and failure/cancellation/refund paths for any accounting or
  lifecycle change.
- Update interfaces, artifacts, frontend integration, subgraph mappings and
  deployment documentation whenever a public ABI or event changes.
- Do not change Arc Testnet addresses in prose or code without updating the
  versioned deployment record and recording the verified transaction.

## Pull Request Checklist

Include the following in the PR description:

1. The problem and user/protocol impact.
2. A concise description of changed behavior and unchanged invariants.
3. Tests run, including negative cases; include command output or relevant
   transaction hashes where useful.
4. Storage-layout, ABI, event, frontend, subgraph, documentation and deployment
   impact, explicitly marked `none` when not applicable.
5. Any remaining risk, deferred work or reviewer question.

Keep commits focused and readable. Do not bundle a behavior change with a
large refactor unless both are necessary and explained.

## Security Reports

Do **not** open a public issue, pull request, discussion or commit for a
potentially exploitable vulnerability. Use the
[private Core security advisory channel](https://github.com/Tenyokj/bert-core-arc/security/advisories/new)
and follow [`SECURITY.md`](SECURITY.md). Stop after the minimum proof of impact;
do not touch assets or accounts you do not control.

## Review and Deployment

Maintainers review accepted contributions and retain merge, deployment, proxy
admin and environment-secret access. Testnet deployment and a merged pull
request are not mainnet approval. Any compensation or formal collaboration is
discussed explicitly before work begins.
