// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

/** @notice Narrow Hub authority used to validate execution-tranche approvals. */
interface ICommunityTrancheGovernance {
    /** @notice Immutable number of distinct current Admin approvals required. */
    function adminApprovalThreshold() external view returns (uint256);
    /** @notice Whether the wallet currently holds the Community Admin role. */
    function isAdminAccount(address account) external view returns (bool);
    /** @notice Role-incarnation nonce; changes on both removal and reappointment. */
    function adminRoleNonce(address account) external view returns (uint256);
}
