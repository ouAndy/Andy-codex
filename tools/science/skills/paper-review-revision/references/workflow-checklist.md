# Execution Checklist

## Stage 1: Input Validation

- Confirm full manuscript is present.
- Confirm review feedback is present.
- Identify review format (raw comments or structured issue list).

## Stage 2: Normalization and Parsing

- Normalize feedback into `ReviewItem[]`.
- Parse severity, type, target scope, and requested change.
- Link each parsed item to manuscript sections.

## Stage 3: Skeptical Evaluation

- Run evidence sufficiency check.
- Run scope-consistency check.
- Run cost-benefit check.
- Run cross-review conflict check.
- Assign decision label for each item.

## Stage 4: Execution Gating

- Auto-execute only `accept`.
- Queue all non-`accept` items for author confirmation.
- If aggressive trigger exists, produce proposal and wait for explicit approval.

## Stage 5: Rewrite and Regression

- Apply edits section by section.
- Run global consistency regression.
- Verify no fabricated evidence.
- Ensure final output is a single clean revised manuscript.

## Stop Conditions

Stop and ask author before proceeding when:
- Review intent is ambiguous.
- Two high-severity reviewer requests conflict.
- Requested change requires new data that is not available.
