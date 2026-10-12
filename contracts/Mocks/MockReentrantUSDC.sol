// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title MockReentrantUSDC
 * @notice Test-only six-decimal token that attempts one arbitrary callback during a token movement.
 * @dev The callback failure is deliberately swallowed so the outer token operation can prove that
 *      protocol state guards reject reentry without relying on a cooperative ERC-20 implementation.
 */
contract MockReentrantUSDC is ERC20 {
    address public callbackTarget;
    bytes public callbackData;
    bool public callbackOnTransferFrom;
    bool public callbackAttempted;
    bool public lastCallbackSucceeded;

    constructor() ERC20("Reentrant USD Coin", "rUSDC") {}

    function decimals() public pure override returns (uint8) {
        return 6;
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    function configureCallback(address target, bytes calldata data, bool onTransferFrom) external {
        callbackTarget = target;
        callbackData = data;
        callbackOnTransferFrom = onTransferFrom;
        callbackAttempted = false;
        lastCallbackSucceeded = false;
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        _attemptCallback(false);
        return super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        _attemptCallback(true);
        return super.transferFrom(from, to, amount);
    }

    function _attemptCallback(bool fromTransferFrom) private {
        if (
            callbackAttempted || callbackTarget == address(0) || callbackOnTransferFrom != fromTransferFrom
        ) return;

        callbackAttempted = true;
        (bool success,) = callbackTarget.call(callbackData);
        lastCallbackSucceeded = success;
    }
}
