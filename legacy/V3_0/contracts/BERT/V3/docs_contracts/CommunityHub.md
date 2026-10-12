# CommunityHub

**Summary**
Immutable per-community governance engine for local roles, membership, proposal validation, binary voting, slate rounds, and validator reward epochs.

**Role In System**
Owns community governance state and instructs its paired Treasury to move USDC only after valid lifecycle transitions.

**Key Features**
- Stake-gated member join and cooldown-based exit
- Mutually exclusive admin, validator, and member roles
- Per-community validator eligibility threshold of 1-100 winning member proposals, followed by admin nomination
- Admin/member binary proposals with `YES / NO` voting
- Admin/member slate rounds with deterministic first-in-order tie resolution
- Validator approval windows for member proposals
- Pause-aware community clock and safe archive conditions
- Protocol-wide maximum vote amount of 10,000 USDC
- Quorum-protected Admin and Validator roster changes

**Access Control**
- Admins create and approve protected actions, publish Admin proposals, create rounds, and manage Treasury requests
- Validators decide member-proposal validation cases
- Active members create member proposals and vote

**Protected Admin Actions**
- `createAdminActionRequest`, `approveAdminActionRequest`, and `executeAdminActionRequest` are the only paths for pause/resume, archive, Admin roster changes, Validator roster changes, and cancellation of a pending withdrawal request.
- The creator is recorded as the first approver. Execution requires the immutable `adminApprovalThreshold` stored on the Hub.
- Requests expire after seven days of active Community time; paused time is excluded.
- An Admin handover is intentionally two quorum-approved actions: add the replacement Admin, then remove the former Admin. There is no unilateral transfer function.

**Dependencies**
- Paired `CommunityTreasury`
- `CommunityTypes` and `CommunityErrors`

**Asset Semantics**
The Hub never custodies USDC. It passes validated deposits and settlement instructions to Treasury. Vote amounts are native USDC units.

**Critical Invariants**
- An address cannot hold more than one active Community state: admin, validator, or member
- Reaching the local proposal-point threshold makes a former member eligible; it never assigns Validator automatically
- A member cannot finalize exit with active proposal or vote obligations
- A proposal or round settles once
- Paused time does not consume governance deadlines
- A single Admin cannot add or remove an Admin or Validator without the immutable local Admin quorum
- Member bonds are slashed only on validator rejection, not a fair vote loss
- A proposal author cannot select their own proposal in binary voting or a Slate Round
