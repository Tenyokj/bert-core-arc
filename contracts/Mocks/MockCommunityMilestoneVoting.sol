// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {ICommunityMilestoneVoting} from "../BERT/V3/interfaces/ICommunityMilestoneVoting.sol";

/** @notice Test-only winner-snapshot source. Production snapshots are written by CommunityVotingModule. */
contract MockCommunityMilestoneVoting is ICommunityMilestoneVoting {
    mapping(uint256 planId => mapping(address member => uint256 weight)) private weights;
    mapping(uint256 planId => uint256 count) private counts;

    function setVoter(uint256 planId, address member, uint256 weight) external {
        require(weight != 0, "zero weight");
        if (weights[planId][member] == 0) counts[planId] += 1;
        weights[planId][member] = weight;
    }

    function milestoneVoterWeight(uint256 planId, address member) external view returns (uint256) {
        return weights[planId][member];
    }

    function milestoneVoterCount(uint256 planId) external view returns (uint256) {
        return counts[planId];
    }
}
