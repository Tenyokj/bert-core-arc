// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {IFundingPool} from "../BERT/interfaces/IFundingPool.sol";

/**
 * @title MockCommunityReserveTreasury
 * @notice Test-only caller that simulates CommunityTreasury reserve routing.
 * @dev Never deploy this contract in production; CommunityTreasury performs this operation there.
 */
contract MockCommunityReserveTreasury {
    using SafeERC20 for IERC20;

    /** @notice USDC token approved to the FundingPool before each test route. */
    IERC20 public immutable usdc;

    /**
     * @notice Creates a mock treasury for one USDC token.
     * @param usdc_ USDC token owned by the mock treasury in tests.
     */
    constructor(address usdc_) {
        usdc = IERC20(usdc_);
    }

    /**
     * @notice Approves and routes USDC through the FundingPool V3 reserve entrypoint.
     * @param fundingPool FundingPool receiver that records the reserve contribution.
     * @param amount USDC amount in token-native units.
     */
    function routeReserve(address fundingPool, uint256 amount) external {
        usdc.forceApprove(fundingPool, amount);
        IFundingPool(fundingPool).receiveCommunityReserve(amount);
    }
}
