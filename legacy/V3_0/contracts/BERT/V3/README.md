![LOGO](/docs//assets/v3-banner.png)

# BERT V3 Community Layer

> **Version map:** this directory contains two intentionally separate Community
> implementations. [`V3.0`](#v30-current-community-layer) is the deployed,
> immutable Community Layer. [`V3_1/`](V3_1/README.md) is the next Community
> Layer architecture for newly created Communities. Do not mix their contracts,
> interfaces, ABIs, deployment scripts, or subgraph handlers.

BERT V3 is the Community Layer module of the main BERT protocol. It lets an organization create an isolated, stake-gated governance space with local administrators, validators, members, proposal voting, and a USDC treasury.

It is not a replacement for BERT V2. V2 remains the global protocol layer; V3 communities are independent local governance domains that route defined protocol revenue into the existing V2 `FundingPoolUpgradeable` reserve.

For the whole protocol, start with the [main BERT README](../../../README.md).

## What A Community Contains

1. Stake-gated USDC membership.
2. Local admin and validator roles that cannot overlap.
3. A creator-selected, immutable `1-100` proposal-point threshold for validator nomination; `15` is the recommended default.
4. Admin and member proposals.
5. Validator review before member proposals become votable.
6. Binary `YES / NO` voting and optional slate rounds.
7. A local Treasury with execution funds, validator rewards, refunds, and admin-quorum withdrawals.
8. A controlled V2 reserve route for protocol-level inflows.

## Version Map

### V3.0: Current Community Layer

The directories adjacent to `V3_1/` (`community/`, `interfaces/`,
`libraries/`, and `utils/`) are **V3.0 only**. They implement the currently
deployed Community model:

- `CommunityFactory` creates V3.0 Communities.
- `CommunityHub` owns membership, roles, proposal flow, voting, settlement,
  and Community action quorum logic.
- `CommunityTreasury` holds Community funds.

V3.0 `CommunityHub` is non-upgradeable and its deployed bytecode is already
near the EIP-170 size limit. It must not receive V3.1 milestone code. Existing
V3.0 Communities retain their current behavior permanently.

### V3.1: Backer-Validated Community Execution

[`V3_1/`](V3_1/README.md) is a clean, modular implementation for **newly
created** Communities. It adds staged Community proposal execution: 20% at
settlement, then 40% and 40% after milestone approval by the supporters of the
winning proposal. It has its own factory, hub, treasury, modules, interfaces,
types, scripts, subgraph mappings, and frontend ABI/query surface.

Read the [V3.1 architecture map](V3_1/ARCHITECTURE.md) before editing or
deploying V3.1 contracts.

## Economic Model

- A winning Member binary proposal sends YES stake to the community Treasury: `85%` execution and `15%` validator rewards by default. Winning Admin binary and slate proposals route their complete local stake to execution because they do not require validator review.
- Binary NO stake is refundable less the configured rejection fee; YES stake and that fee route to the V2 global reserve.
- Slate rounds have no NO side. All round stake is split between local execution and validator rewards.
- A rejected member proposal loses its bond to the V2 reserve. A fairly considered member proposal receives its bond back when voting settles.

All amounts use the configured USDC-compatible token's native units. Arc USDC uses six decimals.

## Architecture

```text
Community creator
       |
       v
CommunityFactory proxy ----> CommunityTreasuryDeployer
       |                              |
       |                              v
       +----------------------> CommunityTreasury
       |                              ^
       v                              |
CommunityHub -------------------------+
       |
       +----> V2 FundingPoolUpgradeable.receiveCommunityReserve(...)
```

`CommunityFactory` is the only upgradeable V3 contract and uses the same Transparent proxy pattern as BERT V2. `CommunityHub`, `CommunityTreasury`, and `CommunityTreasuryDeployer` are immutable per deployment.

### Protected Community Actions

The linked `CommunityAdminActions` library protects every control-plane action that could change a Community's authority or release a Treasury reservation. It is executed through the CommunityHub, so action requests, approvals, and events remain scoped to the Community address.

- The creator of a request supplies its first approval automatically.
- The immutable `adminApprovalThreshold` selected at creation is required for execution.
- Requests expire after seven days of active Community time. Paused time does not consume that deadline.
- Protected actions are pause, resume, archive, add/remove Admin, add/remove Validator, and cancellation of a pending withdrawal request.
- Admin transfer is intentionally a two-request handover: add the replacement through quorum, then remove the former Admin through quorum. No Admin can unilaterally rewrite the Community control set.

## Deployment Boundary

1. Deploy V3 infrastructure: `CommunityTreasuryDeployer` and the `CommunityFactory` proxy.
2. Upgrade an existing V2 FundingPool only when moving an already-deployed V2 protocol to V3-aware code.
3. Configure the FundingPool with the V3 Factory address.
4. Each creator later creates and activates their own Community separately.

See [V3 deployment guide](../../../scripts/deploy/docs_deploy/V3_DEPLOY.md).

## Contract Documentation

1. [Contract documentation index](docs_contracts/README.md)
2. [CommunityFactory](docs_contracts/CommunityFactory.md)
3. [CommunityHub](docs_contracts/CommunityHub.md)
4. [CommunityTreasury](docs_contracts/CommunityTreasury.md)
5. [CommunityTreasuryDeployer](docs_contracts/CommunityTreasuryDeployer.md)
6. [Interfaces](docs_contracts/Interfaces.md)
7. [CommunityTypes](docs_contracts/CommunityTypes.md)
8. [CommunityErrors](docs_contracts/CommunityErrors.md)
9. [CommunityAdminActions](docs_contracts/CommunityAdminActions.md)
10. [Manual testing checklist](TESTING-CHECKLIST.md)

## Scope Notes

V3 local roles are intentionally separate from V2 `RolesRegistryUpgradeable`, `VoterProgressionUpgradeable`, and `ReputationSystemUpgradeable`. A V2 curator or reviewer has no automatic authority in a V3 community.

NFT rewards, general airdrops, onchain implementation milestones, and a
separate V3 reputation system are outside the **V3.0** Community Layer scope.
V3.1 introduces milestones for new Communities only; it does not retrofit them
onto V3.0 Communities.
