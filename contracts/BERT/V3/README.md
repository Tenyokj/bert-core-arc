# BERT V3 Community Layer: V3.2.1

This directory contains the V3.2.1 Community Layer sources deployed on Arc Testnet on 25 October 2026. The original
testnet implementation is retained unchanged in `legacy/V3_0/`; it is not
imported by the current contracts and must not be used for a new deployment.

## Runtime layout

`community/CommunityFactory.sol` is the shared, upgradeable entry point. It
reserves a Community Treasury, records the immutable config hash, and activates
only a Hub deployed by the Community creator with that exact config.

`community/CommunityHub.sol` is intentionally thin. It owns the Community
clock, immutable configuration, and quorum-protected admin actions. It forwards
operations to the modules below rather than embedding their creation bytecode.

`community/CommunityTreasury.sol` remains the sole USDC custodian. It retains
V3.0 accounting and adds isolated execution-plan reserves and refund liabilities.

`modules/CommunityMembershipModule.sol` owns membership, role exclusivity,
PoP-gated entry, and exit obligations.

`modules/CommunityProposalModule.sol` owns all four proposal lanes and the
validator review epoch for Member proposals.

`modules/CommunityVotingModule.sol` owns binary/slate voting, winner snapshots,
and vote-exit locks. It starts a plan for every accepted Admin or Member winner.

`modules/CommunityWinnerSnapshot.sol` seals the exact winner-supporter cohort.

`modules/CommunityMilestoneManager.sol` runs 20/40/40 execution plans. Only
winning supporters review evidence; failed plans return unreleased USDC pro rata.

`modules/deployers/` are separate stateless deployment boundaries. Keeping their
creation bytecode outside the Hub prevents the EVM initcode-size failure that a
single monolithic CommunityHub would otherwise hit.

## V3.2 execution plan (Arc Testnet)

**Current deployment policy:** Manager 2.0.1 requires explicit Admin quorum before each
20/40/40 transfer. Settlement/review only opens a fixed seven-active-day payment
authorization. Missed payments fail the plan and refund its unpaid execution
budget. Original live Managers retain automatic payouts. See the
[quorum flow and API](../../../docs/V3.2-TRANCHE-QUORUM.md).

1. An Admin or validator-approved Member proposal wins binary or slate voting.
2. Only winning-supporter voting weight is snapshotted as the review electorate.
3. The Community Treasury reserves the winner budget. Admin quorum authorizes
   the first 20% transfer to the immutable execution recipient.
4. Each of two proofs has a Community-configured review window. Passing review
   authorizes the corresponding 40% for separate Admin-quorum payment. Proof
   deadlines advance only after actual transfers; completion requires final payment.
5. Review requires 40% of winner weight participating, at least `6,667 bps`
   (`66.67%`) of that participating weight approving, and at least `max(3, ceil(3% of the
   snapshot supporter addresses))` unique approving supporters.
6. A rejected proof may be corrected once after cooldown. A second rejection,
   proof timeout, or no-quorum after grace fails the plan and makes the unspent
   reserve refundable only to the winning-supporter cohort.

The V3.2 approval constant (unchanged from V3.1) is `6,667 / 10,000`, slightly above the exact `2 / 3`
comparison used by V2.3. Integrations must use the code's exact threshold and
rounding, not interchange the two formulas.

The Hub applies one Community clock to voting, proof, and review deadlines, so
pausing the Community pauses its governance lifecycle consistently.

**Current versus historical policy:** V3.2 Manager `2.0.1` explicitly excludes the
execution recipient from milestone review and review weight/count. Its financial
support remains in the sealed snapshot for fair refunds; the Manager stores a
separate original refund denominator. Original V3.1 Managers do not have this
fix. New V3.2 Communities use the patched Manager and explicit tranche quorum. Use a non-participating execution wallet for old pilots and see the
[current deployment record](../../../docs/V3.2.1-ARC-TESTNET-RELEASE.md).

## Contributor references

- [Contributor testing guide](../../../docs/TESTING.md)
- [Local V3.2 E2E runbook](../../../docs/LOCAL-V3.1-E2E.md)
- [Current Arc Testnet release record](../../../docs/V3.2.1-ARC-TESTNET-RELEASE.md)
- [V3.1 security review notes](../../../docs/SECURITY-REVIEW-V3.1.md)

V3.2.1 assigns a fixed correction deadline at first rejection and permits permissionless
expiry of abandoned correction cooldowns. Existing immutable V3.2.0 Managers retain
the earlier defect; changing Factory defaults does not upgrade their Communities.
