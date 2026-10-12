// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {CommunityTypes} from "../libraries/CommunityTypes.sol";

interface ICommunityMembershipModule {
    function isAdmin(address account) external view returns (bool);
    function isValidator(address account) external view returns (bool);
    function isActiveMember(address account) external view returns (bool);
    function hasPendingExit(address account) external view returns (bool);
    function getMember(address account) external view returns (CommunityTypes.MemberInfo memory);
    function adminCount() external view returns (uint256);
    function validatorCount() external view returns (uint256);
    function unresolvedObligationCount(address account) external view returns (uint256);
    function addObligation(address account) external;
    function clearObligation(address account) external;
    function awardProposalPoint(uint256 proposalId, address account) external;
}
