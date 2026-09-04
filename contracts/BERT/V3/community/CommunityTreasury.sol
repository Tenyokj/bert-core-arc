// SPDX-License-Identifier: GPL-3.0
/**
 * @notice BERT V3 Community Layer.
 * @dev This contract isolates community USDC custody from CommunityHub governance state.
 */
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

    /// @notice USDC-compatible asset accepted by this community treasury.
    IERC20 public immutable usdc;
    /// @notice Existing BERT V2 reserve receiver for protocol-level inflows.
    address public immutable globalBertReserve;
    /// @notice Factory allowed to bind this treasury to one CommunityHub instance.
    address public immutable factory;
    /// @notice Paired Hub that authorizes governance-originated fund flows.
    address public communityHub;

    /// @notice Refundable member stakes; never spendable as execution funds.
    uint256 public totalMembershipLocked;
    /// @notice Funds available for approved community execution.
    uint256 public executionBalance;
    /// @notice Unclaimed rewards accrued by active validators.
    uint256 public validatorRewardBalance;
    /// @notice Votes-USDC awaiting settlement across active binary proposals.
    uint256 public totalVoteEscrow;
    /// @notice Funds reserved for NO-voter refund claims.
    uint256 public totalRefundLiability;
    /// @notice Portion of executionBalance already reserved by pending withdrawals.
    uint256 public reservedExecutionBalance;
    /// @notice Proposal bonds not yet returned or routed to the global reserve.
    uint256 public totalProposalBondLocked;

    /// @notice Bond amount recorded for each member proposal.
    mapping(uint256 proposalId => uint256 amount) public proposalBondById;
    mapping(uint256 proposalId => bool settled) public proposalBondSettled;

    /// @notice Whether a binary proposal's vote escrow has already been settled.
    mapping(uint256 proposalId => bool settled) public binaryVoteSettled;
    mapping(uint256 proposalId => uint256 feeBps) public rejectionFeeBpsByProposal;

    mapping(uint256 epochId => uint256 amount) public rewardAmountByEpoch;
    mapping(uint256 epochId => uint256 amount) public rewardPerValidatorByEpoch;

    /// @notice Prevents a validator from claiming the same epoch reward twice.
    mapping(uint256 epochId => mapping(address validator => bool claimed)) public validatorRewardClaimed;

    /// @notice Voting USDC escrowed for a single proposal until its terminal outcome.
    mapping(uint256 proposalId => uint256 amount) public voteEscrowByProposal;
    mapping(uint256 proposalId => bool noWonByProposal) public noWonByProposal;
    mapping(uint256 epochId => bool finalized) public validatorRewardEpochFinalized;

    /// @notice Prevents a voter from claiming the same NO-side refund twice.
    mapping(uint256 proposalId => mapping(address voter => bool claimed)) public refundClaimed;

    /// @notice Monotonic identifier for withdrawal requests, starting at one.
    uint256 public withdrawalRequestCount;

    /// @dev Full withdrawal records are exposed through getWithdrawalRequest.
    mapping(uint256 requestId => CommunityTypes.WithdrawalRequest) private withdrawalRequests;

    /// @notice Tracks which admins approved each withdrawal request.
    mapping(uint256 requestId => mapping(address admin => bool)) public withdrawalApprovedBy;

    /// @notice Creates an unlinked treasury that a factory binds to a Hub exactly once.
    /// @param usdc_ USDC-compatible asset for all community flows.
    /// @param globalBertReserve_ Global BERT reserve receiver.
    /// @param factory_ Factory permitted to link the Hub.
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

    /// @notice Restricts a function to the deploying factory.
    modifier onlyFactory() {
        if (msg.sender != factory) revert NotCommunityFactory(msg.sender);
        _;
    }

    /// @notice Restricts a function to the configured CommunityHub.
    modifier onlyCommunityHub() {
        if (communityHub == address(0)) revert CommunityHubNotConfigured();
        if (msg.sender != communityHub) revert NotCommunityHub(msg.sender);
        _;
    }

    /// @notice Restricts a function to a current community-local admin.
    modifier onlyCommunityAdmin() {
        if (communityHub == address(0)) revert CommunityHubNotConfigured();
        if (!ICommunityHub(communityHub).isAdminAccount(msg.sender)) {
            revert NotCommunityAdmin(msg.sender);
        }
        _;
    }

    /// @notice Restricts governance-changing actions to an active community.
    modifier onlyActiveCommunity() {
        if (communityHub == address(0)) revert CommunityHubNotConfigured();
        if (
            ICommunityHub(communityHub).communityStatus() != CommunityTypes.CommunityStatus.Active
        ) {
            revert CommunityNotActive();
        }
        _;
    }

    /// @notice Requires a factory-linked Hub before querying community state.
    modifier hubIsConfigured() {
        if (communityHub == address(0)) revert CommunityHubNotConfigured();
        _;
    }

    /// @notice Pulls and locks a member's refundable entry stake.
    /// @param member Member whose USDC allowance is consumed.
    /// @param amount USDC amount in token-native units.
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

    /// @notice Finalizes equal validator rewards for one epoch.
    /// @dev Rounding dust, or all rewards when no validator is active, returns to executionBalance.
    /// @param epochId Epoch to finalize.
    /// @param activeValidatorCount Validators eligible to claim in the epoch.
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

    /// @notice Releases a member stake after CommunityHub exit checks pass.
    /// @param member Recipient of the returned USDC.
    /// @param amount USDC amount in token-native units.
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

    /// @notice Pulls and records the anti-spam bond for a member proposal.
    /// @param proposalId Proposal that owns the bond.
    /// @param author Proposal author whose USDC allowance is consumed.
    /// @param amount USDC bond amount in token-native units.
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

    /// @notice Allows an active validator to claim one finalized epoch reward.
    /// @param epochId Finalized reward epoch to claim.
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

    /// @notice Routes a validator-rejected member proposal bond to the global BERT reserve.
    /// @param proposalId Proposal whose bond should be slashed.
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

    /// @notice Returns a proposal bond after a fair community voting outcome.
    /// @param proposalId Proposal whose bond should be returned.
    /// @param author Recipient proposal author.
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

    /// @notice Pulls USDC committed by a member to a binary vote.
    /// @param proposalId Proposal receiving the vote stake.
    /// @param voter Member whose USDC allowance is consumed.
    /// @param amount USDC vote stake in token-native units.
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

    /// @notice Settles a YES-winning binary proposal.
    /// @dev YES stake splits between execution and validator rewards; NO stake routes to global reserve.
    /// @param proposalId Settled proposal.
    /// @param yesStake Total USDC committed to YES.
    /// @param noStake Total USDC committed to NO.
    /// @param epochId Validator reward epoch receiving the reward share.
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

    /// @notice Settles a NO-winning or tied binary proposal.
    /// @dev YES stake and the NO-side fee route to global reserve; remaining NO stake becomes claimable.
    /// @param proposalId Settled proposal.
    /// @param yesStake Total USDC committed to YES.
    /// @param noStake Total USDC committed to NO.
    /// @param feeBps NO-side fee in basis points.
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

    /// @notice Claims a NO-side refund after a rejected binary proposal.
    /// @param proposalId Rejected proposal whose refund is claimed.
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

    /// @notice Creates an execution withdrawal request and records the creator's first approval.
    /// @param to Recipient of the USDC withdrawal.
    /// @param amount Requested USDC amount in token-native units.
    /// @param reason Human-readable execution reason.
    /// @param metadataURI Offchain evidence or implementation metadata.
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

    /// @notice Adds the caller's approval to a pending withdrawal request.
    /// @param requestId Withdrawal request identifier.
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

    /// @notice Cancels a pending request and releases its execution reservation.
    /// @param requestId Withdrawal request identifier.
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

    /// @notice Executes a reserved withdrawal after the configured admin quorum is reached.
    /// @param requestId Withdrawal request identifier.
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

    /// @notice Returns execution USDC not already reserved by pending withdrawals.
    function availableExecutionBalance() public view override returns (uint256) {
        return executionBalance - reservedExecutionBalance;
    }

    /// @notice Returns one full withdrawal request record.
    /// @param requestId Withdrawal request identifier.
    function getWithdrawalRequest(
        uint256 requestId
    ) external view override returns (CommunityTypes.WithdrawalRequest memory) {
        return _getWithdrawalRequest(requestId);
    }

    /// @notice Reports whether an admin approved a withdrawal request.
    /// @param requestId Withdrawal request identifier.
    /// @param admin Admin address to inspect.
    function hasApprovedWithdrawal(
        uint256 requestId,
        address admin
    ) external view override returns (bool) {
        return withdrawalApprovedBy[requestId][admin];
    }

    /// @notice Returns the recorded amount and settlement state of a proposal bond.
    /// @param proposalId Proposal identifier.
    function getProposalBond(
        uint256 proposalId
    ) external view override returns (uint256 amount, bool settled) {
        return (proposalBondById[proposalId], proposalBondSettled[proposalId]);
    }

    /// @notice Calculates a voter's current NO-side refund without changing state.
    /// @param proposalId Rejected binary proposal.
    /// @param voter Address to inspect.
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

    /// @notice Permanently links this treasury to the Hub deployed by its factory.
    /// @param communityHub_ Hub authorized to call governance fund-flow methods.
    function setCommunityHub(address communityHub_) external override onlyFactory {
        if (communityHub != address(0)) revert CommunityHubAlreadyConfigured();
        if (communityHub_ == address(0)) revert ZeroAddress("communityHub");

        communityHub = communityHub_;

        emit CommunityHubConfigured(communityHub_);
    }

    /// @dev Returns a request storage pointer after validating that it was created.
    /// @param requestId Withdrawal request identifier.
    function _getWithdrawalRequest(
        uint256 requestId
    ) private view returns (CommunityTypes.WithdrawalRequest storage request) {
        if (requestId == 0 || requestId > withdrawalRequestCount) {
            revert WithdrawalRequestNotFound(requestId);
        }

        return withdrawalRequests[requestId];
    }
}
