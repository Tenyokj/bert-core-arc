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
- Vests V2.3 fees progressively with paid 20/40/40 tranches; legacy rounds finalize the whole fee at claim
- Distributes a net grant in authorized milestone tranches
- Opens defined refund paths for losing pledges, no-winner rounds, never-claimed winners, and expired live grants

**Refund Semantics**
- a losing pledger claims its full recorded pledge
- if no proposal is viable, every pledger claims its full recorded pledge
- if the selected author never claims, the full gross winning pledge, including the pending fee, is restored for refund
- a failed V2.3 live grant restores both unpaid net capital and unvested fee for winning-cohort pro-rata refunds; legacy live-grant expiry restores only remaining net capital

**Protocol Fee**
- default: `500` basis points, or `5%`
- maximum: `1,000` basis points, or `10%`
- snapshotted at round opening
- no reserve revenue before author claim; V2.3 moves only the fee matching each paid tranche into reserve

**Access Control**
- only `VotingSystemUpgradeable` may open, record, or settle funding rounds
- only the distributor-authorized grant manager may finalize fees, activate refunds, or distribute grant capital
- only the idea registry may lock, release, or slash author bonds through its permitted paths

**Upgradeability**
Upgradeable and pausable. Its accounting storage and storage gap must remain layout-compatible across proxy upgrades.
