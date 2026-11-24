// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title IProtocolRevenuePool
 * @notice Narrow FundingPool boundary used by an immutable revenue receiver.
 */
interface IProtocolRevenuePool {
    /// @notice Returns the token backing the pool's accounting.
    /// @return token Pool settlement token.
    function usdc() external view returns (IERC20 token);

    /// @notice Reports earned revenue payable only to the specified Treasury.
    /// @param treasury Immutable receiver whose entitlement is queried.
    /// @return amount Unclaimed earned revenue in token-native units.
    function pendingRevenueByTreasury(address treasury) external view returns (uint256 amount);

    /// @notice Transfers the caller's earned entitlement to the caller itself.
    /// @param amount Earned revenue to receive in token-native units.
    function claimProtocolRevenue(uint256 amount) external;
}
