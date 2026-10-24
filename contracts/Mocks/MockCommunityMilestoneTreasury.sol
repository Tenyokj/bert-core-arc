// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {ICommunityMilestoneTreasury} from "../BERT/V3/interfaces/ICommunityMilestoneTreasury.sol";

/** @notice Test-only accounting double for isolated milestone-manager tests. */
contract MockCommunityMilestoneTreasury is ICommunityMilestoneTreasury {
    uint256 public executionBalance;
    bool public rejectRelease;
    function setRejectRelease(bool value) external { rejectRelease = value; }
    mapping(uint256 planId => uint256 amount) public reservedByPlan;
    mapping(uint256 planId => uint256 amount) public refundsByPlan;
    mapping(address recipient => uint256 amount) public paidTo;

    function seedExecutionBalance(uint256 amount) external {
        executionBalance += amount;
    }

    function reserveExecutionPlan(uint256 planId, uint256 amount) external {
        require(amount <= executionBalance, "insufficient execution balance");
        executionBalance -= amount;
        reservedByPlan[planId] += amount;
    }

    function releaseExecutionTranche(uint256 planId, address recipient, uint256 amount) external {
        require(!rejectRelease, "release rejected");
        require(amount <= reservedByPlan[planId], "insufficient reserve");
        reservedByPlan[planId] -= amount;
        paidTo[recipient] += amount;
    }

    function seedExecutionPlanRefund(uint256 planId, uint256 amount) external {
        require(amount <= reservedByPlan[planId], "insufficient reserve");
        reservedByPlan[planId] -= amount;
        refundsByPlan[planId] += amount;
    }

    function claimExecutionPlanRefund(uint256 planId, address recipient, uint256 amount) external {
        require(amount <= refundsByPlan[planId], "insufficient refund");
        refundsByPlan[planId] -= amount;
        paidTo[recipient] += amount;
    }
}
