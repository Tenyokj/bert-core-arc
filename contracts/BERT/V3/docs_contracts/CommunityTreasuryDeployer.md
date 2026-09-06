# CommunityTreasuryDeployer

**Summary**
Small immutable deployment helper for `CommunityTreasury` instances.

**Role In System**
Moves Treasury creation bytecode out of `CommunityFactory`, keeping the Factory safely below the EVM runtime size limit.

**Key Features**
- Deploys a Treasury with USDC, V2 global reserve, and Factory addresses
- Emits the created Treasury address and immutable dependencies

**Access Control**
The helper is permissionless. The new Treasury records the Factory passed by the caller; only that Factory can later set the paired Hub.

**Critical Invariant**
Factory activation verifies and links Treasury ownership before V2 accepts the Treasury as an active reserve contributor.
