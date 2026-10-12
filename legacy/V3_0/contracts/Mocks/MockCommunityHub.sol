// SPDX-License-Identifier: GPL-3.0
/**
 * @notice Test-only CommunityHub implementation for isolated CommunityTreasury tests.
 * @dev Never deploy this contract in production: its setters and Treasury bridge functions are intentionally open.
 */
pragma solidity ^0.8.20;

import {CommunityTypes} from "../BERT/V3/libraries/CommunityTypes.sol";
import {ICommunityHub} from "../BERT/V3/interfaces/ICommunityHub.sol";
import {ICommunityTreasury} from "../BERT/V3/interfaces/ICommunityTreasury.sol";

/**
 * @title MockCommunityHub
 * @notice Minimal V3 Hub double used to test Treasury authorization and settlement paths.
 * @dev This mock deliberately exposes Treasury-only calls; production CommunityHub will enforce governance rules.
 */
contract MockCommunityHub is ICommunityHub {
    address private immutable _creator;
    address private immutable _communityTreasury;
    bytes32 private immutable _configHash;
    CommunityTypes.CommunityStatus private _status = CommunityTypes.CommunityStatus.Active;
    uint256 private _validatorRewardShareBps;
    uint256 private _adminApprovalThreshold = 1;

    mapping(address account => bool) private _admins;
    mapping(uint256 proposalId => mapping(address voter => CommunityTypes.VoteChoice choice)) private _voteChoice;
    mapping(uint256 proposalId => mapping(address voter => uint256 stake)) private _voteStake;
    mapping(uint256 epochId => mapping(address validator => bool active)) private _activeValidator;

    /**
     * @notice Creates a mock Hub with a configurable validator reward share.
     * @param validatorRewardShareBps_ Reward share expressed in basis points.
     */
    constructor(uint256 validatorRewardShareBps_) {
        _validatorRewardShareBps = validatorRewardShareBps_;
        _creator = msg.sender;
        _communityTreasury = address(0);
        _configHash = bytes32(0);
    }

    /**
     * @notice Returns the mock creator address.
     */
    function creator() external view returns (address) {
        return _creator;
    }

    /**
     * @notice Returns the mock's unset Treasury address.
     */
    function communityTreasury() external view returns (address) {
        return _communityTreasury;
    }

    /**
     * @notice Returns the mock's empty configuration hash.
     */
    function configHash() external view returns (bytes32) {
        return _configHash;
    }

    /**
     * @notice Returns the mock's fixed local validator-nomination threshold.
     * @dev Treasury does not consume this value; it only completes the Hub interface surface.
     */
    function validatorProposalPointsThreshold() external pure returns (uint256) {
        return 15;
    }

    /**
     * @notice Returns the mock admin flag for an address.
     */
    function isAdminAccount(address account) external view returns (bool) {
        return _admins[account];
    }

    /**
     * @notice Returns the mutable mock community status.
     */
    function communityStatus() external view returns (CommunityTypes.CommunityStatus) {
        return _status;
    }

    /**
     * @notice Returns the mock validator reward share in basis points.
     */
    function validatorRewardShareBps() external view returns (uint256) {
        return _validatorRewardShareBps;
    }

    /**
     * @notice Returns the mock admin approval threshold.
     */
    function adminApprovalThreshold() external view returns (uint256) {
        return _adminApprovalThreshold;
    }

    /**
     * @notice Returns the mock binary vote stored for a voter and proposal.
     */
    function getBinaryVote(uint256 proposalId, address voter)
        external
        view
        returns (CommunityTypes.VoteChoice choice, uint256 stake)
    {
        return (_voteChoice[proposalId][voter], _voteStake[proposalId][voter]);
    }

    /**
     * @notice Returns mock validator reward eligibility for an epoch.
     */
    function isValidatorActiveForEpoch(uint256 epochId, address validator) external view returns (bool) {
        return _activeValidator[epochId][validator];
    }

    /**
     * @notice Test helper that changes the mock community status.
     */
    function setStatus(CommunityTypes.CommunityStatus status_) external {
        _status = status_;
    }

    /**
     * @notice Test helper that grants or revokes the mock admin flag.
     */
    function setAdmin(address account, bool active) external {
        _admins[account] = active;
    }

    /**
     * @notice Test helper that updates the validator reward share.
     */
    function setValidatorRewardShareBps(uint256 rewardShareBps_) external {
        _validatorRewardShareBps = rewardShareBps_;
    }

    /**
     * @notice Test helper that updates the mock withdrawal quorum.
     */
    function setAdminApprovalThreshold(uint256 threshold) external {
        _adminApprovalThreshold = threshold;
    }

    /**
     * @notice Test helper that records an arbitrary binary vote for refund checks.
     */
    function setBinaryVote(
        uint256 proposalId,
        address voter,
        CommunityTypes.VoteChoice choice,
        uint256 stake
    ) external {
        _voteChoice[proposalId][voter] = choice;
        _voteStake[proposalId][voter] = stake;
    }

    /**
     * @notice Test helper that sets validator reward eligibility for an epoch.
     */
    function setValidatorActiveForEpoch(uint256 epochId, address validator, bool active) external {
        _activeValidator[epochId][validator] = active;
    }

    /**
     * @notice Test bridge that calls the Treasury as its configured Hub.
     */
    function depositVoteStake(address treasury, uint256 proposalId, address voter, uint256 amount) external {
        ICommunityTreasury(treasury).depositVoteStake(proposalId, voter, amount);
    }

    /**
     * @notice Test bridge for membership stake deposits.
     */
    function depositMembershipStake(address treasury, address member, uint256 amount) external {
        ICommunityTreasury(treasury).depositMembershipStake(member, amount);
    }

    /**
     * @notice Test bridge for membership stake releases.
     */
    function releaseMembershipStake(address treasury, address member, uint256 amount) external {
        ICommunityTreasury(treasury).releaseMembershipStake(member, amount);
    }

    /**
     * @notice Test bridge for member proposal bond deposits.
     */
    function depositProposalBond(
        address treasury,
        uint256 proposalId,
        address author,
        uint256 amount
    ) external {
        ICommunityTreasury(treasury).depositProposalBond(proposalId, author, amount);
    }

    /**
     * @notice Test bridge for routing a rejected proposal bond to the reserve.
     */
    function slashProposalBond(address treasury, uint256 proposalId) external {
        ICommunityTreasury(treasury).slashProposalBond(proposalId);
    }

    /**
     * @notice Test bridge for returning a settled proposal bond to its author.
     */
    function returnProposalBond(address treasury, uint256 proposalId, address author) external {
        ICommunityTreasury(treasury).returnProposalBond(proposalId, author);
    }

    /**
     * @notice Test bridge for the YES settlement path.
     */
    function settleBinaryYesWin(
        address treasury,
        uint256 proposalId,
        uint256 yesStake,
        uint256 noStake,
        uint256 epochId
    ) external {
        ICommunityTreasury(treasury).settleBinaryYesWin(proposalId, yesStake, noStake, epochId);
    }

    /**
     * @notice Test bridge for the NO settlement path.
     */
    function settleBinaryNoWin(
        address treasury,
        uint256 proposalId,
        uint256 yesStake,
        uint256 noStake,
        uint256 feeBps
    ) external {
        ICommunityTreasury(treasury).settleBinaryNoWin(proposalId, yesStake, noStake, feeBps);
    }

    /**
     * @notice Test bridge for validator epoch finalization.
     */
    function finalizeValidatorRewardEpoch(
        address treasury,
        uint256 epochId,
        uint256 activeValidatorCount
    ) external {
        ICommunityTreasury(treasury).finalizeValidatorRewardEpoch(epochId, activeValidatorCount);
    }

    /**
     * @notice Test bridge for Hub-governed withdrawal cancellation.
     * @dev Simulates the real CommunityHub after its Admin quorum has approved a cancellation action.
     * @param treasury Community Treasury whose request is being cancelled.
     * @param requestId Existing withdrawal request identifier.
     */
    function cancelWithdrawalRequestByGovernance(address treasury, uint256 requestId) external {
        ICommunityTreasury(treasury).cancelWithdrawalRequestByGovernance(requestId);
    }
}
