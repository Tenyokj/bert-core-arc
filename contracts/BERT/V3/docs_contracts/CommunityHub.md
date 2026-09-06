# CommunityHub

**Summary**
Immutable per-community governance engine for local roles, membership, proposal validation, binary voting, slate rounds, and validator reward epochs.

**Role In System**
Owns community governance state and instructs its paired Treasury to move USDC only after valid lifecycle transitions.

**Key Features**
- Stake-gated member join and cooldown-based exit
- Disjoint admin and validator role sets
- Validator eligibility after 15 winning member-proposal points and admin nomination
- Admin/member binary proposals with `YES / NO` voting
- Admin/member slate rounds with deterministic first-in-order tie resolution
- Validator approval windows for member proposals
- Pause-aware community clock and safe archive conditions
- Protocol-wide maximum vote amount of 10,000 USDC

**Access Control**
- Admins manage local admins, validators, admin proposals, rounds, pause, archive, and Treasury requests
- Validators decide member-proposal validation cases
- Active members create member proposals and vote

**Dependencies**
- Paired `CommunityTreasury`
- `CommunityTypes` and `CommunityErrors`

**Asset Semantics**
The Hub never custodies USDC. It passes validated deposits and settlement instructions to Treasury. Vote amounts are native USDC units.

**Critical Invariants**
- An address cannot be both admin and validator
- A member cannot finalize exit with active proposal or vote obligations
- A proposal or round settles once
- Paused time does not consume governance deadlines
- Member bonds are slashed only on validator rejection, not a fair vote loss
