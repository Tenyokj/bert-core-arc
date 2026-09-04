// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

// Generic errors such as ZeroAddress, ZeroAmount, InvalidId, and InvalidParameter
// remain defined in contracts/BERT/utils/Errors.sol and are imported by V3 contracts.

// ========== Community State And Roles ==========

/// @notice The requested action requires an active community.
error CommunityNotActive();

/// @notice The requested action is unavailable while the community is paused.
error CommunityIsPaused();

/// @notice The requested action is unavailable after a community is archived.
error CommunityIsArchived();

/// @notice The caller does not hold the community-local admin role.
/// @param account Address that attempted the admin-only action.
error NotCommunityAdmin(address account);

/// @notice The caller does not hold the community-local validator role.
/// @param account Address that attempted the validator-only action.
error NotCommunityValidator(address account);

/// @notice The caller is not an active member of this community.
/// @param account Address that attempted the member-only action.
error NotCommunityMember(address account);

/// @notice An address is already an active member.
/// @param account Existing member address.
error AlreadyCommunityMember(address account);

/// @notice An address cannot hold the admin and validator roles in one community.
/// @param account Address that would violate the role-separation invariant.
error AdminValidatorRoleConflict(address account);

/// @notice A role-management action attempted to add an address that already has that role.
/// @param account Address that is already assigned.
error RoleAlreadyAssigned(address account);

/// @notice A role-management action referenced an address without that role.
/// @param account Address that is not assigned to the required role.
error RoleNotAssigned(address account);

/// @notice Removing an admin would leave the community without an admin.
error CannotRemoveLastAdmin();

/// @notice A community configuration value is outside its permitted range.
/// @param field Configuration field name.
error InvalidCommunityConfig(string field);

/// @notice The rejection fee exceeds the protocol's hard cap.
/// @param feeBps Requested fee in basis points.
/// @param maxFeeBps Maximum permitted fee in basis points.
error RejectionFeeTooHigh(uint256 feeBps, uint256 maxFeeBps);

// ========== Membership ==========

/// @notice The supplied membership stake is below the community minimum.
/// @param supplied Amount supplied by the member.
/// @param required Minimum amount configured for the community.
error MembershipStakeTooLow(uint256 supplied, uint256 required);

/// @notice A member has not started the exit process.
/// @param account Member address.
error ExitNotRequested(address account);

/// @notice A member attempted to finalize exit before the cooldown ended.
/// @param availableAt Timestamp at which exit becomes available.
error ExitCooldownNotFinished(uint256 availableAt);

/// @notice A member has an unresolved governance obligation and cannot exit yet.
/// @param account Member address.
error MembershipExitBlocked(address account);

// ========== Proposal And Validation ==========

/// @notice A referenced proposal ID does not exist.
/// @param proposalId Proposal identifier.
error CommunityProposalNotFound(uint256 proposalId);

/// @notice A proposal is not in the required lifecycle state.
/// @param proposalId Proposal identifier.
error InvalidProposalState(uint256 proposalId);

/// @notice The caller already recorded a validator decision for this proposal.
/// @param proposalId Proposal identifier.
/// @param validator Validator address.
error ValidatorDecisionAlreadyCast(uint256 proposalId, address validator);

/// @notice The validator decision window has closed.
/// @param proposalId Proposal identifier.
error ValidationWindowClosed(uint256 proposalId);

/// @notice Validation cannot be finalized until its configured deadline.
/// @param proposalId Proposal identifier.
/// @param availableAt Timestamp at which finalization becomes available.
error ValidationStillOpen(uint256 proposalId, uint256 availableAt);

// ========== Binary Voting ==========

/// @notice A proposal's binary voting window has not been opened.
/// @param proposalId Proposal identifier.
error VotingNotOpen(uint256 proposalId);

/// @notice The binary voting deadline has passed.
/// @param proposalId Proposal identifier.
error VotingWindowClosed(uint256 proposalId);

/// @notice A member can cast only one binary vote for a proposal.
/// @param proposalId Proposal identifier.
/// @param voter Member address.
error BinaryVoteAlreadyCast(uint256 proposalId, address voter);

/// @notice The supplied voting stake is below the community minimum.
/// @param supplied Amount supplied by the voter.
/// @param required Community minimum vote amount.
error VoteStakeTooLow(uint256 supplied, uint256 required);

/// @notice A binary vote choice must be Yes or No, never None.
error InvalidVoteChoice();

/// @notice A proposal cannot be settled before its voting deadline.
/// @param proposalId Proposal identifier.
/// @param availableAt Timestamp at which settlement becomes available.
error VotingStillOpen(uint256 proposalId, uint256 availableAt);

