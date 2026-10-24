# GrantManagerUpgradeable

**Summary**
Coordinates a viable BERT V2 grant from author claim through milestone review, payout, expiry, and refund activation.

**Role In System**
It reads the winner from `VotingSystemUpgradeable`, validates the winning author and lifecycle state through `IdeaRegistryUpgradeable`, and instructs `FundingPoolUpgradeable` to move only authorized net grant capital.

**Key Features**
- Validates claim eligibility for a viable round winner
- Vests the snapshotted V2.3 successful-round fee progressively with author tranches
- Releases a V2.3 net winning grant in `20 / 40 / 40`; legacy rounds retain `30 / 40 / 30`
- Handles V2.3 winning-backer proof votes, finalization, correction, no-quorum grace and cancellation; retains separate reviewer paths for legacy rounds
- Expires unclaimed winners and incomplete live grants into their defined refund paths
- Exposes claimability, payout, and milestone-request views

**Deadline Policy**
- winning author claim window: 14 days after round end
- stage-one submission window: 45 days after initial payout
- stage-two submission window: 60 days after stage-one payout
- active review window: 14 days
- rejected-proof cooldown: 48 hours
- V2.3 no-quorum grace: seven days, once

**Round Policy Selection**
`VotingSystem.isBackerMilestoneRound(roundId)` selects the immutable policy stored
when that round started. `INITIAL_PAYOUT_PERCENT = 30` and the legacy reviewer
thresholds remain executable only for legacy rounds. Constants occupy no ordinary
storage slots. They are not retained as storage padding; changing them would
change legacy economics. V2.3 selects `BACKER_INITIAL_PAYOUT_PERCENT = 20`.

V2.3 review requires 40% winning-weight participation, exact two-thirds approval
of participating weight, and three eligible approving winning backers. The author
cannot vote. A failed plan restores the unpaid net grant plus unvested fee to
winning-cohort pull refunds. See [current release](../../../docs/CURRENT-RELEASE.md).

**Payout Boundary**
The payout base is the winner's net pledge after the round fee. `authorSharePercent` remains only as a deprecated retained storage slot for proxy-layout compatibility; it is not used by the current conditional-pledge payout calculation. Unlike constants, this variable really is part of proxy storage.

**Dependencies**
- `VotingSystemUpgradeable` for round results
- `FundingPoolUpgradeable` for fee, refund, and USDC distribution actions
- `IdeaRegistryUpgradeable` for author validation and status changes
- `RolesRegistryUpgradeable` for access control

**Upgradeability**
Upgradeable and pausable. Payout state is written before external accounting calls to preserve a Checks-Effects-Interactions boundary.
