# BERT V3.0 Archive

This directory preserves the previous BERT Community Layer as the historical
V3.0 implementation. It includes the V3.0 contracts, tests, mocks, deployment
scripts, and documentation that correspond to testnet Communities created
before the modular V3 rewrite.

## Important Boundaries

1. V3.0 contracts remain deployed on testnet and cannot be deleted or upgraded
   into the modular V3 architecture.
2. This archive is outside Hardhat's `contracts/` and `test/` directories on
   purpose. Compiling it together with current V3 would create duplicate
   artifacts named `CommunityFactory`, `CommunityHub`, and `CommunityTreasury`.
3. Do not import V3.0 code into current V3. Use this archive only to inspect
   historical behavior, investigate old events, or reproduce an old deployment
   from the commit immediately before the V3 archive migration.
4. New Communities must use the current modular source under
   [`contracts/BERT/V3`](../../contracts/BERT/V3/README.md).

## Contents

- `contracts/BERT/V3/`: V3.0 source and contract documentation.
- `contracts/Mocks/`: V3.0-only test mocks.
- `test/V3/`: V3.0 test suite.
- `scripts/deploy/`: V3.0 deployment and verification scripts.
- `docs/`: V3.0 file index.

The archive is historical source, not an active deployment target.
