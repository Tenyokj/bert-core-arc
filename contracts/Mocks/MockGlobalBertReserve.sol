// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {IGlobalBertReserve} from "../BERT/V3/interfaces/IGlobalBertReserve.sol";

/**
 * @title MockGlobalBertReserve
 * @notice Test-only accounting-aware global reserve receiver.
 * @dev Never deploy this mock in production; FundingPoolUpgradeable is the production receiver.
 */
contract MockGlobalBertReserve is IGlobalBertReserve {
    using SafeERC20 for IERC20;

    /** @notice USDC token pulled from CommunityTreasury test fixtures. */
    IERC20 public immutable usdc;

    /** @notice Aggregate USDC accepted through the reserve receiver interface. */
    uint256 public totalReceived;

    /**
     * @notice Creates a mock receiver for one USDC token.
     * @param usdc_ USDC token pulled from the calling treasury.
     */
    constructor(address usdc_) {
        usdc = IERC20(usdc_);
    }

    /**
     * @notice Pulls and records a V3 reserve contribution.
     * @param amount USDC amount in token-native units.
     */
    function receiveCommunityReserve(uint256 amount) external {
        usdc.safeTransferFrom(msg.sender, address(this), amount);
        totalReceived += amount;
    }
}
