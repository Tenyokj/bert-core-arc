**Protocol Configuration**

**Core Parameters**
1. `IDEAS_PER_ROUND` in `VotingSystemUpgradeable`
2. `VOTING_DURATION` in `VotingSystemUpgradeable`
3. `minStake` in `VotingSystemUpgradeable`
4. `authorMinStake` in `IdeaRegistryUpgradeable`
5. `authorSharePercent` in `GrantManagerUpgradeable`

**USDC Unit Notes**
1. `minStake` and `authorMinStake` are now denominated in 6-decimal USDC units.
2. Example: `10 USDC = 10 * 10**6`.
3. Integrations should use `parseUnits(value, 6)`, not `parseEther`.

**Parameter Effects**
1. Higher `IDEAS_PER_ROUND` increases round size but raises end-of-round gas usage.
2. Longer `VOTING_DURATION` slows funding cadence but gives more review time.
3. Higher `minStake` reduces spam voting but increases voter capital commitment.
4. Higher `authorMinStake` reduces proposal spam but raises builder entry cost.
5. Higher `authorSharePercent` increases builder payout and lowers protocol reserve intake.

**Deployment Configuration**
1. `ARC_TESTNET_RPC_URL`
2. `DEPLOYER_KEY`
3. `PROXY_ADMIN_OWNER`
4. `USDC_ADDRESS`

**Recommended Defaults**
1. `IDEAS_PER_ROUND = 30`
2. `VOTING_DURATION = 1 day`
3. `minStake = 10 * 10**6`
4. `authorMinStake = 50 * 10**6`
5. Deployment overrides: `VOTE_MIN_STAKE_USDC=10`, `AUTHOR_MIN_STAKE_USDC=50`
5. `authorSharePercent = 95`

**Operational Guidance**
1. Test parameter changes on a non-production network before rollout.
2. Re-run deployment verification after changing any treasury or stake parameter.
3. Record the active USDC address per environment.
