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
12. `scripts/deploy/deploy-v3.ts` - deploy BERT V3 Community Layer infrastructure
13. `scripts/deploy/configure-v3-funding-pool.ts` - connect an upgraded FundingPool to V3 Factory
14. `scripts/deploy/verify-v3.ts` - verify V3 infrastructure and FundingPool integration

**Docs**
1. `scripts/deploy/docs_deploy/DEPLOY.md` - deployment guide
2. `scripts/deploy/docs_deploy/V3_DEPLOY.md` - V3 deployment and V2 integration guide

**Notes**
1. Use `npx hardhat run` for all scripts
2. For Arc testnet, set `ARC_TESTNET_RPC_URL`, `DEPLOYER_KEY`, and `USDC_ADDRESS` in `.env`
