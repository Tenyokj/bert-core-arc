// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import { IFundingPool } from "../BERT/interfaces/IFundingPool.sol";
import { IIdeaRegistry } from "../BERT/interfaces/IIdeaRegistry.sol";
import { IReputationSystem } from "../BERT/interfaces/IReputationSystem.sol";
import { IVoterProgression } from "../BERT/interfaces/IVoterProgression.sol";
import { IHumanVerifier } from "../BERT/interfaces/IHumanVerifier.sol";
import { RolesAwareUpgradeable } from "../BERT/extensions/Roles/RolesAwareUpgradeable.sol";

/**
 * @title MockBrokenVotingSystemLayout
 * @notice Reproduces the unsafe storage layout used by the broken PoP upgrade
 * @dev This contract exists only to simulate the production issue in tests
 */
contract MockBrokenVotingSystemLayout is
    Initializable,
    ReentrancyGuardUpgradeable,
    PausableUpgradeable,
    RolesAwareUpgradeable
{
    IFundingPool public fundingPool;
    IIdeaRegistry public ideaRegistry;
    IReputationSystem public reputationSystem;
    IVoterProgression public voterProgression;

    IHumanVerifier public humanVerifier;

    uint256 public constant MAX_VOTERS_PER_IDEA = 30;

    uint256 public IDEAS_PER_ROUND;
    uint256 public VOTING_DURATION;
    uint256 public lastRoundEnd;
    uint256 public lastUsedIdeaId;
    uint256 public currentRoundId;
    uint256 public minStake;

    bool public humanOnlyVoting;
    uint256 public maxVoteAmount;

    struct VotingRound {
        uint256 id;
        uint256[] ideaIds;
        uint256 startTime;
        uint256 endTime;
        bool active;
        bool ended;
        uint256 totalVotes;
        uint256 winningIdeaId;
        uint256 winningVotes;
        mapping(uint256 => uint256) ideaVotes;
        mapping(address => bool) hasVoted;
        mapping(uint256 => bool) isIdeaInRound;
        mapping(uint256 => address[]) votersForIdea;
    }

    mapping(uint256 => VotingRound) private votingRounds;

    function setHumanVerifier(address verifier) external onlyAdmin {
        humanVerifier = IHumanVerifier(verifier);
    }

    function setHumanOnlyVoting(bool enabled) external onlyAdmin {
        humanOnlyVoting = enabled;
    }

    function setMaxVoteAmount(uint256 amount) external onlyAdmin {
        maxVoteAmount = amount;
    }

    function version() external pure returns (uint256) {
        return 999;
    }
}
