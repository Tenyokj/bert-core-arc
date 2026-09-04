// SPDX-License-Identifier: GPL-3.0
/**
 * @notice BERT V3 Community Layer shared type definitions.
 * @dev This file is a namespace only and never stores funds or mutable protocol state.
 */

pragma solidity ^0.8.20;

/// @title CommunityTypes
/// @notice Shared V3 data shapes used by CommunityFactory, CommunityHub, and CommunityTreasury.
/// @dev This library is a namespace only. It has no storage, executable business logic, or access control.
library CommunityTypes {
    /// @notice Lifecycle state of a community.
    enum CommunityStatus {
        /// @notice Community accepts normal governance and treasury actions.
        Active,
        /// @notice New governance actions are blocked while previously earned claims remain available.
        Paused,
        /// @notice Community is permanently closed to new governance activity.
        Archived
    }

    /// @notice Identifies which proposal lane owns a proposal.
    enum ProposalOrigin {
        /// @notice Proposal was created by a community-local admin.
        Admin,
        /// @notice Proposal was submitted by an active community member.
        Member
    }

    /// @notice Lifecycle state for the binary-proposal MVP.
    enum ProposalStatus {
        /// @notice Member proposal is awaiting validator decisions.
        PendingValidation,
        /// @notice Member proposal failed its validator gate.
        RejectedByValidators,
        /// @notice Proposal is eligible for an admin to open voting.
        ApprovedForVoting,
        /// @notice Members may currently commit stake to YES or NO.
        InVoting,
        /// @notice YES received strictly more stake than NO.
        Accepted,
        /// @notice NO received at least as much stake as YES.
        Rejected,
        /// @notice Treasury settlement for the terminal vote outcome is complete.
        Settled
    }

    /// @notice A member's side in binary voting.
    enum VoteChoice {
        /// @notice No vote was recorded for the member and proposal.
        None,
        /// @notice Member committed stake in support of the proposal.
        Yes,
        /// @notice Member committed stake against the proposal.
        No
    }

    /// @notice Per-community configuration selected when the community is created.
    /// @dev USDC values use the asset's native units. Arc USDC uses 6 decimals.
    struct CommunityConfig {
        /// @notice Display name shown to community members.
        string name;
        /// @notice Offchain metadata describing the community.
        string metadataURI;
        /// @notice USDC-compatible asset used by all local flows.
        address usdc;
        /// @notice Existing BERT reserve receiver for protocol-level inflows.
        address globalBertReserve;
        /// @notice Initial local admin addresses.
        address[] initialAdmins;
        /// @notice Initial local validator addresses, disjoint from admins.
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
        /// @notice Whether the member can currently propose and vote.
        bool active;
        uint64 joinedAt;
        uint64 exitRequestedAt;
        uint256 membershipStake;
        uint256 proposalPoints;
    }

    /// @notice Onchain metadata and lifecycle state for one binary proposal.
    /// @dev Validator choices and voter choices live in mappings on CommunityHub, not in this struct.
    struct Proposal {
        /// @notice Address that created the proposal.
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
        /// @notice Inclusive timestamp at which validator activity starts counting.
        uint64 startTime;
        uint64 endTime;
        uint256 availableValidationCases;
        uint256 rewardAmount;
        uint256 activeValidatorCount;
        bool finalized;
    }

    /// @notice A withdrawal proposal from the community execution balance.
    struct WithdrawalRequest {
        /// @notice USDC recipient after quorum execution.
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
