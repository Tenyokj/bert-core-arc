**USDC Migration Notes**

This note summarizes the protocol migration from the legacy BTK-centered economic model to the current USDC-native funding model for Arc-aligned deployment and review.

**What Changed**
1. The live treasury asset is now USDC, not BTK.
2. Proposal submission stake is now denominated in USDC units.
3. Voting weight is now the amount of committed USDC.
4. Grant payouts are now released in USDC.
5. Treasury accounting remains modular, but now tracks USDC-native balances end to end.

**What Did Not Change**
1. The core contract topology remains the same: `IdeaRegistryUpgradeable`, `VotingSystemUpgradeable`, `FundingPoolUpgradeable`, and `GrantManagerUpgradeable`.
2. Milestone-based payouts remain `30% / 40% / 30%`.
3. Role-based access control and pausability remain in place.
4. Proxy-based upgradeability remains the deployment model.

**Compatibility Strategy**
1. The protocol now exposes `FundingPoolUpgradeable.usdc()` as the canonical treasury asset getter.
2. Deprecated compatibility wrappers such as `governanceToken()` and `setGovernanceToken()` are retained in `FundingPoolUpgradeable` so older integrations can migrate incrementally.

**Decimals Change**
1. ERC-20 accounting for protocol USDC flows now assumes 6 decimals.
2. Default minimum stake values in `IdeaRegistryUpgradeable` and `VotingSystemUpgradeable` were updated accordingly.
3. Test infrastructure now uses a 6-decimal `MockUSDC`.
4. Integrations should not assume `18` decimals for deposit, approval, or voting amounts.

**Contract-Level Impact**
1. `FundingPoolUpgradeable` now stores `IERC20 public usdc`.
2. `IdeaRegistryUpgradeable` validates author balances and allowances against `fundingPool.usdc()`.
3. `VotingSystemUpgradeable` keeps the same round mechanics, but vote commitments are now USDC-denominated.
4. `GrantManagerUpgradeable` continues staged release logic on top of the USDC treasury flow already tracked by `FundingPoolUpgradeable`.

**Arc Alignment**
1. The deployment path is now prepared for Arc Testnet.
2. Hardhat network config includes `arcTestnet`.
3. `.env.example` includes `ARC_TESTNET_RPC_URL` and `USDC_ADDRESS`.
4. The documented Arc testnet USDC ERC-20 interface address is `0x3600000000000000000000000000000000000000`.

**Reviewer Checklist**
1. Confirm `FundingPoolUpgradeable.usdc()` points to the intended USDC contract.
2. Confirm proposal creation, voting, and grant claim succeed with 6-decimal USDC amounts.
3. Confirm `minStake` and `authorMinStake` are reviewed in USDC units, not legacy 18-decimal token units.
4. Arc deployments now assume a fresh proxy line, so historical `initializeV2` sequencing is no longer part of the live deployment path.
4. Confirm milestone payouts still execute exactly once per tranche.
5. Confirm only the configured USDC asset is wired into the deployed funding path.

**Scope Note**
This migration intentionally avoids a full rewrite of the protocol architecture. The goal is to preserve the existing audited-style module boundaries and milestone flow while replacing the economic asset layer with USDC for Arc-compatible stablecoin-native operation.
