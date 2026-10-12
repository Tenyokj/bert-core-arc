// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {CommunityTypes} from "../libraries/CommunityTypes.sol";

/** @notice Read surface used by Treasury and membership exit checks. */
interface ICommunityVotingModule {
    function getBinaryVote(uint256 proposalId, address voter)
        external
        view
        returns (CommunityTypes.VoteChoice choice, uint256 stake);

    function hasExitBlockingObligation(address member) external view returns (bool);
}
