**Scripts Index**

**Deployment**
1. `scripts/deploy/deploy-proxies.ts` - deploy full protocol with proxies
2. `scripts/deploy/deploy-pop-verifier.ts` - deploy only PoPVerifier proxy
3. `scripts/deploy/configure-voting-pop.ts` - bind VotingSystem to PoPVerifier and set caps
4. `scripts/deploy/upgrade-proxy.ts` - upgrade a single proxy
5. `scripts/deploy/verify-deploy.ts` - post-deploy checks (roles, pause status, params)
6. `scripts/deploy/deploy-v3.ts` - deploy BERT V3 Community Layer infrastructure
7. `scripts/deploy/configure-v3-funding-pool.ts` - connect an upgraded FundingPool to V3 Factory
8. `scripts/deploy/verify-v3.ts` - verify V3 infrastructure and FundingPool integration

**Docs**
1. `scripts/deploy/docs_deploy/DEPLOY.md` - deployment guide
2. `scripts/deploy/docs_deploy/V3_DEPLOY.md` - V3 deployment and V2 integration guide

**Notes**
1. Use `npx hardhat run` for all scripts
2. For Arc testnet, set `ARC_TESTNET_RPC_URL`, `DEPLOYER_KEY`, and `USDC_ADDRESS` in `.env`
