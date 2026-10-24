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
TRUSTED_SIGNER_ADDRESS=0x...
HUMAN_ONLY_VOTING=true
HUMAN_ONLY_IDEA_CREATION=true
MAX_VOTE_AMOUNT_USDC=10000
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
5. Optionally deploys and wires `PoPVerifierUpgradeable` when `TRUSTED_SIGNER_ADDRESS` is provided, then applies the configured verification gates to voting and idea creation.
6. Unpauses the live modules.

**Verification Checklist**
1. Confirm the reported USDC address matches the intended network.
2. Confirm `FundingPoolUpgradeable.usdc()` returns the expected address.
3. Confirm `VotingSystemUpgradeable.minStake()` and `IdeaRegistryUpgradeable.authorMinStake()` reflect 6-decimal USDC units and your intended treasury policy.
4. Confirm all system roles are assigned.
5. Confirm `FundingPoolUpgradeable`, `VotingSystemUpgradeable`, and `GrantManagerUpgradeable` are unpaused only after role wiring.
6. If PoP participation is enabled, confirm VotingSystem `humanVerifier`, `humanOnlyVoting`, `maxVoteAmount`; IdeaRegistry `humanVerifier`, `humanOnlyIdeaCreation`; and verifier `trustedSigner`.
7. Confirm `FundingPoolUpgradeable.pledgeFeeBps()` matches the intended policy and that `VotingSystemUpgradeable.IDEAS_PER_ROUND()` is between `5` and `50`.

## Archived V3.0 Community Deployment

The commands below applied to the previous V3.0 Community Layer. Its source,
scripts, tests, and full deployment guide now live under
[`legacy/V3_0`](../../../legacy/V3_0/). Do not use them to deploy the modular
current V3 implementation.

## Current Sources: Unreleased V3.2 Community Deployment

V3.2 deploys a new matching Factory/deployer bundle beside V3.1 and V3.0.
It does not upgrade existing immutable Communities. Follow the
[V3.2 rollout runbook](../../../docs/V3.2-QUORUM-ROLLOUT.md) and
[release scope](../../../docs/V3.2-RELEASE.md).

The additive FundingPool Factory allowlist was already deployed for V3.1.
For this V3.2 follow-up, do not rerun that initializer or upgrade V2 implementations.
Add the new Factory without removing old approvals. Record real addresses and
receipts before changing frontend env or publishing a new subgraph version.

```bash
POP_VERIFIER_ADDRESS=0x... \\
V3_PROXY_ADMIN_OWNER=0x... \\
npx hardhat run scripts/deploy/deploy-v3-2.ts --network arcTestnet

FUNDING_POOL_ADDRESS=0x... \\
V3_2_FACTORY_ADDRESS=0x... \\
npx hardhat run scripts/deploy/configure-v3-2-funding-pool.ts --network arcTestnet
```

Substitute the verified deployment addresses; these commands are templates, not
evidence that deployment occurred. Original V3.1 records remain in the
[historical release runbook](../../../docs/V3.1-ARC-TESTNET-RELEASE.md).
Old V3.1 deploy command names fail closed in the current V3.2 source tree.

V3.0 required the same deployed `PoPVerifierUpgradeable` used by V2:

```bash
export POP_VERIFIER_ADDRESS=0x...
npx hardhat run legacy/V3_0/scripts/deploy/deploy-v3.ts --network arcTestnet
```

V3.0 required a verified creator to reserve a Community and a verified wallet to lock entry stake and become a Member. This preserved read access and fund-recovery flows for already-existing users.

**Post-Deploy Console Checks**

```bash
npx hardhat console --network arcTestnet
```

```js
const { ethers } = await hre.network.connect();
const funding = await ethers.getContractAt("FundingPoolUpgradeable", "<funding_proxy>");
const voting = await ethers.getContractAt("VotingSystemUpgradeable", "<voting_proxy>");
const registry = await ethers.getContractAt("IdeaRegistryUpgradeable", "<idea_proxy>");
const verifier = await ethers.getContractAt("PoPVerifierUpgradeable", "<pop_proxy>");

await funding.usdc();
await voting.minStake();
await registry.authorMinStake();
await voting.humanOnlyVoting();
await voting.humanVerifier();
await voting.maxVoteAmount();
await funding.pledgeFeeBps();
await voting.IDEAS_PER_ROUND();
await verifier.trustedSigner();
```

**Production Readiness Checklist**
1. Use a multisig as `PROXY_ADMIN_OWNER`.
2. Lock the correct Arc testnet or production USDC address before deployment.
3. Rehearse deployment and upgrade flow off-production.
4. Archive proxy, implementation, and ProxyAdmin addresses.
5. Verify role assignments from chain state, not logs alone.
6. Test proposal creation with `minimumNetFunding`, verified-human voting, viable settlement, loser refund, no-winner refund, claim, milestone payout, and expiry refund with realistic USDC amounts before launch.
7. Confirm an unverified wallet cannot vote if `humanOnlyVoting` is enabled.

**Asset Note**
The Arc deployment path assumes a configured USDC-compatible ERC-20 asset and does not require any protocol-native governance token or faucet contract.
