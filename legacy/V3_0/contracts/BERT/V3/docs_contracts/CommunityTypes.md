# CommunityTypes

**Summary**
Shared V3 enum and struct definitions used by Hub, Treasury, Factory, and interfaces.

**Important Enums**
- `CommunityStatus`: `Active`, `Paused`, or `Archived`
- `ProposalOrigin`: admin-created or member-created
- `ProposalMode`: binary or slate
- `ProposalStatus`: validation, voting, settlement, and round-result lifecycle states
- `VoteChoice`: unset, YES, or NO
- `AdminActionType`: protected Community control-plane actions that require Admin quorum

**Important Structs**
- `CommunityConfig`: immutable parameters selected at community creation, including the 1-100 validator proposal-point threshold
- `CommunityDeployment`: Factory record for a creator, Hub, and Treasury
- `Member`: local membership stake, exit state, and proposal points
- `Proposal`: governance metadata, vote totals, validation counters, and settlement state
- `SlateRound`: ordered proposals, timing, vote totals, and winning result
- `ValidatorRewardEpoch`: reward window and validation participation accounting
- `WithdrawalRequest`: recipient, amount, approvals, execution state, reason, and metadata URI
- `AdminActionRequest`: action intent, target/value payload, active-time expiry, approvals, and execution state

**Asset Units**
USDC values in these structs are token-native units. Integrations should format Arc USDC values with six decimals.
