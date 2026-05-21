**Operations Guide**

**Day-2 Tasks**
1. Monitor pause status of core modules.
2. Track voting round health and outcomes.
3. Review grant and milestone release events.
4. Verify role assignments have not changed unexpectedly.
5. Monitor large USDC flows into and out of `FundingPoolUpgradeable`.

**Monitoring Suggestions**
1. Track `FundsDeposited`, `FundsDistributed`, `IdeaFundsReserved`, and milestone events.
2. Watch for unexpected role changes in `RolesRegistryUpgradeable`.
3. Record upgrade transactions and implementation addresses.
4. Monitor changes to `minStake`, `authorMinStake`, and `authorSharePercent`.

**Upgrade Operations**
1. Maintain a log of upgrades and tx hashes.
2. Rehearse upgrades on localhost and Arc testnet before production rollout.
3. Verify implementation addresses and proxy admin ownership after every upgrade.
4. Capture pre- and post-upgrade parameters for treasury-sensitive modules.

**Emergency Procedure**
1. Pause `FundingPoolUpgradeable`, `VotingSystemUpgradeable`, and `GrantManagerUpgradeable`.
2. Investigate and patch the issue.
3. Validate treasury and milestone state consistency.
4. Resume only after post-incident checks.

**Admin Rotation**
1. Transfer ProxyAdmin ownership if needed.
2. Update operational playbooks accordingly.
3. Validate access after rotation.
4. Re-verify system role wiring after rotation.
