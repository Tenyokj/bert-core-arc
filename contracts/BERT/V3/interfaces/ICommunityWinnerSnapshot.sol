// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {ICommunityMilestoneVoting} from "./ICommunityMilestoneVoting.sol";

/** @notice Write surface for immutable winner-supporter snapshots. */
interface ICommunityWinnerSnapshot is ICommunityMilestoneVoting {
    function recordWinnerSupport(uint256 planId, address supporter, uint256 weight) external;

    function sealWinnerSnapshot(uint256 planId, uint256 expectedTotalWeight) external;

    function milestoneTotalWeight(uint256 planId) external view returns (uint256);

    function snapshotSealed(uint256 planId) external view returns (bool);
}
