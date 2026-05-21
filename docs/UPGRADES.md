**Upgrade Guide**

**When To Upgrade**
1. Fix critical bugs.
2. Add features without breaking storage layout.
3. Adjust protocol behavior that cannot be handled by admin setters alone.

**Storage Layout Rules**
1. Do not reorder state variables.
2. Only append new variables at the end.
3. Preserve storage gaps in upgradeable contracts.
4. Keep inheritance order unchanged.

**Pre-Upgrade Checklist**
1. Verify storage layout compatibility.
2. Run tests and upgrade simulations.
3. Deploy the new implementation on localhost or Arc testnet.
4. Verify admin ownership of the proxy.
5. Confirm correct proxy and ProxyAdmin addresses.
6. Confirm initializer or reinitializer paths are not reused incorrectly.

**Upgrade Steps**
1. Deploy the new implementation using `upgrade-proxy.ts`.
2. Verify the proxy implementation address changed.
3. Run post-upgrade checks.

**Recent Upgrade Notes**
1. `v1.1.0` added author stake locking, milestone-based grant payouts, and milestone review storage.
2. `v1.1.2` migrated the live economic asset layer to USDC-native semantics while preserving core module boundaries.
3. New storage in `GrantManagerUpgradeable`, `FundingPoolUpgradeable`, and `IdeaRegistryUpgradeable` is appended after existing storage to preserve upgrade safety.

**Post-Upgrade Checks**
1. Read the EIP-1967 implementation slot.
2. Validate key parameters and role wiring.
3. Smoke test proposal creation, voting, claim, and milestone flows.
4. Run `verify-deploy.ts` with updated addresses.

**Common Pitfalls**
1. Using file name instead of contract name for `IMPL`.
2. Supplying ProxyAdmin address as proxy address.
3. Upgrading with an admin that is not the ProxyAdmin owner.
4. Restarting a local node between deploy and upgrade rehearsal.
5. Accidentally calling an initializer twice.
6. Forgetting that USDC flows use 6-decimal units.

**Rollback Strategy**
1. Keep the previous implementation address recorded.
2. Re-upgrade to the previous implementation if needed.
3. Document rollback triggers.
4. Verify treasury and milestone state consistency after rollback.

**Recommended Workflow**
1. Localhost upgrade rehearsal.
2. Arc testnet upgrade rehearsal.
3. Production upgrade with review and signoff.
