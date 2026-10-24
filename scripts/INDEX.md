**Scripts Index**

**Deployment**
1. `scripts/deploy/deploy-proxies.ts` - deploy full protocol with proxies
2. `scripts/deploy/deploy-pop-verifier.ts` - deploy only PoPVerifier proxy
3. `scripts/deploy/configure-voting-pop.ts` - bind VotingSystem to PoPVerifier and set caps
4. `scripts/deploy/upgrade-proxy.ts` - upgrade a single proxy
5. `scripts/deploy/preflight-v2-conditional-pledges.ts` - read-only snapshot before the BERT V2.2 conditional-pledge upgrade
6. `scripts/deploy/verify-v2-conditional-pledges.ts` - read-only post-upgrade validation before V2 is unpaused
7. `scripts/deploy/initialize-v2-conditional-pledges.ts` - executes the two BERT V2.2 direct protocol-admin initializers
8. `scripts/deploy/set-v2-maintenance-state.ts` - pauses or unpauses FundingPool, VotingSystem, and GrantManager
9. `scripts/deploy/configure-legacy-funding-proposal.ts` - lets a legacy proposal author set its BERT V2.2 minimum net target
10. `scripts/deploy/set-v2-ideas-per-round.ts` - updates V2 round size within the guarded 5..50 range
11. `scripts/deploy/verify-deploy.ts` - post-deploy checks (roles, pause status, params)
12. `legacy/V3_0/scripts/deploy/deploy-v3.ts` - archived BERT V3.0 Community Layer deployer
13. `scripts/deploy/deploy-v3-2.ts` - deploy isolated BERT V3.2 Community Layer infrastructure
14. `scripts/deploy/initialize-v3-factory-allowlist.ts` - seeds the additive Factory allowlist from the live V3.0 Factory after FundingPool upgrade
15. `scripts/deploy/configure-v3-2-funding-pool.ts` - additively allowlists the V3.2 Factory in V2 FundingPool
16. `legacy/V3_0/scripts/deploy/configure-v3-funding-pool.ts` - archived V3.0 FundingPool integration script
17. `legacy/V3_0/scripts/deploy/verify-v3.ts` - archived V3.0 verification script

**Local E2E**
1. `scripts/local/mint-v3-test-usdc.ts` - mint MockUSDC to local Hardhat test wallets only
2. `scripts/local/verify-v3-test-wallets.ts` - record local-only PoP attestations for Hardhat test wallets
3. `scripts/local/advance-time.ts` - advance the local Hardhat clock for deadline tests only
4. `docs/LOCAL-V3.1-E2E.md` - full V3.2 frontend and contract E2E runbook

**Docs**
1. `scripts/deploy/docs_deploy/DEPLOY.md` - deployment guide
2. `scripts/deploy/docs_deploy/V3_DEPLOY.md` - V3 deployment and V2 integration guide

**Notes**
1. Use `npx hardhat run` for all scripts
2. For Arc testnet, set `ARC_TESTNET_RPC_URL`, `DEPLOYER_KEY`, and `USDC_ADDRESS` in `.env`
