# Changelog

This changelog tracks protocol-level evolution, not just developer notes. Each entry should describe what changed, why it changed, and what operators or integrators should care about.

## v1.1.0

### Summary
Introduced stake-backed proposal intake and staged milestone-based grant release.

### Modules Touched
- `IdeaRegistryUpgradeable`
- `FundingPoolUpgradeable`
- `GrantManagerUpgradeable`
- `IdeaStatus`

### Key Changes
1. Authors must lock a minimum stake to create an idea.
2. Losing or rejected ideas can have their locked author stake moved into protocol reserve.
3. Winning ideas no longer receive a blind one-step payout.
4. Grant release now follows:
   - `30%` initial claim
   - `40%` in-process milestone
   - `30%` completion milestone
5. Milestone proof submissions are reviewed by addresses with `REVIEWER_ROLE`.
6. Rejected milestone requests enforce cooldown-based resubmission.

### Behavioral Impact
- proposal creation became economically gated
- treasury accounting now tracks author stake as a distinct bucket
- milestone review became a required part of the full grant release path
- idea lifecycle expanded to include `Funded` and `InProcess` execution states

### Operator Impact
- role wiring for reviewers became more important
- deployment and upgrade validation now need to include milestone request reads
- reserve accounting matters more because rejected stake can accumulate there

### Documentation Impact
- architecture, treasury, security, and upgrades documentation all need to reflect staged release semantics

## v1.0.0

### Summary
Initial upgradeable core release of the BERT protocol.

### Modules Included
- `IdeaRegistryUpgradeable`
- `VotingSystemUpgradeable`
- `FundingPoolUpgradeable`
- `GrantManagerUpgradeable`
- `RolesRegistryUpgradeable`
- `ReputationSystemUpgradeable`
- `VoterProgressionUpgradeable`

### Key Features
1. idea creation and registry state
2. round-based voting
3. treasury accounting for vote capital
4. winner selection
5. one-step grant claim path
6. reputation and voter progression hooks
7. upgradeable contract deployment model

### Behavioral Impact
- established the baseline lifecycle:
  `Pending -> Voting -> WonVoting -> Rejected / Funded`
- established the role and dependency model used by later versions

## Changelog Discipline

Future entries should include:
- summary
- modules touched
- key changes
- behavioral impact
- operator impact
- storage or upgrade impact

This file should be updated whenever protocol behavior, trust assumptions, state layout, or operator obligations change.


## 2026-07-20 Security Hardening Notes

This upgrade batch is intended to preserve storage layout while reducing
cross-contract reentrancy exposure in existing flows.

Modules touched:
- `IdeaRegistryUpgradeable`
- `VotingSystemUpgradeable`
- `GrantManagerUpgradeable`
- `VoterProgressionUpgradeable`

Behavioral changes:
- `GrantManagerUpgradeable.claimGrant` now records payout state before external
  funding pool and registry calls.
- `VotingSystemUpgradeable.vote` now records the local vote before calling into
  the funding pool and registry.
- `IdeaRegistryUpgradeable._createIdea` now reserves the new idea id and stores
  the draft idea before external reputation and funding calls.
- `IdeaRegistryUpgradeable.updateStatus` now writes the new lifecycle status
  before invoking rejected-stake slashing.
- `VoterProgressionUpgradeable` now flips local grant tracking flags before role
  registry grant/revoke calls.

Storage impact:
- none
- no state variables added
- no storage gaps changed
- no inheritance order changed

Operational guidance:
- upgrade implementations behind the existing proxies
- re-run the full create/vote/end/claim/milestone smoke flow after upgrade
- verify role wiring and dependency addresses remain unchanged
