# Contract Versioning

Every deployable BERT contract carries a NatSpec `@custom:version` tag in
`MAJOR.MINOR.PATCH` format. The version belongs to that contract alone; it is
not the protocol, product, deployment, or release version.

## Rules

- New contract: start at `1.0.0`.
- `MAJOR`: increment for a breaking or material change to critical business
  logic, storage layout, trust boundaries, or a contract's core architecture.
- `MINOR`: increment for an additive, backwards-compatible feature that does
  not materially replace the contract's core logic.
- `PATCH`: increment only for a bug fix, validation correction, or narrowly
  scoped safe patch.

Each contract evolves independently. For example, one contract may be
`1.8.9` while another is `5.6.1`; do not synchronize numbers merely because
they are deployed or released together.

## V3.1 Baseline

The V3.1 module split is a major architectural change for the pre-existing
`CommunityHub`, `CommunityFactory`, `CommunityTreasury`,
`CommunityTreasuryDeployer`, and `CommunityTypes`, so their current baseline
is `2.0.0`. The new module and module-deployer contracts begin at `1.0.0`.
`CommunityErrors` receives additive error definitions only and remains at
`1.1.0`.
