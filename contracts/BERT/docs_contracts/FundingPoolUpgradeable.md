# FundingPoolUpgradeable

**Summary**
Treasury module that holds USDC, tracks proposal and round-level funding, locks author stake, and distributes milestone-based grants.

**Role In System**
Receives USDC deposits and voting commitments, records pool balances per round and proposal, and pays out grants through the grant manager.

**Key Features**
- Accepts USDC deposits and records donor balances
- Locks author stake for newly created ideas
- Tracks pool balances per round and per idea
- Distributes funds to winning idea authors in staged payouts
- Maintains protocol reserve for carved-out capital and slashed stake
- Can move rejected author stake and reserved round funds into protocol reserve
- Pausable for safety

**Access Control**
- Only voting system can deposit on behalf of voters
- Only distributor role can distribute funds
- Uses `RolesAwareUpgradeable` for role checks

**Dependencies**
- USDC-compatible ERC-20 asset
- `IdeaRegistryUpgradeable` for idea author lookups
- `RolesRegistryUpgradeable` for access control

**Compatibility**
- `usdc()` is the canonical asset getter
- `governanceToken()` remains as a deprecated compatibility getter during migration

**Upgradeability**
Upgradeable and pausable. Storage gap is included.
