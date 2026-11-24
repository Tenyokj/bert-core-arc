# Frozen FundingPool Upgrade Fixture

`FundingPoolV140.json` is generated compiler data, not a new deployable source
contract and not a live deployment manifest. It freezes FundingPool `1.4.0` from
the commit recorded in its `commit` field before adding V2.4 revenue logic.

The fixture includes ABI, creation bytecode, compiler settings and storage layout.
It was built using solc 0.8.28, Prague, optimizer runs 200, with storage-layout
output enabled in Hardhat. Source names use Hardhat 3's `project/` prefix.
It contains no network credentials or wallet keys.

`ProtocolRevenue.fully.ts` deploys this old bytecode behind an OZ v5 Transparent
proxy, populates the real V2.3 grant flow and V3 reserve routing, upgrades to the
candidate and continues the old grant/refund lifecycle. It separately compares
every original storage field/type and the remaining gap against current compiler
output. The bytecode must remain frozen, not regenerated from the new contract.

To reproduce, check out the recorded commit in a separate worktree, enable
`settings.outputSelection["*"]["*"] = ["storageLayout"]`, compile, and extract
`output.contracts["project/contracts/BERT/DAO/FundingPoolUpgradeable.sol"]
.FundingPoolUpgradeable` from the corresponding Hardhat build-info output.
Record the exact compiler settings alongside ABI/bytecode/layout.

This verifies compatibility with that source baseline. It does **not** attest
that a public proxy runs this exact bytecode, reconcile its live balance, or
replace a fork rehearsal and independent upgrade review.
