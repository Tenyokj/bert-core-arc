// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

/** @notice Narrow V3.1 execution-plan custody surface. */
interface ICommunityMilestoneTreasury {
    function reserveExecutionPlan(uint256 planId, uint256 amount) external;

    function releaseExecutionTranche(uint256 planId, address recipient, uint256 amount) external;

    function seedExecutionPlanRefund(uint256 planId, uint256 amount) external;

    function claimExecutionPlanRefund(uint256 planId, address recipient, uint256 amount) external;
}
