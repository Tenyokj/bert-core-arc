**Getting Started**

**Requirements**
1. `node >= 22.10`
2. `npm`

**Install**
```bash
npm install
```

**Compile**
```bash
npx hardhat compile
```

**Run Tests**
```bash
npx hardhat test
```

**Local Development**
```bash
npx hardhat node
npx hardhat run scripts/deploy/deploy-proxies.ts --network localhost
```

For localhost, if `USDC_ADDRESS` is not set, the deploy script uses `MockUSDC`.

**Arc Testnet Setup**
1. Copy `.env.example` to `.env`
2. Set `ARC_TESTNET_RPC_URL`
3. Set `DEPLOYER_KEY`
4. Set `PROXY_ADMIN_OWNER`
5. Set `USDC_ADDRESS`

**Arc Testnet Deploy**
```bash
npx hardhat run scripts/deploy/deploy-proxies.ts --network arcTestnet
```

**Important Integration Note**
All protocol amounts in the live funding path should be treated as USDC 6-decimal units.
