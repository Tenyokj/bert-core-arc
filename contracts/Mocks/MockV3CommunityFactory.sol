// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

/** @notice Test-only Factory surface for Treasury module-authorization tests. */
contract MockV3CommunityFactory {
    address public humanVerifier;

    constructor(address humanVerifier_) {
        humanVerifier = humanVerifier_;
    }

    function callTarget(address target, bytes calldata data) external returns (bytes memory result) {
        (bool success, bytes memory returnData) = target.call(data);
        if (!success) {
            assembly ("memory-safe") {
                revert(add(returnData, 0x20), mload(returnData))
            }
        }
        return returnData;
    }
}
