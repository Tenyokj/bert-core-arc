# BERT V3 Manual Testing Checklist

This checklist is the single manual acceptance plan for the Community Layer. It complements the automated Core suite; it does not replace it.

## Test Setup

Use a fresh, activated Community after a `CommunityHub` bytecode or config-schema change. For localhost, mint the current `MockUSDC` to all test wallets before joining or voting.

Create one primary Community with these local parameters:

| Parameter | Test value |
| --- | --- |
| Initial admins | Admin A, Admin B |
| Initial validators | Validator 1, Validator 2, Validator 3 |
| Validator approvals | 2 of 3 |
| Validator proposal points | 2 |
| Entry stake | 10 USDC |
| Member proposal bond | 50 USDC |
| Minimum vote | 10 USDC |
| Exit cooldown | 5 minutes |
| Validation, binary and slate duration | 5 minutes each |
| Validator reward epoch | 5 minutes |
| Validator activity threshold | 6,000 bps (60%) |
| Validator reward share | 1,500 bps (15%) |
| Binary NO fee | 300 bps (3%) |
| Admin withdrawal quorum | 2 of 2 |

Use three non-role wallets: Member 1 (proposal author), Member 2 (independent voter), and Member 3 (independent slate voter). Do not make a test wallet both a member and an admin or validator.

## 1. Deployment And Discovery

- [ ] `Reserve Treasury` creates a pending Factory record and the displayed Community ID and Treasury address match the transaction.
- [ ] `Deploy Hub` deploys the exact config selected in the creator form.
- [ ] `Activate` succeeds only from the creator wallet and the Community opens from the success link.
- [ ] The Community page shows its name, Hub, Treasury, metadata link, active status and proposal count.
- [ ] The Community appears in `/v3/communities`, `/v3/search`, and the creator's `/v3/profile`.
- [ ] A URL metadata value opens as a link; a non-URL metadata value remains visible as raw text.
- [ ] Create a second Community with a different `validatorProposalPointsThreshold` and verify that each Hub exposes its own immutable value.
- [ ] Creator form rejects duplicate addresses, admin-validator overlap, zero/invalid values, a validator or admin quorum higher than the supplied role-holder count, and points threshold above `100`.

Automated coverage also verifies Factory implementation locking, creator-only activation, configuration-hash matching, community indexing and V2 reserve authentication.

## 2. Roles And Access

- [ ] Admin sees `Admin Panel`; Member and Validator do not see it as an active navigation action.
- [ ] Validator sees `Validator Queue`; a Member does not gain validator actions.
- [ ] A non-member sees read-only Community information and the join flow, but cannot vote or submit a member proposal.
- [ ] An Admin cannot join as a Member.
- [ ] A Validator cannot join as a Member.
- [ ] An active Member cannot be added as Admin or Validator.
- [ ] An inactive former Member below the points threshold cannot be nominated as Validator.
- [ ] A former Member at the local points threshold can be nominated by an Admin only when no validation case is pending.
- [ ] The nomination UI reports points, membership status, role conflicts and validator-set locks before enabling its transaction.

## 3. Membership And Entry Stake

- [ ] Member approves exactly the entry stake and joins successfully.
- [ ] Wallet USDC falls by the entry stake and Treasury `Membership locked` increases by the same amount.
- [ ] A duplicate join is rejected with a clear error.
- [ ] The Membership panel displays the on-chain stake, points and current exit state.
- [ ] `Request membership exit` starts the cooldown but does not return USDC yet.
- [ ] The panel countdown follows Community active time, not wall-clock time during a pause.
- [ ] Before cooldown expiry, `Return USDC` remains disabled.
- [ ] After cooldown and with zero blockers, `Return X USDC` returns the full entry stake exactly once.
- [ ] A pending member proposal blocks exit.
- [ ] A binary or slate vote lock blocks exit until its proposal or round is settled and the voter calls `Clear settled vote lock`.
- [ ] An archived clean Community permits the remaining Member to request and finalize exit without waiting the normal cooldown.

## 4. Admin Binary Proposal

- [ ] Admin creates an admin binary proposal; it starts in the expected pre-voting state.
- [ ] Only an Admin can open the binary voting window.
- [ ] An active Member can approve USDC and cast one YES or NO vote at or above the configured minimum.
- [ ] Below-minimum stake, a stake above `10,000 USDC`, a duplicate vote and a closed-window vote are rejected with useful UI errors.
- [ ] A proposer cannot vote for their own binary proposal. Admins cannot bypass this by joining because Community roles are exclusive.
- [ ] A YES win routes YES stake into Community execution and validator-reward balances and routes all NO stake to the V2 global reserve.
- [ ] A NO win or tie makes only NO voters eligible for a refund of their own stake minus the configured fee.
- [ ] The NO refund button appears only for the actual NO voter, sends the expected amount once, then changes to an already-claimed state.
- [ ] YES voters cannot claim a NO refund.
- [ ] A settled voter clears their vote lock and can then complete exit if no other blocker exists.

## 5. Member Binary Proposal And Validation

- [ ] A Member approves the configured 50 USDC-equivalent proposal bond and submits a member binary proposal.
- [ ] The proposal appears in Validator Queue with title, description, metadata reference, creator, bond, approval count and deadline.
- [ ] A Validator can approve or reject once only; the same validator cannot decide twice.
- [ ] Two approvals immediately move the proposal to `ApprovedForVoting`; an Admin can then open binary voting.
- [ ] Enough rejections to make approval impossible immediately reject the proposal and slash its bond to V2 reserve.
- [ ] An undecided proposal can be finalized after its validation deadline; it is approved only when it reached the configured approval threshold, otherwise its bond is slashed.
- [ ] The author cannot vote for their own member binary proposal.
- [ ] On either settled binary outcome after successful validation, the member proposal bond returns once to the author.
- [ ] A YES win awards one proposal point to the author; a NO result does not.

