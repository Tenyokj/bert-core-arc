// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {ICommunityFactoryRegistry} from "../BERT/interfaces/ICommunityFactoryRegistry.sol";

/**
 * @title MockCommunityFactoryRegistry
 * @notice Minimal test double for V2 FundingPool Community-reserve authentication.
 * @dev V3.0-specific Treasury binding helpers live with the V3.0 archive.
 */
contract MockCommunityFactoryRegistry is ICommunityFactoryRegistry {
    mapping(address treasury => bool active) private activeTreasuries;

    function setActiveCommunityTreasury(address treasury, bool active) external {
        activeTreasuries[treasury] = active;
    }

    function isActiveCommunityTreasury(address treasury) external view returns (bool) {
        return activeTreasuries[treasury];
    }
}
