// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

/** @notice Narrow execution-plan surface used by CommunityVotingModule. */
interface ICommunityMilestoneManager {
    function unresolvedPlanCount() external view returns (uint256);
    /** @notice Starts a plan from full financial support; the Manager excludes executor weight only from review. */
    function startExecutionPlan(uint256 proposalId, uint256 budget, uint256 totalSupportWeight, uint64 communityTime) external;

    /** @notice Whether a winning supporter's vote lock may be released. */
    function canReleaseReviewerLock(uint256 planId, address supporter) external view returns (bool);
}
