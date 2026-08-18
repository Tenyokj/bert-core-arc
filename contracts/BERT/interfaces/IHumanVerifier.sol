// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

/**
 * @title IHumanVerifier
 * @notice Minimal interface for proof-of-personhood / identity gating integrations
 * @dev The verifier can be backed by any provider as long as it returns whether
 *      a wallet satisfies the protocol's "verified human" requirement.
 */
interface IHumanVerifier {
    /**
     * @notice Returns whether a wallet is allowed to participate as a verified human
     * @param account Wallet to check
     * @return bool True if the wallet passes the configured human verification policy
     */
    function isVerifiedHuman(address account) external view returns (bool);
}
