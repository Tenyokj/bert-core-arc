# BERT V3.1 Community Layer

This directory is the current, deployable V3.1 Community Layer. The original
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

## V3.1 execution plan

1. An Admin or validator-approved Member proposal wins binary or slate voting.
2. Only winning-supporter voting weight is snapshotted as the review electorate.
3. The Community Treasury reserves the winner budget and releases 20% to the
   immutable Community execution recipient.
4. Each of two proofs has a Community-configured review window. Passing review
   releases 40%, then the final 40%.
5. Review requires 40% of winner weight participating, two-thirds of that
   participating weight approving, and at least `max(3, ceil(3% of the
   snapshot supporter addresses))` unique approving supporters.
6. A rejected proof may be corrected once after cooldown. A second rejection,
   proof timeout, or no-quorum after grace fails the plan and makes the unspent
   reserve refundable only to the winning-supporter cohort.

The Hub applies one Community clock to voting, proof, and review deadlines, so
pausing the Community pauses its governance lifecycle consistently.

## Contributor references

- [Contributor testing guide](../../../docs/TESTING.md)
- [Local V3.1 E2E runbook](../../../docs/LOCAL-V3.1-E2E.md)
- [Arc Testnet release runbook](../../../docs/V3.1-ARC-TESTNET-RELEASE.md)
- [V3.1 security review notes](../../../docs/SECURITY-REVIEW-V3.1.md)
