// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {ICommunityFactoryRegistry} from "../BERT/interfaces/ICommunityFactoryRegistry.sol";
import {ICommunityTreasury} from "../BERT/V3/interfaces/ICommunityTreasury.sol";

/**
 * @title MockCommunityFactoryRegistry
 * @notice Test-only registry for FundingPoolUpgradeable V3 reserve routing tests.
 * @dev Never deploy this contract in production; CommunityFactory is the production registry.
 */
contract MockCommunityFactoryRegistry is ICommunityFactoryRegistry {
    /** @notice Test-configurable proof-of-personhood verifier returned to CommunityTreasury. */
    address public humanVerifier;
    mapping(address treasury => bool active) private activeTreasuries;

    /**
     * @notice Sets the test verifier used by CommunityTreasury membership checks.
     * @param verifier Mock verifier contract address.
     */
    function setHumanVerifier(address verifier) external {
        humanVerifier = verifier;
    }

    /**
     * @notice Links a test Treasury to a Hub through the address configured as its Factory.
     * @param treasury Treasury instance to bind.
     * @param hub CommunityHub address to authorize.
     */
    function setCommunityHub(address treasury, address hub) external {
        ICommunityTreasury(treasury).setCommunityHub(hub);
    }

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
