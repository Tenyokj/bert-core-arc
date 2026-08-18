// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import { IHumanVerifier } from "../BERT/interfaces/IHumanVerifier.sol";

/**
 * @title MockHumanVerifier
 * @notice Test helper for verified-human voting gates
 */
contract MockHumanVerifier is IHumanVerifier {
    mapping(address => bool) private _verified;

    function setVerified(address account, bool verified) external {
        _verified[account] = verified;
    }

    function isVerifiedHuman(address account) external view returns (bool) {
        return _verified[account];
    }
}
