# PoPVerifierUpgradeable

Stores backend-signed proof-of-personhood attestations that can be consumed by `VotingSystemUpgradeable` through the `IHumanVerifier` interface.

## Responsibilities

- accept EIP-712 verification proofs signed by a trusted backend signer
- bind proofs to the submitting wallet
- enforce strictly increasing nonces per wallet
- store verification expiry timestamps onchain
- expose a simple `isVerifiedHuman(address)` gate for voting logic
- allow admin signer rotation and manual revocation

## Key State

- `trustedSigner`: backend signer allowed to attest PoP results
- `verifiedUntil[address]`: verification expiration timestamp per wallet
- `latestNonce[address]`: last consumed nonce per wallet

## Trust Model

- the contract does not verify humanity itself
- it trusts `trustedSigner` to sign proofs only after offchain PoP checks succeed
- `VotingSystemUpgradeable` trusts only the onchain verifier result, not the backend directly

## Critical Invariants

- a proof for one wallet cannot be replayed by another wallet
- expired proofs must not be accepted
- nonce progression must be strictly increasing
- signer rotation must not bypass admin authority
- revoked verification must immediately disable `isVerifiedHuman`

## Main Flows

### Submit verification

1. backend signs a typed `Verification` payload for a wallet
2. wallet calls `submitVerification(...)`
3. contract checks:
   - proof is not expired
   - nonce is the next required nonce
   - recovered signer equals `trustedSigner`
4. contract records the new expiry and nonce

### Query verification

- `isVerifiedHuman(account)` returns whether the wallet remains valid at the current timestamp
- `getVerification(account)` returns current status, expiry, and nonce

### Admin controls

- `setTrustedSigner(newSigner)` rotates the backend signer
- `revokeVerification(user)` removes the wallet's active verification
