# CommunityTreasury

**Summary**
Immutable USDC custody and accounting contract for one BERT V3 community.

**Role In System**
Receives membership stake, proposal bonds, binary vote escrow, and slate-round escrow. It settles them into execution funds, validator rewards, member refunds, or the global BERT reserve.

**Key Features**
- Separates membership lock, proposal bond lock, vote escrow, execution balance, validator rewards, and refund liability
- Splits Member-proposal capital between execution and validator reward buckets; Admin-proposal capital goes entirely to execution because no validator review occurred
- Stores pull-based NO-side refunds
- Finalizes validator reward epochs with equal active-validator claims and execution dust handling
- Routes global reserve flows through V2 `FundingPoolUpgradeable.receiveCommunityReserve`
- Uses local admin quorum for execution withdrawals

**Access Control**
- Only Factory may set the paired Hub once
- Only Hub may run governance deposits and settlements
- Only current Hub-recognized admins may create, approve, cancel, or execute withdrawals

**Critical Invariants**
- Treasury accounting must not spend membership lock, bond lock, or refund liability as execution funds
- A binary proposal or slate round settles once
- Validator rewards cannot be claimed twice
- A withdrawal reserves execution funds before quorum execution
