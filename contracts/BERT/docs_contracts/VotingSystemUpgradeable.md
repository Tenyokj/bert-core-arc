# VotingSystemUpgradeable

**Summary**
Core BERT V2 round engine. It batches pending proposals, records USDC-weighted pledges, and selects the highest-supported proposal that is viable after the round's locked fee.

**Role In System**
The contract owns round composition, timing, vote totals, and outcome. `FundingPoolUpgradeable` owns the associated pledge escrow and refund accounting.

**Key Features**
- Starts contiguous funding rounds from the pending proposal queue
- Records one USDC pledge per wallet per round
- Enforces `minStake`, optional verified-human gating, and an optional per-wallet vote cap
- Selects the highest-vote proposal whose post-fee funding meets its own `minimumNetFunding`
- Produces a no-winner outcome when no proposal is viable
- Updates proposal status and triggers reputation/progression effects at settlement

**Economic Semantics**
- vote weight equals the pledged USDC amount
- a pledge is bound to the selected idea and cannot be redirected to a different winner
- losing pledges are refundable by their original voters
- each round snapshots the current fee in `FundingPoolUpgradeable`, so later fee changes do not rewrite an active round

**Safety Bounds**
- `IDEAS_PER_ROUND` is constrained to `5..50`; default policy is `30`
- `MAX_VOTERS_PER_IDEA` is `30`, bounding the progression loop during settlement

**Dependencies**
- `FundingPoolUpgradeable` for pledge ledger opening, recording, and settlement
- `IdeaRegistryUpgradeable` for proposal data, funding targets, and lifecycle updates
- `ReputationSystemUpgradeable` and `VoterProgressionUpgradeable` for outcome effects
- `RolesRegistryUpgradeable` for access control

**Upgradeability**
Upgradeable and pausable. New state must be appended after existing voting storage.
