// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {IGlobalBertReserve} from "../BERT/V3/interfaces/IGlobalBertReserve.sol";

/** @notice Test-only accounting-aware receiver for V3 reserve routing. */
contract MockV3GlobalBertReserve is IGlobalBertReserve {
    using SafeERC20 for IERC20;

    IERC20 public immutable token;
    uint256 public received;

    constructor(address token_) {
        token = IERC20(token_);
    }

    function receiveCommunityReserve(uint256 amount) external {
        token.safeTransferFrom(msg.sender, address(this), amount);
        received += amount;
    }
}
