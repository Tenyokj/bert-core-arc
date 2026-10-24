// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

/**
 * @notice Full financial winner-supporter snapshot consumed by CommunityMilestoneManager.
 * @dev CommunityVotingModule seals this at settlement. The Manager separately
 *      excludes the execution recipient from review, not from financial refunds.
 */
interface ICommunityMilestoneVoting {
    function milestoneVoterWeight(uint256 planId, address member) external view returns (uint256);

    function milestoneVoterCount(uint256 planId) external view returns (uint256);
}
