# CommunityFactory

**Summary**
Upgradeable registry and activation gateway for BERT V3 communities.

**Role In System**
Reserves one Treasury for a creator, verifies that their separately deployed Hub has the exact immutable configuration, links both contracts, and exposes active-Treasury verification to V2 FundingPool.

**Key Features**
- Deploys a Treasury through `CommunityTreasuryDeployer`
- Assigns a monotonic community ID
- Stores creator, Hub, Treasury, creation time, and config hash
- Activates only a Hub with matching creator, Treasury, and configuration
- Exposes `isActiveCommunityTreasury` for V2 reserve authentication

**Access Control**
- Anyone may reserve a community for themselves
- Only the recorded creator may activate that community
- The Factory has no admin authority over a community after activation

**Dependencies**
- `CommunityTreasuryDeployer`
- `CommunityHub`
- `CommunityTreasury`

**Upgradeability**
Deployed behind an OpenZeppelin v5 `TransparentUpgradeableProxy`. The implementation disables its own initializer. New storage must only be appended before the reserved storage gap.

**Critical Invariants**
- One Treasury cannot be activated by multiple Hubs
- A Hub cannot be activated for a different creator or configuration
- V2 FundingPool accepts reserve inflow only from an activated Treasury
