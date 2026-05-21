**Security Overview**

The protocol is designed around upgrade-safe modules, strict role boundaries, and controlled USDC accounting.

**Primary Controls**
1. `SafeERC20` is used for treasury transfers.
2. `ReentrancyGuardUpgradeable` protects critical asset-moving flows.
3. `PausableUpgradeable` is enabled on `FundingPoolUpgradeable`, `VotingSystemUpgradeable`, and `GrantManagerUpgradeable`.
4. Role checks isolate proposal, voting, treasury, and grant operations.
5. Milestone review state prevents duplicate review and duplicate release.

**Treasury Protection**
1. `FundingPoolUpgradeable` tracks total pool balance separately from protocol reserve.
2. Proposal-level balances are tracked by `roundId => ideaId`.
3. Author submission stake is tracked independently in `authorStakeByIdea`.
4. Reserve movements are explicit and evented.
5. There is no arbitrary admin withdraw path for user-committed treasury capital.

**Milestone Protection**
1. `GrantManagerUpgradeable` stores payout state per round.
2. Each tranche has one-time execution flags.
3. Milestone requests are versioned by `requestId`.
4. Reviewer votes are keyed by `(roundId, stage, requestId, reviewer)`.
5. Rejected milestone requests are subject to cooldown before resubmission.

**Upgrade Safety**
1. Proxy-based modules keep storage layouts stable across versions.
2. New storage is appended, not inserted.
3. Compatibility wrappers like `governanceToken()` are retained where useful during migration, while the live treasury asset is USDC.

**Operational Guidance**
1. Use a multisig for admin and ProxyAdmin control in production.
2. Rehearse every upgrade on a non-production network before execution.
3. Verify role wiring immediately after deployment.
4. Monitor `FundsDeposited`, `FundsDistributed`, `IdeaFundsReserved`, and milestone events.
5. Pause funding, voting, and grant modules before investigating critical incidents.

**Arc-Specific Notes**
1. Arc uses USDC as the native gas asset on testnet.
2. Arc’s ERC-20 USDC interface uses 6 decimals for token operations, which the protocol now treats as the canonical accounting precision.
3. Integration code should avoid 18-decimal assumptions for ERC-20 USDC allowances, deposits, or voting amounts.
