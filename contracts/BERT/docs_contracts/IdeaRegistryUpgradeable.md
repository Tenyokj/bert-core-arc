# IdeaRegistryUpgradeable

**Summary**
Central registry for BERT V2 funding proposals. It stores proposal metadata and lifecycle state, locks an author USDC bond, and records each proposal's disclosed `minimumNetFunding` target.

**Role In System**
`IdeaRegistryUpgradeable` is the source of truth for a proposal and its status. It does not custody USDC itself; `FundingPoolUpgradeable` holds the author bond and pledge capital.

**Key Features**
- Creates funding proposals with title, description, optional link, author bond, and minimum net funding target
- Tracks lifecycle state from `Pending` through funding and milestone execution
- Stores reviews and curator low-quality signals
- Integrates with `ReputationSystemUpgradeable` for author initialization
- Locks and, where the lifecycle requires it, slashes the author bond through `FundingPoolUpgradeable`

**Economic Semantics**
- `minimumNetFunding` must be non-zero when a funding proposal is created
- the target is evaluated by `VotingSystemUpgradeable` after applying the fee snapshotted for a round
- `markLowQuality` is informational. It does not independently disqualify a proposal; eligible voters and the round outcome retain authority over selection
- a rejected proposal can have its author bond moved to protocol reserve under the defined lifecycle path

**Access Control**
- status updates are restricted to the voting system or grant manager
- low-quality marking is limited to curator roles
- reviews are limited to reviewer roles

**Dependencies**
- `FundingPoolUpgradeable` for author bond custody
- `ReputationSystemUpgradeable` for author initialization
- `VoterProgressionUpgradeable` for connected progression behavior
- `RolesRegistryUpgradeable` for access control

**Upgradeability**
Upgradeable via proxy deployment. Storage additions must be appended and its reserved storage gap must not be reduced.
