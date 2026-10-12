// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {CommunityTypes} from "./CommunityTypes.sol";
import "../../utils/Errors.sol";
import "../utils/CommunityErrors.sol";

/**
 * @title ICommunityAdminActionTarget
 * @notice Minimal Hub surface used by the quorum-control library through delegatecall.
 * @dev Calls made by this library target address(this), which is the CommunityHub during execution.
 */
interface ICommunityAdminActionTarget {
    function communityStatus() external view returns (CommunityTypes.CommunityStatus);
    function communityTime() external view returns (uint64);
    function adminApprovalThreshold() external view returns (uint256);
    function executeAdminAction(
        CommunityTypes.AdminActionType action,
        address target,
        uint256 value
    ) external;
}

/**
 * @title CommunityAdminActions
 * @notice Linked quorum engine for security-sensitive BERT V3 Community operations.
 * @dev Uses an isolated unstructured-storage slot inside each calling CommunityHub. Keeping this
 * logic linked avoids pushing every Hub above EVM's 24 KiB runtime-code limit while requests,
 * approvals, and emitted events still belong to the Hub address through delegatecall.
 */
library CommunityAdminActions {
    /** @notice Community-clock lifetime of a pending protected action request. */
    uint64 internal constant REQUEST_DURATION = 7 days;
    /** @notice Fixed storage slot dedicated to one Hub's control-plane request state. */
    bytes32 private constant STORAGE_SLOT = keccak256("bert.v3.community.admin-actions.storage.v1");

    /** @notice Per-Hub storage layout accessed only through STORAGE_SLOT. */
    struct Layout {
        uint256 requestCount;
        mapping(uint256 => CommunityTypes.AdminActionRequest) requests;
        mapping(uint256 => mapping(address => bool)) approvedBy;
        mapping(uint256 => uint256) cancellationActionByWithdrawalRequest;
    }

    /** @notice Emitted from the calling CommunityHub when a protected action is requested. */
    event AdminActionRequested(
        uint256 indexed requestId,
        CommunityTypes.AdminActionType action,
        address indexed proposer,
        address indexed target,
        uint256 value,
        uint256 expiresAt
    );
    /** @notice Emitted from the calling CommunityHub when an Admin approves a protected action. */
    event AdminActionApproved(uint256 indexed requestId, address indexed admin);
    /** @notice Emitted from the calling CommunityHub when its proposer cancels an action. */
    event AdminActionCancelled(uint256 indexed requestId, address indexed proposer);
    /** @notice Emitted from the calling CommunityHub after a quorum-approved action executes. */
    event AdminActionExecuted(
        uint256 indexed requestId,
        CommunityTypes.AdminActionType action,
        address indexed executor
    );

    /**
     * @notice Opens a protected action and records the caller's first approval.
     * @param action Security-sensitive operation to execute after quorum.
     * @param target Role recipient or role holder; zero for non-role actions.
     * @param value Withdrawal request ID for CancelWithdrawal; zero otherwise.
     * @return requestId Newly created action request identifier.
     */
    function create(
        CommunityTypes.AdminActionType action,
        address target,
        uint256 value
    ) external returns (uint256 requestId) {
        _requireActionState(action);
        _validateParameters(action, target, value);

        Layout storage state = _layout();
        uint64 createdAt = ICommunityAdminActionTarget(address(this)).communityTime();
        if (action == CommunityTypes.AdminActionType.CancelWithdrawal) {
            uint256 existingRequestId = state.cancellationActionByWithdrawalRequest[value];
            if (existingRequestId != 0) {
                CommunityTypes.AdminActionRequest storage existingRequest = state.requests[existingRequestId];
                if (!existingRequest.executed && createdAt < existingRequest.expiresAt) {
                    revert WithdrawalCancellationAlreadyRequested(value, existingRequestId);
                }
                delete state.cancellationActionByWithdrawalRequest[value];
            }
        }
        requestId = ++state.requestCount;
        CommunityTypes.AdminActionRequest storage request = state.requests[requestId];
        request.action = action;
        request.target = target;
        request.value = value;
        request.expiresAt = createdAt + REQUEST_DURATION;
        request.approvalCount = 1;
        state.approvedBy[requestId][msg.sender] = true;
        if (action == CommunityTypes.AdminActionType.CancelWithdrawal) {
            state.cancellationActionByWithdrawalRequest[value] = requestId;
        }

        emit AdminActionRequested(requestId, action, msg.sender, target, value, request.expiresAt);
        emit AdminActionApproved(requestId, msg.sender);
    }

    /**
     * @notice Adds the caller's approval to a pending protected action.
     * @param requestId Existing request identifier.
     */
    function approve(uint256 requestId) external {
        CommunityTypes.AdminActionRequest storage request = _openRequest(requestId);
        Layout storage state = _layout();
        if (state.approvedBy[requestId][msg.sender]) {
            revert AdminActionAlreadyApproved(requestId, msg.sender);
        }

        state.approvedBy[requestId][msg.sender] = true;
        request.approvalCount += 1;
        emit AdminActionApproved(requestId, msg.sender);
    }

    /**
     * @notice Executes an action after the Hub's immutable Admin quorum is met.
     * @param requestId Existing request identifier.
     */
    function execute(uint256 requestId) external {
        CommunityTypes.AdminActionRequest storage request = _openRequest(requestId);
        uint256 threshold = ICommunityAdminActionTarget(address(this)).adminApprovalThreshold();
        if (request.approvalCount < threshold) {
            revert AdminActionApprovalThresholdNotMet(requestId, request.approvalCount, threshold);
        }

        _requireActionState(request.action);
        request.executed = true;
        ICommunityAdminActionTarget(address(this)).executeAdminAction(
            request.action,
            request.target,
            request.value
        );
        if (request.action == CommunityTypes.AdminActionType.CancelWithdrawal) {
            delete _layout().cancellationActionByWithdrawalRequest[request.value];
        }
        emit AdminActionExecuted(requestId, request.action, msg.sender);
    }

    /** @notice Resolves the isolated request storage for the calling CommunityHub. */
    function _layout() private pure returns (Layout storage state) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            state.slot := slot
        }
    }

    /** @notice Returns a request that is neither terminal nor expired on the Community clock. */
    function _openRequest(uint256 requestId)
        private
        view
        returns (CommunityTypes.AdminActionRequest storage request)
    {
        Layout storage state = _layout();
        if (requestId == 0 || requestId > state.requestCount) {
            revert AdminActionRequestNotFound(requestId);
        }
        request = state.requests[requestId];
        if (request.executed) revert AdminActionRequestClosed(requestId);
        if (ICommunityAdminActionTarget(address(this)).communityTime() >= request.expiresAt) {
            revert AdminActionRequestExpired(requestId);
        }
    }

    /** @notice Enforces the Hub lifecycle compatible with one protected action. */
    function _requireActionState(CommunityTypes.AdminActionType action) private view {
        CommunityTypes.CommunityStatus status = ICommunityAdminActionTarget(address(this)).communityStatus();
        if (action == CommunityTypes.AdminActionType.Unpause) {
            if (status != CommunityTypes.CommunityStatus.Paused) revert CommunityNotActive();
            return;
        }
        if (action == CommunityTypes.AdminActionType.CancelWithdrawal) {
            if (status == CommunityTypes.CommunityStatus.Archived) revert CommunityIsArchived();
            return;
        }
        if (status == CommunityTypes.CommunityStatus.Paused) revert CommunityIsPaused();
        if (status == CommunityTypes.CommunityStatus.Archived) revert CommunityIsArchived();
    }

    /** @notice Validates the target/value representation of a protected action. */
    function _validateParameters(
        CommunityTypes.AdminActionType action,
        address target,
        uint256 value
    ) private pure {
        bool roleAction =
            action == CommunityTypes.AdminActionType.AddAdmin ||
            action == CommunityTypes.AdminActionType.RemoveAdmin ||
            action == CommunityTypes.AdminActionType.AddValidator ||
            action == CommunityTypes.AdminActionType.RemoveValidator;
        if (roleAction) {
            if (target == address(0) || value != 0) revert InvalidAdminActionParameters();
            return;
        }
        if (action == CommunityTypes.AdminActionType.CancelWithdrawal) {
            if (target != address(0) || value == 0) revert InvalidAdminActionParameters();
            return;
        }
        if (target != address(0) || value != 0) revert InvalidAdminActionParameters();
    }
}
