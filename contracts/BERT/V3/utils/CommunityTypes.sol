// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

/// @title CommunityTypes
/// @notice Shared V3 data shapes used by CommunityFactory, CommunityHub, and CommunityTreasury.
/// @dev This library is a namespace only. It has no storage, executable business logic, or access control.
library CommunityTypes {
    /// @notice Lifecycle state of a community.
    enum CommunityStatus {
        Active,
        Paused,
        Archived
    }

    /// @notice Identifies which proposal lane owns a proposal.
    enum ProposalOrigin {
        Admin,
        Member
    }

    /// @notice Lifecycle state for the binary-proposal MVP.
    enum ProposalStatus {
        PendingValidation,
        RejectedByValidators,
        ApprovedForVoting,
        InVoting,
        Accepted,
        Rejected,
        Settled
    }

    /// @notice A member's side in binary voting.
    enum VoteChoice {
        None,
        Yes,
        No
    }

    /// @notice Per-community configuration selected when the community is created.
    /// @dev USDC values use the asset's native units. Arc USDC uses 6 decimals.
    struct CommunityConfig {
        string name;
        string metadataURI;
        address usdc;
        address globalBertReserve;
        address[] initialAdmins;
        address[] initialValidators;
        uint256 entryStakeUSDC;
        uint256 proposalBondUSDC;
        uint256 voteMinStakeUSDC;
        uint256 membershipExitCooldown;
        uint256 validatorApprovalThreshold;
        uint256 adminApprovalThreshold;
        uint256 binaryRejectionFeeBps;
        uint256 validatorRewardShareBps;
        uint256 validationWindow;
        uint256 binaryVotingDuration;
        uint256 validatorRewardEpoch;
        uint256 validatorActiveThresholdBps;
    }

    /// @notice Membership state maintained by CommunityHub for one account.
    struct MemberInfo {
        bool active;
        uint64 joinedAt;
        uint64 exitRequestedAt;
        uint256 membershipStake;
        uint256 proposalPoints;
    }

    /// @notice Onchain metadata and lifecycle state for one binary proposal.
    /// @dev Validator choices and voter choices live in mappings on CommunityHub, not in this struct.
    struct Proposal {
        address creator;
        ProposalOrigin origin;
        ProposalStatus status;
        string title;
        string description;
        string metadataURI;
        uint64 createdAt;
        uint64 validationDeadline;
        uint64 votingStartedAt;
        uint64 votingDeadline;
        uint256 bondAmount;
        uint256 yesVotes;
        uint256 noVotes;
        uint256 approvalCount;
        uint256 rejectionCount;
        bool settled;
    }

    /// @notice Accounting snapshot for one validator-reward epoch.
    /// @dev Per-validator participation and claims are stored in mappings in CommunityHub and CommunityTreasury.
    struct ValidatorRewardEpoch {
        uint64 startTime;
        uint64 endTime;
        uint256 availableValidationCases;
        uint256 rewardAmount;
        uint256 activeValidatorCount;
        bool finalized;
    }

    /// @notice A withdrawal proposal from the community execution balance.
    struct WithdrawalRequest {
        address to;
        address createdBy;
        uint64 createdAt;
        uint256 amount;
        uint256 approvalCount;
        string reason;
        string metadataURI;
        bool executed;
        bool cancelled;
    }
}