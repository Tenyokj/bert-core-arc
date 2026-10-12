// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

/** @notice Immutable V3.1 module addresses exposed to CommunityFactory during activation. */
interface ICommunityHubV31 {
    function membershipModule() external view returns (address);
    function proposalModule() external view returns (address);
    function votingModule() external view returns (address);
    function milestoneManager() external view returns (address);
}
