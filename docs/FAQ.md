**FAQ**

**What asset is used for proposal stake, voting, and payouts?**
USDC-compatible ERC-20 units are used for proposal submission stake, voting commitments, treasury accounting, and grant payouts.

**Do I need to treat USDC as 6 decimals?**
Yes. Frontends, scripts, and integrations should use 6-decimal USDC units.

**Why do I see multiple ProxyAdmins?**
Each Transparent proxy creates its own ProxyAdmin in OZ v5. This is expected.

**Why does the admin slot show `0x0`?**
The proxy address is wrong or the node was restarted. Redeploy and use fresh addresses.

**Why does upgrade fail with owner errors?**
Only the ProxyAdmin owner can upgrade. Use the deployer or the configured owner multisig.

**Do I need `hardhat node` for tests?**
No. `hardhat test` uses an in-process network by default.

**Can I deploy to Arc testnet directly from this repo?**
Yes. The repo now includes `arcTestnet` config and a `USDC_ADDRESS` based deployment path.

**Can I still use non-Arc EVM testnets?**
Yes, for generic rehearsal if needed, but the repo’s preferred stablecoin-native deployment narrative is now Arc-oriented.
