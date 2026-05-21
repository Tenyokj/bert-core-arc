# IdeaRegistryUpgradeable

**Summary**
Central registry for ideas. Stores proposal metadata, tracks lifecycle status, enforces author USDC stake on creation, and integrates with reputation and voter progression.

**Role In System**
Acts as the source of truth for ideas and their status. It gates status transitions and enforces role-based actions for voting and grants.

**Key Features**
- Creates ideas with titles, descriptions, optional links, and required author stake
- Tracks per-idea status through the funding lifecycle
- Stores reviews and low-quality flags
- Integrates with `ReputationSystemUpgradeable` for reputation initialization
- Integrates with `VoterProgressionUpgradeable` for voter progression
- Slashes author stake to protocol reserve when an idea is rejected

**Access Control**
- Uses `RolesAwareUpgradeable` modifiers
- Status updates restricted to voting system or grant manager
- Low-quality and review actions limited to curator and reviewer roles

**Dependencies**
- `ReputationSystemUpgradeable` for reputation checks
- `VoterProgressionUpgradeable` for progression hooks
- `FundingPoolUpgradeable` for author stake locking
- `RolesRegistryUpgradeable` for access control

**Asset Semantics**
- Proposal submission stake is validated against the configured USDC-compatible treasury asset
- Default stake values are expected in 6-decimal USDC units

**Upgradeability**
Upgradeable via proxy deployment. Storage gap is included for future upgrades.
