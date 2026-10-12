// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {CommunityTypes} from "../libraries/CommunityTypes.sol";

interface ICommunityProposalModule {
    function proposalCount() external view returns (uint256);
    function pendingValidationProposalCount() external view returns (uint256);
    function getProposal(uint256 proposalId) external view returns (CommunityTypes.Proposal memory);
    function getValidationEpoch(uint256 proposalId) external view returns (uint256);
    function getValidatorRewardEpoch(uint256 epochId) external view returns (CommunityTypes.ValidatorRewardEpoch memory);
    function isValidatorActiveForEpoch(uint256 epochId, address validator) external view returns (bool);

    function markBinaryVotingOpened(uint256 proposalId, uint64 communityTime, uint256 duration) external;
    function markRoundAssigned(uint256 proposalId, uint256 roundId) external;
    function recordBinaryVote(uint256 proposalId, CommunityTypes.VoteChoice choice, uint256 amount) external;
    function recordSlateVote(uint256 proposalId, uint256 amount) external;
    function settleBinaryProposal(uint256 proposalId, bool accepted) external;
    function settleSlateProposal(uint256 proposalId, bool won) external;
    function finalizeValidatorRewardEpoch(uint256 epochId, uint64 communityTime) external;
}
