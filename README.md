![Bert v1.1.x](https://img.shields.io/badge/Bert-USDC--native-0F766E)
![License: GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-green)
![Hardhat](https://img.shields.io/badge/Hardhat-3.x-yellow)
![Solidity](https://img.shields.io/badge/Solidity-^0.8.20-orange)
![Arc](https://img.shields.io/badge/Arc-Testnet-1D4ED8)

![LOGO](/docs/assets/banner.png)

# BERT

BERT is programmable stablecoin-native funding infrastructure for transparent grant allocation, treasury coordination, and milestone-based capital release.

The protocol keeps proposal intake, voting rounds, treasury accounting, and staged grant distribution onchain. Economic flows are USDC-native: proposal deposits, vote commitments, treasury balances, reserve accounting, and grant payouts all settle in USDC-compatible units.

## Problem

Traditional grant programs are often opaque, manual, slow to execute, and difficult to audit. Treasury coordination is fragmented across forms, spreadsheets, chat approvals, and offchain payout operations.

## Solution

BERT turns grant allocation into programmable treasury flow:

1. Builders create proposals with a stake-backed submission flow.
2. Participants commit USDC voting weight during funding rounds.
3. The treasury records round-level and proposal-level capital onchain.
4. Winning proposals receive milestone-based USDC releases.
5. Reviewers validate progress before later tranches unlock.

## Why Arc

BERT is designed for Arc’s stablecoin settlement infrastructure.

Arc is not presented here as “just another EVM” or a “cheap chain”. The fit is that Arc is a stablecoin-native execution environment where USDC is central to settlement and fees. That makes it a strong home for treasury coordination, grant disbursement, and programmable capital allocation workflows.

For the current Arc testnet references used in this repo:

1. Arc Testnet chain ID is `5042002`.
2. Public RPC is `https://rpc.testnet.arc.network`.
3. Testnet USDC ERC-20 interface address is `0x3600000000000000000000000000000000000000`.

Sources:
1. Arc docs: `Connect to Arc`
2. Arc docs: `Contract addresses`
3. Circle docs: `USDC Contract Addresses`

## Funding Flow

```text
Builder creates proposal
        |
        v
Proposal stake is locked in USDC
        |
        v
Participants commit USDC votes
        |
        v
FundingPool accumulates round capital
        |
        v
Winning proposal is selected
        |
        v
GrantManager releases 30% / 40% / 30%
        |
        v
Each later tranche requires milestone approval
```

## Core Modules

1. `IdeaRegistryUpgradeable` stores proposals, metadata, author stake requirements, and lifecycle state.
2. `VotingSystemUpgradeable` manages voting rounds and USDC-denominated vote commitments.
3. `FundingPoolUpgradeable` is the USDC treasury and accounting layer.
4. `GrantManagerUpgradeable` coordinates claim flow and milestone-based releases.
5. `RolesRegistryUpgradeable` and `RolesAwareUpgradeable` enforce protocol permissions.

## Security

1. Upgradeable core modules are deployed behind proxies.
2. `FundingPoolUpgradeable`, `VotingSystemUpgradeable`, and `GrantManagerUpgradeable` are pausable.
3. Treasury transfers use `SafeERC20`.
4. Milestone payout state prevents duplicate release.
5. Role-gated cross-contract calls reduce unauthorized state changes.

## Development

```bash
npm install
npx hardhat compile
npx hardhat test
```

Local deployment:

```bash
npx hardhat node
npx hardhat run scripts/deploy/deploy-proxies.ts --network localhost
```

Arc testnet deployment:

```bash
cp .env.example .env
npx hardhat run scripts/deploy/deploy-proxies.ts --network arcTestnet
```

If `USDC_ADDRESS` is not set, the deploy script falls back to `MockUSDC` for local/dev environments.

## Docs

1. [Architecture](docs/ARCHITECTURE.md)
2. [Security](docs/SECURITY.md)
3. [Contracts](docs/CONTRACTS.md)
4. [Migration notes](docs/MIGRATION_NOTES.md)
5. [Arc deployment guide](scripts/deploy/docs_deploy/DEPLOY.md)
6. [Upgrades](docs/UPGRADES.md)

**Disclaimer**
This repository contains the core smart contracts of the protocol. The codebase may evolve rapidly, so older guides may not match the current layout. Refer to the latest docs for accurate integration guidance.

**License**

2026 BERT [info@tenyokj](mailto:av7794257@gmail.com)

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License, or any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the [GNU General Public License](LICENSE) for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
