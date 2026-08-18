**Scripts Index**

**Deployment**
1. `scripts/deploy/deploy-proxies.ts` - deploy full protocol with proxies
2. `scripts/deploy/deploy-pop-verifier.ts` - deploy only PoPVerifier proxy
3. `scripts/deploy/configure-voting-pop.ts` - bind VotingSystem to PoPVerifier and set caps
4. `scripts/deploy/upgrade-proxy.ts` - upgrade a single proxy
5. `scripts/deploy/verify-deploy.ts` - post-deploy checks (roles, pause status, params)

**Docs**
1. `scripts/deploy/docs_deploy/DEPLOY.md` - deployment guide

**Notes**
1. Use `npx hardhat run` for all scripts
2. For Arc testnet, set `ARC_TESTNET_RPC_URL`, `DEPLOYER_KEY`, and `USDC_ADDRESS` in `.env`
