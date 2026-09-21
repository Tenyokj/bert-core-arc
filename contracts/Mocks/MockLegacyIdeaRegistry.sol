// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "../BERT/DAO/IdeaRegistryUpgradeable.sol";

/**
 * @notice Test-only legacy implementation that creates proposals before funding targets existed.
 * @dev It shares the production registry storage layout and intentionally leaves
 *      `minimumNetFundingByIdea` empty, modelling the pre-BERT-V2.2 proxy state.
 */
contract MockLegacyIdeaRegistry is IdeaRegistryUpgradeable {
    function createLegacyProposal(
        string memory title,
        string memory description,
        string memory link,
        uint256 authorBond
    ) external returns (uint256 ideaId) {
        return _createFundingProposal(title, description, link, authorBond);
    }
}
