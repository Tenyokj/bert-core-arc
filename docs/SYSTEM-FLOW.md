# System Flow

This document describes the operational flow of BERT in a narrative sequence from proposal creation to final milestone completion.

## Contents
1. Idea Creation Flow
2. Round Formation Flow
3. Voting Flow
4. Round Resolution Flow
5. Grant Claim Flow
6. Milestone Review Flow

## Idea Creation Flow

1. builder prepares proposal metadata
2. builder approves USDC allowance
3. builder calls `createFundingProposal`
4. registry validates metadata, minimum author bond, and non-zero `minimumNetFunding`
5. author bond is locked in the funding pool
6. reputation is initialized if needed
7. idea is stored with `Pending` status

## Round Formation Flow

1. operator starts a new round
2. voting system checks enough unused ideas exist
3. a contiguous batch of ideas is assigned
4. those ideas move into `Voting`
5. round timing and membership become active

## Voting Flow

1. voter selects idea and amount
2. voting system validates round, membership, and minimum stake
3. funding pool records one refundable pledge for that voter, round, and idea
4. vote totals are updated in round state; a second pledge in the same round is rejected

## Round Resolution Flow

1. voting window ends
2. operator ends the round
3. each proposal is tested against its `minimumNetFunding` after the fee snapshotted at round opening
4. the highest-vote viable idea becomes `WonVoting`; if none is viable, the round has no winner
5. all non-winners become `Rejected`
6. reputation updates are triggered
7. winning voters receive progression updates
8. losing pledges become refundable to their original voters; a no-winner round refunds every pledge
9. rejected author bonds can move into reserve

## Grant Claim Flow

1. winning author calls `claimGrant`
2. grant manager validates claimability
3. the pending round fee is finalized into reserve
4. the initial 30% net-grant tranche is released
5. idea moves to `Funded`
6. if no claim occurs within 14 days, anyone can restore the full gross winning pledge for refund

## Milestone Review Flow

1. author submits milestone proof
2. reviewers approve or reject
3. if approved, stage payout is released
4. if rejected, cooldown starts
5. after valid later proof, the next tranche can be released
6. the final state becomes `Completed`
7. if the active grant misses its stage deadline, anyone can cancel it and open pro-rata refund of its unspent net pledge to winning pledgers
