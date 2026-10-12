# CommunityAdminActions

**Summary**
Linked library that executes security-sensitive V3 Community actions only after the immutable local Admin quorum approves them.

**Why It Is Linked**
`CommunityHub` already owns the Community state machine. Moving the request queue into a linked library keeps the deployed Hub below Ethereum's 24 KiB runtime-code limit without moving state or authority away from the Hub. The library runs with `delegatecall`, therefore state and emitted events remain at the individual CommunityHub address.

**Request Lifecycle**
1. An active Admin calls `createAdminActionRequest`; its approval is recorded automatically.
2. Other active Admins call `approveAdminActionRequest` once each.
3. Any active Admin calls `executeAdminActionRequest` after `adminApprovalThreshold` approvals exist.
4. The request expires after seven days of active Community time. Paused time does not advance this deadline.

**Action Encoding**
| Value | Action | Payload |
| --- | --- | --- |
| `0` | Pause | zero target and value |
| `1` | Unpause | zero target and value |
| `2` | Archive | zero target and value |
| `3` | AddAdmin | target Admin address |
| `4` | RemoveAdmin | target Admin address |
| `5` | AddValidator | target Validator address |
| `6` | RemoveValidator | target Validator address |
| `7` | CancelWithdrawal | withdrawal request ID in `value` |

**Safety Rules**
- The CommunityHub checks that the caller is an active Admin before it delegates to the library.
- The Hub permits action execution only when called back by itself, so an external wallet cannot invoke the action implementation directly.
- The immutable quorum is evaluated at execution time.
- Only one live `CancelWithdrawal` action may target a given withdrawal request. A second request is rejected until the first executes or expires.
- Role exclusivity and all lifecycle invariants are rechecked by the Hub when an action executes.
- An Admin transfer is a two-step, quorum-protected handover: add the replacement first, then remove the outgoing Admin.
