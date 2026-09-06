# BERT V3 Interfaces

**Summary**
Interfaces define the explicit trust boundaries between V3 contracts and the existing V2 reserve.

## `ICommunityFactory`
Exposes community creation, activation, deployment lookup, creator indexing, and active-Treasury verification.

## `ICommunityHub`
Exposes immutable identity, local admin checks, community status, reward settings, recorded binary votes, and validator epoch activity required by Treasury.

## `ICommunityTreasury`
Defines Hub-directed deposits and settlements, user refund and reward claims, withdrawal operations, and Factory-only Hub pairing.

## `ICommunityTreasuryDeployer`
Defines Treasury deployment for Factory without importing its creation bytecode.

## `IGlobalBertReserve`
Defines `receiveCommunityReserve(uint256)`, the V2 FundingPool entrypoint that pulls protocol-level V3 inflow and updates V2 reserve accounting.

## V2 Integration Interface
`contracts/BERT/interfaces/ICommunityFactoryRegistry.sol` is implemented by V3 Factory and consumed by V2 FundingPool. It allows FundingPool to verify that a caller Treasury is active before accepting reserve capital.
