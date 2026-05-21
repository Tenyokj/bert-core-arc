**Deploy BERT On Arc**

This repo now deploys BERT as USDC-native funding infrastructure. The deploy script expects an ERC-20 compatible USDC address and uses a local `MockUSDC` fallback only for local/dev environments.

**Arc Testnet Reference**
1. Network: `Arc Testnet`
2. Chain ID: `5042002`
3. RPC: `https://rpc.testnet.arc.network`
4. Explorer: `https://testnet.arcscan.app`
5. Testnet USDC ERC-20 interface: `0x3600000000000000000000000000000000000000`

These values were verified against Arc and Circle documentation in May 2026.

**Environment**

Create `.env` from `.env.example`:

```bash
cp .env.example .env
```

Minimum variables for Arc testnet:

```bash
ARC_TESTNET_RPC_URL=https://rpc.testnet.arc.network
DEPLOYER_KEY=0x...
PROXY_ADMIN_OWNER=0x...
USDC_ADDRESS=0x3600000000000000000000000000000000000000
```

**Local Deployment**

```bash
npx hardhat node
npx hardhat run scripts/deploy/deploy-proxies.ts --network localhost
```

If `USDC_ADDRESS` is omitted locally, the script deploys `MockUSDC` automatically.

**Arc Testnet Deployment**

```bash
npx hardhat run scripts/deploy/deploy-proxies.ts --network arcTestnet
```

The script:
1. Deploys proxy-based core contracts.
2. Uses the configured USDC address for `FundingPoolUpgradeable`.
3. Grants protocol roles.
4. Wires `IdeaRegistryUpgradeable` to `FundingPoolUpgradeable`.
5. Unpauses the live modules.

**Verification Checklist**
1. Confirm the reported USDC address matches the intended network.
2. Confirm `FundingPoolUpgradeable.usdc()` returns the expected address.
3. Confirm `VotingSystemUpgradeable.minStake()` and `IdeaRegistryUpgradeable.authorMinStake()` reflect 6-decimal USDC units and your intended treasury policy.
4. Confirm all system roles are assigned.
5. Confirm `FundingPoolUpgradeable`, `VotingSystemUpgradeable`, and `GrantManagerUpgradeable` are unpaused only after role wiring.

**Post-Deploy Console Checks**

```bash
npx hardhat console --network arcTestnet
```

```js
const { ethers } = await hre.network.connect();
const funding = await ethers.getContractAt("FundingPoolUpgradeable", "<funding_proxy>");
const voting = await ethers.getContractAt("VotingSystemUpgradeable", "<voting_proxy>");
const registry = await ethers.getContractAt("IdeaRegistryUpgradeable", "<idea_proxy>");

await funding.usdc();
await voting.minStake();
await registry.authorMinStake();
```

**Production Readiness Checklist**
1. Use a multisig as `PROXY_ADMIN_OWNER`.
2. Lock the correct Arc testnet or production USDC address before deployment.
3. Rehearse deployment and upgrade flow off-production.
4. Archive proxy, implementation, and ProxyAdmin addresses.
5. Verify role assignments from chain state, not logs alone.
6. Test proposal creation, voting, claim, and milestone payout with realistic USDC amounts before launch.

**Asset Note**
The Arc deployment path assumes a configured USDC-compatible ERC-20 asset and does not require any protocol-native governance token or faucet contract.
