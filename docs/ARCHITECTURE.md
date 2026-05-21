**Architecture Overview**

BERT is a stablecoin-native capital allocation system centered on USDC treasury flow, proposal accounting, and milestone-based grant release.

**Core Flow**
1. A builder submits an idea in `IdeaRegistryUpgradeable` and locks the required USDC stake.
2. `VotingSystemUpgradeable` opens a round and accepts USDC-denominated vote commitments.
3. `FundingPoolUpgradeable` records round-level and proposal-level capital.
4. The winning idea is selected after the round ends.
5. `GrantManagerUpgradeable` releases the grant in milestone-based tranches.

**Capital Flow**
```text
Builder
  |
  | createIdea + author stake
  v
IdeaRegistryUpgradeable
  |
  v
FundingPoolUpgradeable
  ^
  | vote(commit USDC)
VotingSystemUpgradeable
  |
  | winner
  v
GrantManagerUpgradeable
  |
  | 30% -> 40% -> 30%
  v
Winning builder
```

**Modules**
1. `IdeaRegistryUpgradeable` is the source of truth for proposal metadata and lifecycle state.
2. `VotingSystemUpgradeable` stores round state, vote totals, and winner resolution.
3. `FundingPoolUpgradeable` stores the USDC treasury balance, reserve balance, author stake locks, and per-round per-idea accounting.
4. `GrantManagerUpgradeable` coordinates grant claims, milestone proof review, and tranche release.
5. `RolesRegistryUpgradeable` defines the protocol’s role authority.

**Treasury Model**
1. The treasury asset is USDC.
2. Vote weight equals committed USDC amount.
3. Capital is tracked per round and per proposal.
4. Protocol reserve is tracked separately from distributable balances.
5. Author submission stake is tracked separately from round voting capital.

**Milestone Release Model**
1. Initial grant claim releases `30%`.
2. In-process milestone approval releases `40%`.
3. Completion milestone approval releases the final `30%`.
4. Reviewer vote tracking prevents duplicate reviews.
5. Payout flags prevent duplicate tranche release.

**Upgradeability**
1. Core modules are proxy-based.
2. Storage additions are appended, not reordered.
3. USDC migration keeps the protocol modular by preserving ERC-20 based accounting rather than rewriting round logic.

**Arc Fit**
1. Arc provides a stablecoin-native execution environment.
2. USDC settlement and fee alignment make it a natural home for onchain treasury coordination.
3. BERT uses Arc as settlement infrastructure for programmable grant capital, not as a speculative governance venue.
