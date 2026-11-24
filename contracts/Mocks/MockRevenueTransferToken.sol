// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title MockRevenueTransferToken
 * @notice Test-only token simulating recipient tax, sender surcharge and a blocked payee.
 * @dev Never intended as a supported protocol asset.
 */
contract MockRevenueTransferToken is ERC20 {
    uint256 public mode;
    address public blockedPayee;

    constructor() ERC20("Revenue failure token", "RFT") {}

    function decimals() public pure override returns (uint8) { return 6; }

    function mint(address to, uint256 amount) external { _mint(to, amount); }

    function configure(uint256 nextMode, address blocked) external {
        mode = nextMode;
        blockedPayee = blocked;
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        require(to != blockedPayee, "blocked payee");
        if (mode == 1 && amount != 0) {
            _burn(msg.sender, 1);
            return super.transfer(to, amount - 1);
        }
        bool success = super.transfer(to, amount);
        if (mode == 2) _burn(msg.sender, 1);
        return success;
    }
}
