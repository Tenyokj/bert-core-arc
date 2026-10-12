# BERT V3 Deployment

## Purpose

Deploy BERT V3 Community Layer infrastructure first. The V3 Factory is independent from V2 until the existing FundingPool proxy is upgraded and configured with the Factory address.

## Required environment

```env
ARC_TESTNET_RPC_URL=https://...
DEPLOYER_KEY=...
V3_PROXY_ADMIN_OWNER=0x...
FUNDING_POOL_ADDRESS=0x...
POP_VERIFIER_ADDRESS=0x...
```

`V3_PROXY_ADMIN_OWNER` is optional. If omitted, `PROXY_ADMIN_OWNER` is used; if that is also omitted, the deployer owns the new Factory ProxyAdmin.

`POP_VERIFIER_ADDRESS` is required. It must be the existing shared `PoPVerifierUpgradeable` proxy used by BERT V2. Factory requires proof-of-personhood from each Community creator, and each Treasury requires it before an account can lock entry stake and become a Member.

## 1. Deploy V3 infrastructure

```bash
npx hardhat run scripts/deploy/deploy-v3.ts --network arcTestnet
```

Copy the printed values into `.env`:

```env
V3_TREASURY_DEPLOYER_ADDRESS=0x...
V3_FACTORY_ADDRESS=0x...
V3_FACTORY_IMPLEMENTATION_ADDRESS=0x...
V3_FACTORY_PROXY_ADMIN_ADDRESS=0x...
POP_VERIFIER_ADDRESS=0x...
```

Verify the new infrastructure before touching V2:

```bash
npx hardhat run scripts/deploy/verify-v3.ts --network arcTestnet
```

## 2. Upgrade V2 FundingPool

Use the existing generic upgrade script. Do not call `initialize` again and do not use `upgradeAndCall` for `setCommunityFactory`.

```bash
npx hardhat run scripts/deploy/upgrade-proxy.ts --network arcTestnet -- \
  --proxy "$FUNDING_POOL_ADDRESS" \
  --impl FundingPoolUpgradeable
```

The wallet must own that proxy's existing `ProxyAdmin`. Before broadcasting, record `usdc`, `ideaRegistry`, `totalPoolBalance`, and `protocolReserve`; after the upgrade, confirm they are unchanged. `communityFactory` is a newly appended storage slot and should initially read as the zero address.

## 3. Configure V2-to-V3 reserve routing

The caller must hold the V2 admin role for FundingPool:

```bash
npx hardhat run scripts/deploy/configure-v3-funding-pool.ts --network arcTestnet
npx hardhat run scripts/deploy/verify-v3.ts --network arcTestnet
```

## 4. Create communities

For every community, its creator calls `CommunityFactory.createCommunity(config)`, deploys `CommunityHub` with exactly the same config and returned Treasury, then calls `activateCommunity`. These are separate community-specific transactions; they are intentionally not part of infrastructure deployment.

The creator must first be verified through the shared PoP flow. Community membership is likewise verified when entry stake is deposited. Refunds, claims, exits, and read-only calls remain available without adding a second PoP gate.