/// @notice A proposal's funds and lifecycle have already been settled.
/// @param proposalId Proposal identifier.
error ProposalAlreadySettled(uint256 proposalId);

// ========== Treasury, Refunds, And Rewards ==========

/// @notice The caller is not the Hub paired with this treasury.
/// @param caller Address that attempted the Hub-only action.
error NotCommunityHub(address caller);

/// @notice A requested execution withdrawal exceeds available execution funds.
/// @param requested Amount requested for transfer.
/// @param available Current execution balance.
error InsufficientExecutionBalance(uint256 requested, uint256 available);

/// @notice No refund is available for this voter and proposal.
/// @param proposalId Proposal identifier.
/// @param voter Voter address.
error RefundNotAvailable(uint256 proposalId, address voter);

/// @notice The voter has already claimed this proposal refund.
/// @param proposalId Proposal identifier.
/// @param voter Voter address.
error RefundAlreadyClaimed(uint256 proposalId, address voter);

/// @notice A referenced validator reward epoch does not exist.
/// @param epochId Epoch identifier.
error ValidatorRewardEpochNotFound(uint256 epochId);

/// @notice Validator rewards cannot be claimed until the epoch is finalized.
/// @param epochId Epoch identifier.
error ValidatorRewardEpochNotFinalized(uint256 epochId);

/// @notice A validator reward epoch has already been finalized.
/// @param epochId Epoch identifier.
error ValidatorRewardEpochAlreadyFinalized(uint256 epochId);

/// @notice The epoch has no claimable reward for validators.
/// @param epochId Epoch identifier.
error ValidatorRewardUnavailable(uint256 epochId);

/// @notice The validator did not meet the epoch participation threshold.
/// @param epochId Epoch identifier.
/// @param validator Validator address.
error ValidatorNotActiveForEpoch(uint256 epochId, address validator);

/// @notice The validator has already claimed the reward for this epoch.
/// @param epochId Epoch identifier.
/// @param validator Validator address.
error ValidatorRewardAlreadyClaimed(uint256 epochId, address validator);

// ========== Multi-Admin Withdrawals ==========

/// @notice A referenced withdrawal request does not exist.
/// @param requestId Withdrawal request identifier.
error WithdrawalRequestNotFound(uint256 requestId);

/// @notice An admin may approve a withdrawal request only once.
/// @param requestId Withdrawal request identifier.
/// @param admin Admin address.
error WithdrawalAlreadyApproved(uint256 requestId, address admin);

/// @notice A withdrawal request has already been executed.
/// @param requestId Withdrawal request identifier.
error WithdrawalAlreadyExecuted(uint256 requestId);

/// @notice A withdrawal request has already been cancelled.
/// @param requestId Withdrawal request identifier.
error WithdrawalAlreadyCancelled(uint256 requestId);

/// @notice The admin approval quorum has not yet been reached.
/// @param requestId Withdrawal request identifier.
/// @param approvals Current approval count.
/// @param required Required approval count.
error WithdrawalApprovalThresholdNotMet(uint256 requestId, uint256 approvals, uint256 required);

error NotCommunityFactory(address caller);

error CommunityHubNotConfigured();

/// @notice CommunityHub can be linked to a treasury only once.
error CommunityHubAlreadyConfigured();

/// @notice The requested amount exceeds membership funds locked in the treasury.
/// @param requested Amount requested for release.
/// @param available Amount currently locked for all members.
error InsufficientMembershipLocked(uint256 requested, uint256 available);

/// @notice A proposal already has a bond recorded in this treasury.
/// @param proposalId Proposal identifier.
error ProposalBondAlreadyDeposited(uint256 proposalId);

/// @notice A proposal has no bond recorded in this treasury.
/// @param proposalId Proposal identifier.
error ProposalBondNotFound(uint256 proposalId);

/// @notice A proposal bond has already been returned or slashed.
/// @param proposalId Proposal identifier.
error ProposalBondAlreadySettled(uint256 proposalId);

/// @notice Settlement inputs do not match the vote escrow recorded for a proposal.
/// @param proposalId Proposal identifier.
/// @param expected Escrowed USDC amount.
/// @param supplied Sum of YES and NO amounts supplied for settlement.
error VoteEscrowMismatch(uint256 proposalId, uint256 expected, uint256 supplied);

/// @notice The chosen settlement path does not match the binary vote totals.
/// @param proposalId Proposal identifier.
/// @param yesStake Total YES stake.
/// @param noStake Total NO stake.
error InvalidBinarySettlement(uint256 proposalId, uint256 yesStake, uint256 noStake);
