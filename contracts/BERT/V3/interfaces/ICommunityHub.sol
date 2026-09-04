// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {CommunityTypes} from "../utils/CommunityTypes.sol";

/// @title ICommunityHub
/// @notice Read-only CommunityHub surface required by CommunityTreasury.
/// @dev Keeps Treasury independent from the future full CommunityHub implementation.
interface ICommunityHub {
    /// @notice Reports whether an address currently holds the local admin role.
    /// @param account Address to inspect.
    function isAdminAccount(address account) external view returns (bool);

    /// @notice Returns the community lifecycle status.
    function communityStatus()
        external
        view
        returns (CommunityTypes.CommunityStatus);

    /// @notice Returns the percentage of a YES settlement reserved for validators, in basis points.
    function validatorRewardShareBps() external view returns (uint256);

    /// @notice Returns the number of admin approvals required to execute a withdrawal.
    function adminApprovalThreshold() external view returns (uint256);

    /// @notice Returns a member's recorded binary vote choice and stake.
    /// @param proposalId Proposal identifier.
    /// @param voter Member address.
    function getBinaryVote(uint256 proposalId, address voter)
        external
        view
        returns (CommunityTypes.VoteChoice choice, uint256 stake);

    /// @notice Reports whether a validator reached the activity threshold in an epoch.
    /// @param epochId Validator reward epoch identifier.
    /// @param validator Validator address.
    function isValidatorActiveForEpoch(uint256 epochId, address validator)
        external
        view
        returns (bool);
}
