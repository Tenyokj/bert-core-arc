# Solidity review: independently check one V3.2.1 correction/refund boundary

Volunteer task for `Tenyokj/bert-core-arc`; suggested label: `help wanted`.
For Solidity testers/security-minded contributors, not a beginner task or a
request for a free full audit. Suggested initial scope: 60-120 minutes; report
what you checked and any setup blocker. No finding is required to participate.

## Starting Point

Use the current `arc-usdc-migration` branch in a disposable clone or fork.
Record the commit, Node/npm versions and command output. No frontend, backend,
MetaMask, public RPC, deployer key or Studio key is needed for this first task.

```bash
npm ci
npx hardhat test test/V3/CommunityMilestoneManager.fully.ts --network hardhat
```

The second command was verified locally on November 19: 16 tests passed.
This is a Manager suite with mock Hub/Treasury/Voting components, not full
integration or public-chain evidence. The describe label still says V3.1;
inspect the current source/commit rather than inferring generation from it.
See [testing scope](../TESTING.md) and
[the corrected-deadline finding](../V3.2-CORRECTION-DEADLINE-FINDING.md).

## Pick One Boundary

Review the current `CommunityMilestoneManager` implementation and the existing
tests for correction after rejection, then choose **one** case to independently
verify or extend. Do not just duplicate a test to increase the count.

- Reopening after cooldown must not extend the fixed correction deadline.
- A corrected proof is accepted at the deadline; one second after it is rejected.
- Expiry makes only the unpaid amount refundable: 80% after the initial 20%
  payout, or 40% after the first 60% has actually been paid. A proof approval
  alone is not payment; Admin authorization and execution are distinct steps.
- Refund accounting preserves the original financial supporter denominator,
  with no duplicate claims and no residual dust after all eligible claims.
  Reviewer eligibility and financial refund eligibility are different sets.

Read the existing cases before choosing a gap. For source review, cite the exact
function, invariant, assumptions and why the existing test does or does not
cover it. For an extension, add one focused local regression (for example a
different claim ordering or interaction at the chosen deadline). Keep production
constants, eligibility rules and contract behavior unchanged in this first PR.

## Deliverable and Safety

Comment with your chosen boundary before starting. A non-exploit review can be
public: commit, functions inspected, exact commands, expected/actual state and
remaining uncertainty. A test PR should include the minimal setup, roles, time
steps, exact integer token units, balances/accounting assertions and output.
Use [integration tests](../../test/V3/CommunityMilestoneTreasuryIntegration.fully.ts)
if your conclusion depends on actual Treasury behavior; do not infer it from mocks.

Stop and disclose possible exploitable impact privately through
[Core Security Advisories](https://github.com/Tenyokj/bert-core-arc/security/advisories/new).
Never demonstrate an exploit on public users or publish private keys, attack
instructions, or unredacted sensitive logs in this issue.

Done: one bounded independent review or focused regression, with evidence and
explicit limits. A passing suite is not an audit certificate. This invitation
guarantees no payment, token allocation, role or write/deployment access; the
repository security policy governs any separate disclosure recognition.
