# BERT V3 Contract Documentation

This directory documents the BERT V3 Community Layer contracts. V3 is an extension module of BERT, not a standalone replacement for the V2 protocol.

## Core Contracts

1. [CommunityFactory](CommunityFactory.md) - reserves Treasuries, validates Hub deployment, and indexes communities.
2. [CommunityHub](CommunityHub.md) - local governance state machine for roles, membership, proposals, votes, rounds, and validator epochs.
3. [CommunityTreasury](CommunityTreasury.md) - USDC custody, settlements, refunds, rewards, and admin-quorum withdrawals.
4. [CommunityTreasuryDeployer](CommunityTreasuryDeployer.md) - deploys isolated Treasury instances without increasing Factory bytecode size.

## Shared Definitions

1. [Interfaces](Interfaces.md) - cross-contract boundaries and V2 reserve integration interface.
2. [CommunityTypes](CommunityTypes.md) - lifecycle enums and state structs.
3. [CommunityErrors](CommunityErrors.md) - V3 custom error vocabulary.

## Related Documents

1. [V3 module README](../README.md)
2. [V3 deployment guide](../../../../scripts/deploy/docs_deploy/V3_DEPLOY.md)
3. [Complete V3 file index](../../../../docs/V3-FILE-INDEX.md)
