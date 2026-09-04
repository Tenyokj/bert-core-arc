// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {CommunityTypes} from "../utils/CommunityTypes.sol";

interface ICommunityHub {
    function isAdminAccount(address account) external view returns (bool);

    function communityStatus()
        external
        view
        returns (CommunityTypes.CommunityStatus);

    function validatorRewardShareBps() external view returns (uint256);

    function adminApprovalThreshold() external view returns (uint256);

    function getBinaryVote(uint256 proposalId, address voter)
        external
        view
        returns (CommunityTypes.VoteChoice choice, uint256 stake);

    function isValidatorActiveForEpoch(uint256 epochId, address validator)
        external
        view
        returns (bool);
}
