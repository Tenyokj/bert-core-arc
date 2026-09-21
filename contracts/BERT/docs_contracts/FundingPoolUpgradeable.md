# FundingPoolUpgradeable

**Summary**
USDC treasury and escrow layer for BERT V2. It holds author bonds and voter pledges, tracks conditional refund rights, finalizes successful-round fees, and executes authorized milestone payouts.

**Role In System**
The pool is the accounting source of truth for token movement. `VotingSystemUpgradeable` decides round outcomes, while `GrantManagerUpgradeable` authorizes grant lifecycle actions.

**Key Features**
- Accepts direct treasury deposits and author bonds
- Opens a ledger for each funding round and snapshots its `pledgeFeeBps`
- Records one pledge per voter per round with its selected idea
- Separates winning gross pledge, pending fee escrow, net grant capital, refundable pledges, and protocol reserve
- Finalizes the fee only after the winning author claims the grant
- Distributes a net grant in authorized milestone tranches
- Opens defined refund paths for losing pledges, no-winner rounds, never-claimed winners, and expired live grants

**Refund Semantics**
- a losing pledger claims its full recorded pledge
- if no proposal is viable, every pledger claims its full recorded pledge
- if the selected author never claims, the full gross winning pledge, including the pending fee, is restored for refund
- if a live grant expires, only its unspent net pledge is refunded pro rata to the winning pledge cohort

**Protocol Fee**
- default: `500` basis points, or `5%`
- maximum: `1,000` basis points, or `10%`
- snapshotted at round opening
- not reserve revenue until `GrantManagerUpgradeable.claimGrant` succeeds

**Access Control**
- only `VotingSystemUpgradeable` may open, record, or settle funding rounds
- only the distributor-authorized grant manager may finalize fees, activate refunds, or distribute grant capital
- only the idea registry may lock, release, or slash author bonds through its permitted paths

**Upgradeability**
Upgradeable and pausable. Its accounting storage and storage gap must remain layout-compatible across proxy upgrades.
