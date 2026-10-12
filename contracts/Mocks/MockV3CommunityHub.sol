// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {CommunityTypes} from "../BERT/V3/libraries/CommunityTypes.sol";

/** @notice Test-only V3 Hub lifecycle and forwarding surface. */
contract MockV3CommunityHub {
    CommunityTypes.CommunityStatus public communityStatus = CommunityTypes.CommunityStatus.Active;
    uint256 public validatorRewardShareBps;
    uint256 public adminApprovalThreshold = 1;

    mapping(address => bool) private _admins;
    mapping(uint256 => mapping(address => bool)) private _activeValidatorsByEpoch;

    function setCommunityStatus(CommunityTypes.CommunityStatus status) external {
        communityStatus = status;
    }

    function setValidatorRewardShareBps(uint256 value) external {
        validatorRewardShareBps = value;
    }

    function setAdmin(address account, bool active) external {
        _admins[account] = active;
    }

    function setAdminApprovalThreshold(uint256 value) external {
        adminApprovalThreshold = value;
    }

    function setValidatorActiveForEpoch(uint256 epochId, address account, bool active) external {
        _activeValidatorsByEpoch[epochId][account] = active;
    }

    function isAdminAccount(address account) external view returns (bool) {
        return _admins[account];
    }

    function isValidatorActiveForEpoch(uint256 epochId, address account) external view returns (bool) {
        return _activeValidatorsByEpoch[epochId][account];
    }

    function callTarget(address target, bytes calldata data) external returns (bytes memory result) {
        (bool success, bytes memory returnData) = target.call(data);
        if (!success) {
            assembly ("memory-safe") {
                revert(add(returnData, 0x20), mload(returnData))
            }
        }
        return returnData;
    }
}
