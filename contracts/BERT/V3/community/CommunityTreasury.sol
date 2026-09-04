// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import {CommunityTypes} from "../utils/CommunityTypes.sol";
import "../utils/CommunityErrors.sol";
import "../../utils/Errors.sol";
import {ICommunityHub} from "../interfaces/ICommunityHub.sol";
import {ICommunityTreasury} from "../interfaces/ICommunityTreasury.sol";

/// @title CommunityTreasury
/// @notice Holds USDC and settlement accounting for one BERT V3 community.
/// @dev Governance decisions live in CommunityHub; this contract only executes authorized fund flows.
contract CommunityTreasury is ICommunityTreasury, ReentrancyGuard {
    using SafeERC20 for IERC20;

    IERC20 public immutable usdc;
    address public immutable globalBertReserve;
    address public immutable factory;
    address public communityHub;

    uint256 public totalMembershipLocked;
    uint256 public executionBalance;
    uint256 public validatorRewardBalance;
    uint256 public totalVoteEscrow;
    uint256 public totalRefundLiability;
    uint256 public reservedExecutionBalance;
    uint256 public totalProposalBondLocked;

    mapping(uint256 proposalId => uint256 amount) public proposalBondById;
    mapping(uint256 proposalId => bool settled) public proposalBondSettled;

    mapping(uint256 proposalId => bool settled) public binaryVoteSettled;
    mapping(uint256 proposalId => uint256 feeBps) public rejectionFeeBpsByProposal;

    mapping(uint256 epochId => uint256 amount) public rewardAmountByEpoch;
    mapping(uint256 epochId => uint256 amount) public rewardPerValidatorByEpoch;

    mapping(uint256 epochId => mapping(address validator => bool claimed)) public validatorRewardClaimed;

    mapping(uint256 proposalId => uint256 amount) public voteEscrowByProposal;
    mapping(uint256 proposalId => bool noWonByProposal) public noWonByProposal;
    mapping(uint256 epochId => bool finalized) public validatorRewardEpochFinalized;

    mapping(uint256 proposalId => mapping(address voter => bool claimed)) public refundClaimed;

    uint256 public withdrawalRequestCount;

    mapping(uint256 requestId => CommunityTypes.WithdrawalRequest) private withdrawalRequests;

    mapping(uint256 requestId => mapping(address admin => bool)) public withdrawalApprovedBy;

    constructor(
        IERC20 usdc_,
        address globalBertReserve_,
        address factory_
    ) {
        if (address(usdc_) == address(0)) revert ZeroAddress("usdc");
        if (globalBertReserve_ == address(0)) revert ZeroAddress("globalBertReserve");
        if (factory_ == address(0)) revert ZeroAddress("factory");

        usdc = usdc_;
        globalBertReserve = globalBertReserve_;
        factory = factory_;
    }

    modifier onlyFactory() {
        if (msg.sender != factory) revert NotCommunityFactory(msg.sender);
        _;
    }

    modifier onlyCommunityHub() {
        if (communityHub == address(0)) revert CommunityHubNotConfigured();
        if (msg.sender != communityHub) revert NotCommunityHub(msg.sender);
        _;
    }

    modifier onlyCommunityAdmin() {
        if (communityHub == address(0)) revert CommunityHubNotConfigured();
        if (!ICommunityHub(communityHub).isAdminAccount(msg.sender)) {
            revert NotCommunityAdmin(msg.sender);
        }
        _;
    }

    modifier onlyActiveCommunity() {
        if (communityHub == address(0)) revert CommunityHubNotConfigured();
        if (
            ICommunityHub(communityHub).communityStatus() != CommunityTypes.CommunityStatus.Active
        ) {
            revert CommunityNotActive();
        }
        _;
    }

    modifier hubIsConfigured() {
        if (communityHub == address(0)) revert CommunityHubNotConfigured();
        _;
    }

    function depositMembershipStake(
        address member,
        uint256 amount
    ) external override onlyCommunityHub onlyActiveCommunity {
        if (amount == 0) revert ZeroAmount();
        if (member == address(0)) revert ZeroAddress("member");

        usdc.safeTransferFrom(member, address(this), amount);
        totalMembershipLocked += amount;

        emit MembershipStakeDeposited(member, amount);
    }

    function finalizeValidatorRewardEpoch(
        uint256 epochId,
        uint256 activeValidatorCount
    ) external override onlyCommunityHub onlyActiveCommunity {
        if (epochId == 0) revert InvalidId("epochId");
        if (validatorRewardEpochFinalized[epochId]) {
            revert ValidatorRewardEpochAlreadyFinalized(epochId);
        }

        uint256 epochReward = rewardAmountByEpoch[epochId];
        if (epochReward == 0) revert ValidatorRewardEpochNotFound(epochId);

        uint256 rewardPerValidator;
        if (activeValidatorCount == 0) {
            // No validator earned this epoch, so the community retains the inflow for execution.
            executionBalance += epochReward;
            validatorRewardBalance -= epochReward;
        } else {
            rewardPerValidator = epochReward / activeValidatorCount;
            uint256 distributableReward = rewardPerValidator * activeValidatorCount;
            uint256 roundingDust = epochReward - distributableReward;

            if (roundingDust != 0) {
                executionBalance += roundingDust;
                validatorRewardBalance -= roundingDust;
            }
        }

        rewardPerValidatorByEpoch[epochId] = rewardPerValidator;
        validatorRewardEpochFinalized[epochId] = true;

        emit ValidatorRewardEpochFinalized(epochId, rewardPerValidator, activeValidatorCount);
    }

    function releaseMembershipStake(
        address member,
        uint256 amount
    ) external override onlyCommunityHub nonReentrant {
        if (member == address(0)) revert ZeroAddress("member");
        if (amount == 0) revert ZeroAmount();
        if (amount > totalMembershipLocked) {
            revert InsufficientMembershipLocked(amount, totalMembershipLocked);
        }

        totalMembershipLocked -= amount;
        usdc.safeTransfer(member, amount);

        emit MembershipStakeReleased(member, amount);
    }

    function depositProposalBond(
        uint256 proposalId,
        address author,
        uint256 amount
    ) external override onlyCommunityHub onlyActiveCommunity {
        if (proposalId == 0) revert InvalidId("proposalId");
        if (author == address(0)) revert ZeroAddress("author");
        if (amount == 0) revert ZeroAmount();
        if (proposalBondById[proposalId] != 0) {
            revert ProposalBondAlreadyDeposited(proposalId);
        }

        usdc.safeTransferFrom(author, address(this), amount);
        proposalBondById[proposalId] = amount;
        totalProposalBondLocked += amount;

        emit ProposalBondDeposited(proposalId, author, amount);
    }

    function claimValidatorReward(
        uint256 epochId
    ) external override hubIsConfigured nonReentrant {
        if (epochId == 0) revert InvalidId("epochId");
        if (!validatorRewardEpochFinalized[epochId]) {
            revert ValidatorRewardEpochNotFinalized(epochId);
        }
        if (validatorRewardClaimed[epochId][msg.sender]) {
            revert ValidatorRewardAlreadyClaimed(epochId, msg.sender);
        }
        if (!ICommunityHub(communityHub).isValidatorActiveForEpoch(epochId, msg.sender)) {
            revert ValidatorNotActiveForEpoch(epochId, msg.sender);
        }

        uint256 rewardAmount = rewardPerValidatorByEpoch[epochId];
        if (rewardAmount == 0) revert ValidatorRewardUnavailable(epochId);

        validatorRewardClaimed[epochId][msg.sender] = true;
        validatorRewardBalance -= rewardAmount;

        usdc.safeTransfer(msg.sender, rewardAmount);

        emit ValidatorRewardClaimed(epochId, msg.sender, rewardAmount);
    }

    function slashProposalBond(
        uint256 proposalId
    ) external override onlyCommunityHub nonReentrant {
        uint256 amount = proposalBondById[proposalId];

        if (amount == 0) revert ProposalBondNotFound(proposalId);
        if (proposalBondSettled[proposalId]) revert ProposalBondAlreadySettled(proposalId);

        proposalBondSettled[proposalId] = true;
        totalProposalBondLocked -= amount;

        usdc.safeTransfer(globalBertReserve, amount);

        emit ProposalBondSlashed(proposalId, amount);
    }

    function returnProposalBond(
        uint256 proposalId,
        address author
    ) external override onlyCommunityHub nonReentrant {
        uint256 amount = proposalBondById[proposalId];

        if (author == address(0)) revert ZeroAddress("author");
        if (amount == 0) revert ProposalBondNotFound(proposalId);
        if (proposalBondSettled[proposalId]) revert ProposalBondAlreadySettled(proposalId);

        proposalBondSettled[proposalId] = true;
        totalProposalBondLocked -= amount;
        usdc.safeTransfer(author, amount);

        emit ProposalBondReturned(proposalId, author, amount);
    }

    function depositVoteStake(
        uint256 proposalId,
        address voter,
        uint256 amount
    ) external override onlyCommunityHub onlyActiveCommunity {
        if (proposalId == 0) revert InvalidId("proposalId");
        if (voter == address(0)) revert ZeroAddress("voter");
        if (amount == 0) revert ZeroAmount();
        if (binaryVoteSettled[proposalId]) revert ProposalAlreadySettled(proposalId);

        usdc.safeTransferFrom(voter, address(this), amount);
        totalVoteEscrow += amount;
        voteEscrowByProposal[proposalId] += amount;

        emit VoteStakeDeposited(proposalId, voter, amount);
    }

    function settleBinaryYesWin(
        uint256 proposalId,
        uint256 yesStake,
        uint256 noStake,
        uint256 epochId
    ) external override onlyCommunityHub onlyActiveCommunity nonReentrant {
        if (proposalId == 0) revert InvalidId("proposalId");
        if (binaryVoteSettled[proposalId]) revert ProposalAlreadySettled(proposalId);
        if (yesStake <= noStake) {
            revert InvalidBinarySettlement(proposalId, yesStake, noStake);
        }

        uint256 totalStake = yesStake + noStake;
        uint256 proposalEscrow = voteEscrowByProposal[proposalId];
        if (proposalEscrow != totalStake) {
            revert VoteEscrowMismatch(proposalId, proposalEscrow, totalStake);
        }

        uint256 rewardShareBps = ICommunityHub(communityHub).validatorRewardShareBps();
        if (rewardShareBps > 10_000) revert InvalidCommunityConfig("validatorRewardShareBps");

        uint256 validatorReward = (yesStake * rewardShareBps) / 10_000;
        uint256 executionAmount = yesStake - validatorReward;

        binaryVoteSettled[proposalId] = true;
        voteEscrowByProposal[proposalId] = 0;
        totalVoteEscrow -= totalStake;
        executionBalance += executionAmount;
        validatorRewardBalance += validatorReward;
        rewardAmountByEpoch[epochId] += validatorReward;

        if (noStake != 0) {
            usdc.safeTransfer(globalBertReserve, noStake);
        }

        emit BinaryYesWinSettled(proposalId, executionAmount, validatorReward, noStake);
    }

    function settleBinaryNoWin(
        uint256 proposalId,
        uint256 yesStake,
        uint256 noStake,
        uint256 feeBps
    ) external override onlyCommunityHub onlyActiveCommunity nonReentrant {
        if (proposalId == 0) revert InvalidId("proposalId");
        if (binaryVoteSettled[proposalId]) revert ProposalAlreadySettled(proposalId);
        if (noStake < yesStake) {
            revert InvalidBinarySettlement(proposalId, yesStake, noStake);
        }
        if (feeBps > 1_000) revert RejectionFeeTooHigh(feeBps, 1_000);

        uint256 totalStake = yesStake + noStake;
        uint256 proposalEscrow = voteEscrowByProposal[proposalId];
        if (proposalEscrow != totalStake) {
            revert VoteEscrowMismatch(proposalId, proposalEscrow, totalStake);
        }

        uint256 rejectionFee = (noStake * feeBps) / 10_000;
        uint256 refundLiability = noStake - rejectionFee;
        uint256 globalReserveAmount = yesStake + rejectionFee;

        binaryVoteSettled[proposalId] = true;
        noWonByProposal[proposalId] = true;
        rejectionFeeBpsByProposal[proposalId] = feeBps;
        voteEscrowByProposal[proposalId] = 0;
        totalVoteEscrow -= totalStake;
        totalRefundLiability += refundLiability;

        if (globalReserveAmount != 0) {
            usdc.safeTransfer(globalBertReserve, globalReserveAmount);
        }

        emit BinaryNoWinSettled(proposalId, refundLiability, globalReserveAmount);
    }

    function claimNoVoteRefund(
        uint256 proposalId
    ) external override nonReentrant hubIsConfigured {
        if (proposalId == 0) revert InvalidId("proposalId");
        if (!binaryVoteSettled[proposalId] || !noWonByProposal[proposalId]) {
            revert RefundNotAvailable(proposalId, msg.sender);
        }
        if (refundClaimed[proposalId][msg.sender]) {
            revert RefundAlreadyClaimed(proposalId, msg.sender);
        }

        (CommunityTypes.VoteChoice choice, uint256 stake) = ICommunityHub(communityHub)
            .getBinaryVote(proposalId, msg.sender);
        if (choice != CommunityTypes.VoteChoice.No || stake == 0) {
            revert RefundNotAvailable(proposalId, msg.sender);
        }

        uint256 refundAmount = stake - ((stake * rejectionFeeBpsByProposal[proposalId]) / 10_000);
        if (refundAmount > totalRefundLiability) {
            revert RefundNotAvailable(proposalId, msg.sender);
        }

        refundClaimed[proposalId][msg.sender] = true;
        totalRefundLiability -= refundAmount;

        usdc.safeTransfer(msg.sender, refundAmount);

        emit RefundClaimed(proposalId, msg.sender, refundAmount);
    }

    function createWithdrawalRequest(
        address to,
        uint256 amount,
        string calldata reason,
        string calldata metadataURI
    ) external override onlyCommunityAdmin onlyActiveCommunity {
        if (to == address(0)) revert ZeroAddress("to");
        if (amount == 0) revert ZeroAmount();
        if (bytes(reason).length == 0) revert InvalidParameter("reason", "empty");

        uint256 availableBalance = availableExecutionBalance();
        if (amount > availableBalance) {
            revert InsufficientExecutionBalance(amount, availableBalance);
        }

        uint256 requestId = ++withdrawalRequestCount;
        CommunityTypes.WithdrawalRequest storage request = withdrawalRequests[requestId];
        request.to = to;
        request.createdBy = msg.sender;
        request.createdAt = uint64(block.timestamp);
        request.amount = amount;
        request.approvalCount = 1;
        request.reason = reason;
        request.metadataURI = metadataURI;

        withdrawalApprovedBy[requestId][msg.sender] = true;
        reservedExecutionBalance += amount;

        emit WithdrawalRequestCreated(requestId, msg.sender, to, amount, reason, metadataURI);
        emit WithdrawalApproved(requestId, msg.sender);
    }

    function approveWithdrawal(
        uint256 requestId
    ) external override onlyCommunityAdmin onlyActiveCommunity {
        CommunityTypes.WithdrawalRequest storage request = _getWithdrawalRequest(requestId);
        if (request.executed) revert WithdrawalAlreadyExecuted(requestId);
        if (request.cancelled) revert WithdrawalAlreadyCancelled(requestId);
        if (withdrawalApprovedBy[requestId][msg.sender]) {
            revert WithdrawalAlreadyApproved(requestId, msg.sender);
        }

        withdrawalApprovedBy[requestId][msg.sender] = true;
        request.approvalCount += 1;

        emit WithdrawalApproved(requestId, msg.sender);
    }

    function cancelWithdrawalRequest(
        uint256 requestId
    ) external override onlyCommunityAdmin {
        CommunityTypes.WithdrawalRequest storage request = _getWithdrawalRequest(requestId);
        if (request.executed) revert WithdrawalAlreadyExecuted(requestId);
        if (request.cancelled) revert WithdrawalAlreadyCancelled(requestId);

        request.cancelled = true;
        reservedExecutionBalance -= request.amount;

        emit WithdrawalCancelled(requestId, msg.sender);
    }

    function executeWithdrawal(
        uint256 requestId
    ) external override onlyCommunityAdmin onlyActiveCommunity nonReentrant {
        CommunityTypes.WithdrawalRequest storage request = _getWithdrawalRequest(requestId);
        if (request.executed) revert WithdrawalAlreadyExecuted(requestId);
        if (request.cancelled) revert WithdrawalAlreadyCancelled(requestId);

        uint256 threshold = ICommunityHub(communityHub).adminApprovalThreshold();
        if (request.approvalCount < threshold) {
            revert WithdrawalApprovalThresholdNotMet(requestId, request.approvalCount, threshold);
        }
        if (request.amount > executionBalance) {
            revert InsufficientExecutionBalance(request.amount, executionBalance);
        }

        request.executed = true;
        reservedExecutionBalance -= request.amount;
        executionBalance -= request.amount;

        usdc.safeTransfer(request.to, request.amount);

        emit WithdrawalExecuted(requestId, request.to, request.amount);
    }

    function availableExecutionBalance() public view override returns (uint256) {
        return executionBalance - reservedExecutionBalance;
    }

    function getWithdrawalRequest(
        uint256 requestId
    ) external view override returns (CommunityTypes.WithdrawalRequest memory) {
        return _getWithdrawalRequest(requestId);
    }

    function hasApprovedWithdrawal(
        uint256 requestId,
        address admin
    ) external view override returns (bool) {
        return withdrawalApprovedBy[requestId][admin];
    }

    function getProposalBond(
        uint256 proposalId
    ) external view override returns (uint256 amount, bool settled) {
        return (proposalBondById[proposalId], proposalBondSettled[proposalId]);
    }

    function getRefundPreview(
        uint256 proposalId,
        address voter
    ) external view override hubIsConfigured returns (uint256, bool) {
        if (
            proposalId == 0 ||
            voter == address(0) ||
            !binaryVoteSettled[proposalId] ||
            !noWonByProposal[proposalId] ||
            refundClaimed[proposalId][voter]
        ) {
            return (0, false);
        }

        (CommunityTypes.VoteChoice choice, uint256 stake) = ICommunityHub(communityHub)
            .getBinaryVote(proposalId, voter);
        if (choice != CommunityTypes.VoteChoice.No || stake == 0) {
            return (0, false);
        }

        uint256 refundAmount = stake - ((stake * rejectionFeeBpsByProposal[proposalId]) / 10_000);
        return (refundAmount, refundAmount <= totalRefundLiability);
    }

    function setCommunityHub(address communityHub_) external override onlyFactory {
        if (communityHub != address(0)) revert CommunityHubAlreadyConfigured();
        if (communityHub_ == address(0)) revert ZeroAddress("communityHub");

        communityHub = communityHub_;

        emit CommunityHubConfigured(communityHub_);
    }

    function _getWithdrawalRequest(
        uint256 requestId
    ) private view returns (CommunityTypes.WithdrawalRequest storage request) {
        if (requestId == 0 || requestId > withdrawalRequestCount) {
            revert WithdrawalRequestNotFound(requestId);
        }

        return withdrawalRequests[requestId];
    }
}
