# PoPVerifierUpgradeable

Stores backend-signed verification attestations that can be consumed by `VotingSystemUpgradeable` through the `IHumanVerifier` interface.

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
- it trusts `trustedSigner` to apply the deployment's offchain verification policy before signing
- `VotingSystemUpgradeable` trusts only the onchain verifier result, not the backend directly

### Deployment policy

- **Arc Testnet:** the public dApp may use the clearly labelled `BERT_TESTNET_DEMO` provider. It exists solely to let any test wallet exercise the real onchain gate and is not a human or Sybil-resistance attestation.
- **Mainnet:** the demo endpoint is disabled. The intended provider is World ID: the backend verifies the World proof and binds one World nullifier to one BERT wallet before it signs a payload.
- The provider policy is deliberately enforced by the backend and deployment configuration. The contract remains provider-agnostic so it verifies a signed payload's wallet, expiry and nonce without embedding a third-party identity protocol.

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
