![LOGO](/docs//assets/v3-banner.png)

# BERT V3 Community Layer

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

NFT rewards, general airdrops, onchain implementation milestones, and a separate V3 reputation system are outside the current Community Layer scope.
