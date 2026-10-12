// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

/**
 * @notice Read-only winner-supporter snapshot consumed by CommunityMilestoneManager.
 * @dev CommunityVotingModule must snapshot this at settlement, before membership can change.
 */
interface ICommunityMilestoneVoting {
    function milestoneVoterWeight(uint256 planId, address member) external view returns (uint256);

    function milestoneVoterCount(uint256 planId) external view returns (uint256);
}
