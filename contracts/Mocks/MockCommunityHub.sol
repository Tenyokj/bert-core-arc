// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {CommunityTypes} from "../BERT/V3/utils/CommunityTypes.sol";
import {ICommunityHub} from "../BERT/V3/interfaces/ICommunityHub.sol";
import {ICommunityTreasury} from "../BERT/V3/interfaces/ICommunityTreasury.sol";

/// @notice Minimal V3 Hub double used to test Treasury authorization and settlement paths.
/// @dev This mock deliberately exposes Treasury-only calls; production CommunityHub will enforce governance rules.
contract MockCommunityHub is ICommunityHub {
    CommunityTypes.CommunityStatus private _status = CommunityTypes.CommunityStatus.Active;
    uint256 private _validatorRewardShareBps;
    uint256 private _adminApprovalThreshold = 1;

    mapping(address account => bool) private _admins;
    mapping(uint256 proposalId => mapping(address voter => CommunityTypes.VoteChoice choice)) private _voteChoice;
    mapping(uint256 proposalId => mapping(address voter => uint256 stake)) private _voteStake;
    mapping(uint256 epochId => mapping(address validator => bool active)) private _activeValidator;

    constructor(uint256 validatorRewardShareBps_) {
        _validatorRewardShareBps = validatorRewardShareBps_;
    }

    function isAdminAccount(address account) external view returns (bool) {
        return _admins[account];
    }

    function communityStatus() external view returns (CommunityTypes.CommunityStatus) {
        return _status;
    }

    function validatorRewardShareBps() external view returns (uint256) {
        return _validatorRewardShareBps;
    }

    function adminApprovalThreshold() external view returns (uint256) {
        return _adminApprovalThreshold;
    }

    function getBinaryVote(uint256 proposalId, address voter)
        external
        view
        returns (CommunityTypes.VoteChoice choice, uint256 stake)
    {
        return (_voteChoice[proposalId][voter], _voteStake[proposalId][voter]);
    }

    function isValidatorActiveForEpoch(uint256 epochId, address validator) external view returns (bool) {
        return _activeValidator[epochId][validator];
    }

    function setStatus(CommunityTypes.CommunityStatus status_) external {
        _status = status_;
    }

    function setAdmin(address account, bool active) external {
        _admins[account] = active;
    }

    function setValidatorRewardShareBps(uint256 rewardShareBps_) external {
        _validatorRewardShareBps = rewardShareBps_;
    }

    function setAdminApprovalThreshold(uint256 threshold) external {
        _adminApprovalThreshold = threshold;
    }

    function setBinaryVote(
        uint256 proposalId,
        address voter,
        CommunityTypes.VoteChoice choice,
        uint256 stake
    ) external {
        _voteChoice[proposalId][voter] = choice;
        _voteStake[proposalId][voter] = stake;
    }

    function setValidatorActiveForEpoch(uint256 epochId, address validator, bool active) external {
        _activeValidator[epochId][validator] = active;
    }

    function depositVoteStake(address treasury, uint256 proposalId, address voter, uint256 amount) external {
        ICommunityTreasury(treasury).depositVoteStake(proposalId, voter, amount);
    }

    function depositMembershipStake(address treasury, address member, uint256 amount) external {
        ICommunityTreasury(treasury).depositMembershipStake(member, amount);
    }

    function releaseMembershipStake(address treasury, address member, uint256 amount) external {
        ICommunityTreasury(treasury).releaseMembershipStake(member, amount);
    }

    function depositProposalBond(
        address treasury,
        uint256 proposalId,
        address author,
        uint256 amount
    ) external {
        ICommunityTreasury(treasury).depositProposalBond(proposalId, author, amount);
    }

    function slashProposalBond(address treasury, uint256 proposalId) external {
        ICommunityTreasury(treasury).slashProposalBond(proposalId);
    }

    function returnProposalBond(address treasury, uint256 proposalId, address author) external {
        ICommunityTreasury(treasury).returnProposalBond(proposalId, author);
    }

    function settleBinaryYesWin(
        address treasury,
        uint256 proposalId,
        uint256 yesStake,
        uint256 noStake,
        uint256 epochId
    ) external {
        ICommunityTreasury(treasury).settleBinaryYesWin(proposalId, yesStake, noStake, epochId);
    }

    function settleBinaryNoWin(
        address treasury,
        uint256 proposalId,
        uint256 yesStake,
        uint256 noStake,
        uint256 feeBps
    ) external {
        ICommunityTreasury(treasury).settleBinaryNoWin(proposalId, yesStake, noStake, feeBps);
    }

    function finalizeValidatorRewardEpoch(
        address treasury,
        uint256 epochId,
        uint256 activeValidatorCount
    ) external {
        ICommunityTreasury(treasury).finalizeValidatorRewardEpoch(epochId, activeValidatorCount);
    }
}
