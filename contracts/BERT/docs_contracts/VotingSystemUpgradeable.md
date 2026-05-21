# VotingSystemUpgradeable

**Summary**
Core voting engine that manages rounds, USDC-committed voting, and winner selection.

**Role In System**
Coordinates voting rounds, updates idea status, and triggers reputation and progression updates based on outcomes.

**Key Features**
- Starts and ends voting rounds
- Tracks votes and idea participation
- Applies minimum USDC commitment rules
- Updates idea statuses via `IdeaRegistryUpgradeable`
- Integrates with reputation and voter progression systems
- Pausable for safety

**Access Control**
- Uses `RolesAwareUpgradeable` modifiers
- Key admin functions restricted to `DEFAULT_ADMIN_ROLE`

**Dependencies**
- `FundingPoolUpgradeable` for USDC commitment accounting
- `IdeaRegistryUpgradeable` for idea data and status updates
- `ReputationSystemUpgradeable` for reputation changes
- `VoterProgressionUpgradeable` for progression updates
- `RolesRegistryUpgradeable` for access control

**Asset Semantics**
- Vote weight equals committed USDC amount
- Amounts should be treated as 6-decimal USDC units in integrations

**Upgradeability**
Upgradeable and pausable. Storage gap is included.
