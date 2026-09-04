// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "../utils/CommunityTypes.sol";

interface ICommunityTreasury {
    event CommunityHubConfigured(address indexed communityHub);

    event MembershipStakeDeposited(address indexed member, uint256 amount);
    event MembershipStakeReleased(address indexed member, uint256 amount);

    event ProposalBondDeposited(uint256 indexed proposalId, address indexed author, uint256 amount);
    event ProposalBondSlashed(uint256 indexed proposalId, uint256 amount);
    event ProposalBondReturned(uint256 indexed proposalId, address indexed author, uint256 amount);

    event VoteStakeDeposited(uint256 indexed proposalId, address indexed voter, uint256 amount);
    event BinaryYesWinSettled(uint256 indexed proposalId, uint256 executionAmount, uint256 validatorReward, uint256 globalReserveAmount);
    event BinaryNoWinSettled(uint256 indexed proposalId, uint256 refundLiability, uint256 globalReserveAmount);
    event RefundClaimed(uint256 indexed proposalId, address indexed voter, uint256 amount);

    event ValidatorRewardEpochFinalized(uint256 indexed epochId, uint256 rewardPerValidator, uint256 activeValidatorCount);
    event ValidatorRewardClaimed(uint256 indexed epochId, address indexed validator, uint256 amount);

    event WithdrawalRequestCreated(uint256 indexed requestId, address indexed creator, address indexed to, uint256 amount, string reason, string metadataURI);
    event WithdrawalApproved(uint256 indexed requestId, address indexed admin);
    event WithdrawalCancelled(uint256 indexed requestId, address indexed admin);
    event WithdrawalExecuted(uint256 indexed requestId, address indexed to, uint256 amount);

    function depositMembershipStake(
        address member,
        uint256 amount
    ) external;

    function finalizeValidatorRewardEpoch(
        uint256 epochId,
        uint256 activeValidatorCount
    ) external;

    function claimValidatorReward(uint256 epochId) external;

    function setCommunityHub(address communityHub_) external;

    function releaseMembershipStake(
        address member,
        uint256 amount
    ) external;

    function depositProposalBond(
        uint256 proposalId,
        address author,
        uint256 amount
    ) external;

    function slashProposalBond(
        uint256 proposalId
    ) external;

    function returnProposalBond(
        uint256 proposalId,
        address author
    ) external;

    function depositVoteStake(
        uint256 proposalId,
        address voter,
        uint256 amount
    ) external;

    function settleBinaryYesWin(
        uint256 proposalId,
        uint256 yesStake,
        uint256 noStake,
        uint256 epochId
    ) external;

    function settleBinaryNoWin(
        uint256 proposalId,
        uint256 yesStake,
        uint256 noStake,
        uint256 feeBps
    ) external;

    function createWithdrawalRequest(
        address to,
        uint256 amount,
        string calldata reason,
        string calldata metadataURI
    ) external;

    function claimNoVoteRefund(
        uint256 proposalId
    ) external;

    function approveWithdrawal(
        uint256 requestId
    ) external;

    function cancelWithdrawalRequest(
        uint256 requestId
    ) external;

    function executeWithdrawal(
        uint256 requestId
    ) external;

    function availableExecutionBalance() external view returns (uint256);

    function getWithdrawalRequest(
        uint256 requestId
    ) external view returns (CommunityTypes.WithdrawalRequest memory);

    function hasApprovedWithdrawal(
        uint256 requestId,
        address admin
    ) external view returns (bool);

    function getProposalBond(
        uint256 proposalId
    ) external view returns (uint256 amount, bool settled);

    function getRefundPreview(
        uint256 proposalId,
        address voter
    ) external view returns (uint256 amount, bool claimable);
}
