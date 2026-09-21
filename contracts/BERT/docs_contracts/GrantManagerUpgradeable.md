# GrantManagerUpgradeable

**Summary**
Coordinates a viable BERT V2 grant from author claim through milestone review, payout, expiry, and refund activation.

**Role In System**
It reads the winner from `VotingSystemUpgradeable`, validates the winning author and lifecycle state through `IdeaRegistryUpgradeable`, and instructs `FundingPoolUpgradeable` to move only authorized net grant capital.

**Key Features**
- Validates claim eligibility for a viable round winner
- Finalizes the pending successful-round fee only when the author starts the grant
- Releases the net winning pledge in a `30 / 40 / 30` schedule
- Handles milestone proof submission, reviewer approvals, rejections, and cooldown
- Expires unclaimed winners and incomplete live grants into their defined refund paths
- Exposes claimability, payout, and milestone-request views

**Deadline Policy**
- winning author claim window: 14 days after round end
- stage-one submission window: 45 days after initial payout
- stage-two submission window: 60 days after stage-one payout
- active review window: 14 days
- rejected-proof cooldown: 48 hours

**Payout Boundary**
The payout base is the winner's net pledge after the round fee. `authorSharePercent` remains only as a deprecated retained storage slot for proxy-layout compatibility; it is not used by the V2.0 stake-backed payout calculation.

**Dependencies**
- `VotingSystemUpgradeable` for round results
- `FundingPoolUpgradeable` for fee, refund, and USDC distribution actions
- `IdeaRegistryUpgradeable` for author validation and status changes
- `RolesRegistryUpgradeable` for access control

**Upgradeability**
Upgradeable and pausable. Payout state is written before external accounting calls to preserve a Checks-Effects-Interactions boundary.
