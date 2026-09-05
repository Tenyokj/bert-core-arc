// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {ICommunityFactoryRegistry} from "../BERT/interfaces/ICommunityFactoryRegistry.sol";

/**
 * @title MockCommunityFactoryRegistry
 * @notice Test-only registry for FundingPoolUpgradeable V3 reserve routing tests.
 * @dev Never deploy this contract in production; CommunityFactory is the production registry.
 */
contract MockCommunityFactoryRegistry is ICommunityFactoryRegistry {
    mapping(address treasury => bool active) private activeTreasuries;

    /**
     * @notice Sets a mock Treasury activation state.
     * @param treasury Treasury address to update.
     * @param active Whether the Treasury should pass Factory authentication.
     */
    function setActiveCommunityTreasury(address treasury, bool active) external {
        activeTreasuries[treasury] = active;
    }

    /**
     * @notice Returns the configured mock activation state.
     * @param treasury Treasury address to inspect.
     */
    function isActiveCommunityTreasury(address treasury) external view returns (bool) {
        return activeTreasuries[treasury];
    }
}
