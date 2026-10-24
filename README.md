![Bert V2.3 and V3.2](https://img.shields.io/badge/Bert-V2.3%20%2B%20V3.2-0F766E)
![License: GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-green)
![Hardhat](https://img.shields.io/badge/Hardhat-3.x-yellow)
![Solidity](https://img.shields.io/badge/Solidity-^0.8.20-orange)
![Arc](https://img.shields.io/badge/Arc-Testnet-1D4ED8)

![LOGO](/docs/assets/banner.png)

# BERT

BERT is programmable stablecoin-native funding infrastructure for transparent grant allocation, treasury coordination, and milestone-based capital release.

Explore indexed testnet activity in [BERT Console V0.1.0 Beta](https://bertdao-console.vercel.app) ([source](https://github.com/Tenyokj/bert-console-arc)). The console is read-only; contract state and transaction receipts remain authoritative.

The protocol keeps proposal intake, voting rounds, treasury accounting, and staged grant distribution onchain. Economic flows are USDC-native: proposal deposits, vote commitments, treasury balances, reserve accounting, and grant payouts all settle in USDC-compatible units.

The voting model can enforce a configured verification-attestation gate through a dedicated verifier contract. Voting remains capital-weighted in USDC, and the configured per-pledge cap applies when enabled. Current testnet Demo attestations are not proof of personhood; the planned production policy is described below.

## Verification By Network

### Current Arc Testnet

The public dApp is in active development on Arc Testnet. It uses an explicitly labelled **Demo verification** path so every testnet wallet can exercise the real on-chain `PoPVerifierUpgradeable` gate, protected actions, and voting flows. Demo verification is not proof of personhood and must never be treated as Sybil resistance or an identity check. Its signed provider ID is `BERT_TESTNET_DEMO`.

### Planned Mainnet

Demo verification is disabled for mainnet deployments. The production policy is World ID proof-of-personhood: the backend verifies a World proof, binds one World nullifier to one BERT wallet, and only then signs the on-chain payload. The Solidity contract intentionally stays provider-agnostic; it verifies the trusted backend signature, expiry, nonce, and wallet binding rather than embedding a vendor SDK.

See the public [Testnet Guide](https://bertdao.vercel.app/testnet-information) before using the Arc deployment.

## Problem

Traditional grant programs are often opaque, manual, slow to execute, and difficult to audit. Treasury coordination is fragmented across forms, spreadsheets, chat approvals, and offchain payout operations.

## Solution

BERT turns grant allocation into programmable treasury flow:

1. Builders create proposals with a stake-backed submission flow.
2. Participants commit USDC voting weight during funding rounds.
3. A pledge is bound to one selected idea for that round, not donated to a general winner pool.
4. The highest-supported idea that meets its disclosed post-fee minimum funding target is selected.
5. Losing pledges are refundable by their original voters. If no idea is viable, every pledge is refundable.
6. The fee rate is fixed when a round opens. In V2.3, the fee moves to reserve proportionally with each released author tranche, not all upfront.
7. In V2.3 backer-governed rounds, the viable winner receives 20% / 40% / 40% net-grant releases; eligible winning backers review proof before later tranches unlock, and the corresponding fee vests progressively.

Each V2 round snapshots its milestone mode when it starts. Legacy reviewer-governed rounds retain 30% / 40% / 30%; upgrading the implementation does not rewrite an existing round. See [current release and payout modes](docs/CURRENT-RELEASE.md).

Historical V3.1 gap: a distinct Member execution recipient can review if it supported the winner. The fix is deployed in V3.2 (Manager 2.0.0), preserving financial refund rights. Existing immutable V3.1 Communities retain the old behavior. See the [security review follow-up](docs/SECURITY-REVIEW-V3.1.md).

The **Community Layer V3.2, deployed on Arc Testnet on 24 October 2026,** ([release scope](docs/V3.2-RELEASE.md)) uses Manager 2.0.0 and requires [Admin quorum for every execution tranche](docs/V3.2-TRANCHE-QUORUM.md), with seven-active-day payment expiry and unpaid-budget refunds. These rules apply to new V3.2 Communities, not existing immutable V3.0/V3.1 instances. See the [deployment record](docs/V3.2-ARC-TESTNET-RELEASE.md).

## Why Arc

BERT is designed for Arc’s stablecoin settlement infrastructure.

Arc is not presented here as “just another EVM” or a “cheap chain”. The fit is that Arc is a stablecoin-native execution environment where USDC is central to settlement and fees. That makes it a strong home for treasury coordination, grant disbursement, and programmable capital allocation workflows.

For the current Arc testnet references used in this repo:

1. Arc Testnet chain ID is `5042002`.
2. Public RPC is `https://arc-testnet.drpc.org`.
3. Testnet USDC ERC-20 interface address is `0x3600000000000000000000000000000000000000`.

Sources:
1. Arc docs: `Connect to Arc`
2. Arc docs: `Contract addresses`
3. Circle docs: `USDC Contract Addresses`

## V2 Stake-Backed Funding Flow

```text
Builder creates a proposal with an author bond and minimum net funding target
        |
        v
Author bond is locked in USDC
        |
        v
Participants make one USDC pledge to one idea in the round
        |
        v
VotingSystem selects the highest-supported viable idea after the locked fee
        |
        v
Losers claim their own pledges back
        |
        v
V2.3 winner claims a net grant in 20% / 40% / 40% milestones
        |
        v
If the grant is never claimed or expires, defined refunds reopen for winning pledgers
```

The V2 model is not a pooled tournament where a voter who backed a losing idea silently funds a different winner. A pledge remains attributable to its voter and selected idea. The disclosed successful-round fee is snapshotted at round opening. V2.3 vests it alongside each author tranche; cancellation restores the unvested fee together with the unreleased net grant for winning-backers' refunds. Legacy rounds finalize their whole fee at the initial claim.

## Core Modules

1. `IdeaRegistryUpgradeable` stores proposals, metadata, author stake requirements, and lifecycle state.
2. `VotingSystemUpgradeable` manages voting rounds and USDC-denominated vote commitments.
3. `FundingPoolUpgradeable` is the USDC treasury and accounting layer.
4. `GrantManagerUpgradeable` coordinates claim flow and milestone-based releases.
5. `RolesRegistryUpgradeable` and `RolesAwareUpgradeable` enforce protocol permissions.
6. `PoPVerifierUpgradeable` stores trusted backend-signed verification attestations used by voting access control.
7. [BERT V3 Community Layer](contracts/BERT/V3/README.md) is the current modular Community implementation. The previous testnet implementation is archived under `legacy/V3_0`.

## V3 Architecture At A Glance

```mermaid
flowchart TB
    user[Community creator, Admin, Validator, or Member]
    dapp[BERT Next.js dApp]
    backend[Verification backend\nDemo PoP on Arc Testnet\nWorld ID on planned mainnet]

    subgraph arc[Arc Testnet: EVM execution and USDC settlement]
        factory[CommunityFactory]
        hub[CommunityHub\nidentity, configuration, protected actions]
        membership[CommunityMembershipModule]
        proposals[CommunityProposalModule]
        voting[CommunityVotingModule]
        milestones[CommunityMilestoneManager]
        treasury[CommunityTreasury\nUSDC custody and isolated accounting]
        reserve[FundingPoolUpgradeable\nV2 global protocol reserve]
        v2[V2 protocol modules\nIdeaRegistry, VotingSystem, GrantManager]
        pop[PoPVerifierUpgradeable\ntrusted signed attestation gate]

        factory -->|creates and binds modules per Community| hub
        factory --> treasury
        hub --> membership
        hub --> proposals
        hub --> voting
        hub --> milestones
        voting <-->|winner reserve| treasury
        milestones <-->|tranches and refunds| treasury
        treasury -->|defined protocol reserve inflows| reserve
        reserve --> v2
        pop -->|protects configured actions| v2
    end

    subgraph graph[The Graph: live Arc indexers]
        v2graph[V2 Subgraph]
        v3graph[V3.2 Subgraph\nversioned Community events]
    end

    user --> dapp
    dapp -->|contract reads and transactions| factory
    dapp -->|contract reads and transactions| hub
    dapp -->|contract reads and transactions| treasury
    dapp -->|requests an attestation| backend
    backend -->|signed payload submitted by wallet| pop
    arc -->|indexed events| v2graph
    arc -->|indexed events| v3graph
    v2graph -->|GraphQL live state| dapp
    v3graph -->|GraphQL live state| dapp
```

### V3 Execution Boundary

Each Community has its own immutable `CommunityHub`, modules, and `CommunityTreasury`; the Factory is the shared entry point. The Hub owns identity, immutable configuration, module addresses, and protected Admin actions. Membership, proposal, voting, and milestone logic have separate ownership boundaries. The Treasury is the sole USDC custodian and separates generic execution capital, vote escrow, milestone reserves, and supporter refund reserves.

V3 does not replace V2. Defined Community protocol inflows route into the existing V2 `FundingPoolUpgradeable` reserve, while each Community retains isolated membership, governance, and execution balances. V3.0 testnet contracts remain independently addressable under `legacy/V3_0`. V3.2 was deployed alongside the original V3.1 Factory on October 24, 2026. New Communities use the V3.2 Factory; old Communities retain their contracts. The V3 subgraph v3.2.0 indexes both modular Factories. See the [current release record](docs/V3.2-ARC-TESTNET-RELEASE.md) and [historical V3.1 record](docs/V3.1-ARC-TESTNET-RELEASE.md).

## Security

1. Upgradeable core modules are deployed behind proxies.
2. `FundingPoolUpgradeable`, `VotingSystemUpgradeable`, and `GrantManagerUpgradeable` are pausable.
3. Treasury transfers use `SafeERC20`.
4. Milestone payout state prevents duplicate release.
5. Role-gated cross-contract calls reduce unauthorized state changes.
6. Verified-human voting can be enabled without embedding any single identity provider directly into the voting contract.

## Development

Use Node.js 22.13.0 or newer. The dependency review, remaining toolchain
advisories and verification results are recorded in [Dependency Security](docs/DEPENDENCY-SECURITY.md).

```bash
npm ci
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

New to BERT? Community organizers can start with the
[Arc Testnet pilot](docs/COMMUNITY-PILOT.md) without a wallet. Contributors can
pick a focused task from the [starter issue drafts](docs/STARTER-ISSUES.md).

1. [Architecture](docs/ARCHITECTURE.md)
2. [Security](docs/SECURITY.md)
3. [Contracts](docs/CONTRACTS.md)
4. [Current release and payout modes](docs/CURRENT-RELEASE.md)
5. [Arc deployment guide](scripts/deploy/docs_deploy/DEPLOY.md)
6. [Upgrades](docs/UPGRADES.md)
7. [BERT V3 Community Layer](contracts/BERT/V3/README.md)
8. [Archived V3.0 file index](legacy/V3_0/docs/V3-FILE-INDEX.md)
9. [Contributor testing guide](docs/TESTING.md)
10. [Local V3.2 E2E runbook](docs/LOCAL-V3.1-E2E.md)
11. [V3.1 security review notes](docs/SECURITY-REVIEW-V3.1.md)
12. [V3.1 Arc Testnet release runbook](docs/V3.1-ARC-TESTNET-RELEASE.md)
13. [Contributing guide](CONTRIBUTING.md)

**Disclaimer**
This repository contains the core smart contracts of the protocol. The codebase may evolve rapidly, so older guides may not match the current layout. Refer to the latest docs for accurate integration guidance.

**License**

2026 BERT [info@bertdao](mailto:bertdaoarc@gmail.com)

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License, or any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the [GNU General Public License](LICENSE) for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
