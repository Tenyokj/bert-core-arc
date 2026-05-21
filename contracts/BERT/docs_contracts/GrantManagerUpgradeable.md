# GrantManagerUpgradeable

**Summary**
Coordinates the grant lifecycle and milestone-based capital release after voting rounds settle.

**Role In System**
Reads round outcomes, validates winning proposal eligibility, and triggers staged distribution from the funding pool.

**Key Features**
- Validates round completion and winning idea eligibility
- Releases the initial author share on claim
- Handles milestone proof submission and reviewer approvals
- Releases staged payouts in a `30/40/30` flow
- Updates idea status through `Funded`, `InProcess`, and `Completed`
- Exposes helper view functions for claimability and payout state
- Pausable for safety

**Access Control**
- Uses `RolesAwareUpgradeable` modifiers
- Critical actions are restricted by protocol roles

**Dependencies**
- `VotingSystemUpgradeable` for round results
- `FundingPoolUpgradeable` for USDC distributions
- `IdeaRegistryUpgradeable` for idea status and author validation
- `RolesRegistryUpgradeable` for access control

**Upgradeability**
Upgradeable and pausable. Storage gap is included.
