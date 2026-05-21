# Changelog

## v1.1.2

**Summary**
1. Migrated protocol economics from BTK-centered flows to USDC-native flows.
2. Added Arc-oriented deployment and environment configuration.
3. Updated treasury, voting, and proposal stake semantics to 6-decimal USDC units.

**What Changed**
1. `FundingPoolUpgradeable` now uses USDC as the canonical treasury asset.
2. `IdeaRegistryUpgradeable` validates author stake using the configured USDC asset.
3. `VotingSystemUpgradeable` uses committed USDC amount as voting weight.
4. Deployment scripts now accept a configured `USDC_ADDRESS`.
5. Test infrastructure now uses a 6-decimal `MockUSDC`.

**Compatibility Notes**
1. `FundingPoolUpgradeable.governanceToken()` remains as a deprecated compatibility getter.
2. `FundingPoolUpgradeable.setGovernanceToken()` remains as a deprecated compatibility setter.

## v1.1.0

**Summary**
1. Added author stake requirements for idea creation.
2. Added staged grant payouts with reviewer-approved milestones.
3. Added milestone rejection cooldown and resubmission flow.

**Protocol Changes**
1. `IdeaRegistryUpgradeable`
2. `FundingPoolUpgradeable`
3. `GrantManagerUpgradeable`
4. `IdeaStatus`

**What Changed**
1. Authors must stake at least `authorMinStake` when creating an idea.
2. Losing ideas have their locked author stake moved to `protocolReserve`.
3. Winning ideas release grant funds in tranches: `30%` initial, `40%` in-process, `30%` completion.
4. Milestone proof submissions are reviewed by addresses with `REVIEWER_ROLE`.
5. In-process payout needs `3` approvals out of at most `5` reviewer votes.
6. Completion payout needs `2` approvals out of at most `3` reviewer votes.
7. Rejected milestone requests can be resubmitted after `48 hours`.

## v1.0.0

**Summary**
1. Initial core release of the upgradeable proposal, voting, treasury, and grant coordination system.
