// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title IProtocolRevenueTreasury
 * @notice Receiver identity checked before scheduling a future-round revenue policy.
 * @dev Identity checks do not prove implementation safety; policy administrators remain trusted.
 */
interface IProtocolRevenueTreasury {
    /// @notice Returns the immutable source pool.
    /// @return pool FundingPool proxy address.
    function fundingPool() external view returns (address pool);

    /// @notice Returns the immutable settlement token.
    /// @return token Token distributed by this receiver.
    function usdc() external view returns (IERC20 token);
}
