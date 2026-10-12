// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

/**
 * @title MockV3TreasuryModule
 * @notice Test-only caller used to exercise V3 Treasury capability boundaries.
 * @dev Never deploy in production. A real V3 module exposes only its own narrow Treasury calls.
 */
contract MockV3TreasuryModule {
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
