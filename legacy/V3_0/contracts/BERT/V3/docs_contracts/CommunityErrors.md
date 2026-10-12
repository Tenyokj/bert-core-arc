# CommunityErrors

**Summary**
V3 custom errors provide compact, machine-readable failure reasons across community state, roles, membership, proposals, voting, settlement, rewards, Treasury operations, and Factory activation.

**Error Groups**
- Community status and local role violations
- Membership stake, exit cooldown, and unresolved-obligation checks
- Proposal existence, lifecycle, validation, and text checks
- Vote amount, duplicate vote, deadline, and settlement checks
- Slate round composition and settlement checks
- Validator reward epoch eligibility and claim checks
- Treasury escrow, bond, refund, reserve, and withdrawal checks
- Factory reservation, creator, and Hub activation checks
- Admin-action request existence, expiry, duplicate approval, quorum, and parameter checks
- Duplicate pending withdrawal-cancellation request checks

**Related Errors**
Generic protocol errors such as `ZeroAddress`, `ZeroAmount`, `InvalidId`, and `InvalidParameter` remain in `contracts/BERT/utils/Errors.sol` so V2 and V3 share one base error vocabulary.