## 6. Slate Proposals And Slate Rounds

- [ ] Admin creates one or more admin slate proposals, which appear as eligible only in the Admin Slate selection.
- [ ] Member slate proposals require the same validator review and bond flow as member binary proposals.
- [ ] Admin Panel excludes proposal IDs that have the wrong origin, wrong mode, wrong status or an assigned round.
- [ ] Creating an empty Slate Round, a round with duplicate proposals, or a round over 30 proposals is rejected.
- [ ] Admin creates separate Admin and Member Slate Rounds only from their respective approved candidates.
- [ ] A Member casts exactly one vote in a round and cannot vote again or vote after the deadline.
- [ ] A proposal author cannot select their own member slate proposal. They may select another candidate in the same round.
- [ ] Stake below the configured minimum and stake above `10,000 USDC` are rejected for slate voting too.
- [ ] A tie selects the first proposal in the submitted round order.
- [ ] Settlement assigns winner and losing statuses correctly and routes all round stake locally: execution plus validator rewards, never a NO refund or global-reserve route.
- [ ] Member slate proposal bonds return after a fairly settled round and the winning author receives exactly one point.
- [ ] Each voter clears their settled round vote lock before exiting.

## 7. Validator Reward Epochs

- [ ] Validator Queue counts every validation case in its proposal's original reward epoch.
- [ ] With a 60% activity threshold, verify rounding: one available case requires one completed case; three cases require two.
- [ ] An active validator sees the finalized epoch's equal per-validator reward and can claim it once.
- [ ] An inactive validator sees no eligible claim and the claim transaction is rejected.
- [ ] Reward amounts from a winning member proposal are attributed to the validation epoch, not accidentally to a later epoch.
- [ ] Historical finalized epochs remain selectable and claimable after new epochs begin.
- [ ] Finalizing an epoch is available only after `epoch end + validation window` in Community time.
- [ ] An empty epoch finalizes cleanly and creates no claimable reward.
- [ ] If a reward epoch has no active validators, its reward returns to execution balance.
- [ ] Pausing blocks epoch finalization because Community time is frozen, but a previously finalized eligible reward remains claimable.

## 8. Treasury And Admin Quorum

- [ ] Treasury panel distinguishes execution funds, validator rewards, membership locks, bonds and refund liability. These values must not be treated as one withdrawable balance.
- [ ] An Admin can create a withdrawal request only up to available execution balance; its own approval is counted automatically and the amount becomes reserved.
- [ ] In the 2-of-2 Community, one approval does not enable execution.
- [ ] The second Admin can approve once; duplicate approval is rejected.
- [ ] Once quorum is reached, any Admin can execute and the recipient wallet receives the exact USDC amount.
- [ ] Executed and cancelled requests cannot be approved, cancelled or executed again.
- [ ] Cancelling a pending request releases its reserved execution balance.
- [ ] A second cancellation request for the same pending withdrawal is rejected until the first cancellation action executes or expires.
- [ ] Pause blocks withdrawal creation, approval and execution, but cancellation remains available to release a reservation.
- [ ] A V3 reserve inflow is reflected by the V2 `FundingPoolUpgradeable` reserve accounting, not merely by a token transfer.

## 9. Pause And Archive

- [ ] Pause blocks Community joining, membership exit requests/finalization, proposal creation, opening/voting/settlement, slate creation/voting/settlement, validator decisions, reward finalization and Treasury fund movement.
- [ ] Pause does not erase state. After resume, each deadline has only its remaining active time left.
- [ ] Member and Validator wallets cannot create, approve or execute a protected Admin action.
- [ ] In a 2-of-2 Community, one Admin cannot add/remove an Admin or Validator, pause/resume, archive or cancel a pending withdrawal request without the second approval.
- [ ] A protected Admin-action request expires after seven active Community days; pause time does not consume that lifetime.
- [ ] Archive is rejected while validation, binary voting, slate voting or unresolved member proposals remain.
- [ ] After a clean archive, new governance activity and membership joins are unavailable; outstanding membership stake can still unwind.

## 10. UI And Cross-Wallet Checks

- [ ] Test each important route while disconnected, connected as Admin, Validator, Member and non-member.
- [ ] Confirm every transaction shows pending, success and human-readable failure state; raw RPC errors belong only in optional technical detail.
- [ ] Test the V3 directory, search, profile, Community workspace, proposal details and round details after browser refresh.
- [ ] Confirm proposal and round cards respect Admin/Member filters and binary proposal pagination stops at 12 cards per page.
- [ ] Check Community metadata and proposal metadata on `https`, `http`, `ipfs`, blank and plain-text values.
- [ ] Test desktop and narrow mobile layouts, especially sidebar navigation, Treasury requests, creator address chips and Membership Exit panel.

## UI Surface Still Missing

The following Core functions are tested in Solidity but are not currently exposed as dApp controls. They should not be marked as manually tested through the UI until an explicit UI is added:

| Core action | Current frontend state |
| --- | --- |
| `finalizeMemberProposalValidation` after validation expiry | Missing action button on a pending proposal/validator queue |
| `renounceValidatorRole` | Missing role-management control |
| `rollValidatorRewardEpoch` | No direct control; ordinary proposal and settlement flows roll expired epochs automatically |

## Automated Regression Commands

Run these before a release or a Core/frontend handoff:

```bash
cd ~/bert/bert-core
npx hardhat test
npx hardhat test --coverage

cd ~/bert/bert_orig/bert-frontend
npm run lint
npm run build
```

Run Slither from the Core repository only after installing and configuring its compiler environment. Review high and medium findings before release; do not blindly suppress them.
