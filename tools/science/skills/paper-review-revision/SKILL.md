---
name: paper-review-revision
description: Revise a full academic manuscript from peer-review comments. Use when the user provides full paper text plus reviewer feedback (raw reviewer text or structured issue list) and wants a clean revised manuscript while enforcing skeptical evaluation, minimum necessary edits, and explicit approval gating for aggressive rewrites.
---

# Paper Review Revision

## Overview

Revise the manuscript using reviewer feedback without blindly following every request. Prioritize scientific validity, author intent, and scope control, then output one clean full revised manuscript.

## Inputs and Output

Required inputs:
- Full manuscript text.
- Reviewer feedback in one of two formats:
  - Raw reviewer comments (`Reviewer 1`, `Reviewer 2`, etc.).
  - Structured issue list prepared by the author.

Optional inputs:
- Target journal constraints, style constraints, length constraints.

Output: one clean full revised manuscript.

## Workflow

1. Normalize review input into `ReviewItem[]`.
2. Parse each item into issue type, severity, target scope, and requested change.
3. Run Review Skeptic evaluation (do not skip):
   - Evidence sufficiency
   - Consistency with study scope
   - Cost-benefit of requested change
   - Conflicts with other comments or manuscript facts
4. Assign each item one decision label:
   - `accept`
   - `partial-accept`
   - `defer`
   - `needs-author-confirmation`
5. Only `accept` can execute automatically.
6. All other labels require author confirmation.
7. Apply the minimum necessary edit policy.
8. If moderate revision is likely insufficient, trigger aggressive proposal gate.
9. Run section rewrite and global consistency regression.
10. Produce final clean full manuscript.

## Core Policy

### Skeptical Handling

Do not blindly follow reviewer comments. Every non-trivial request must pass the Review Skeptic checks before it can become an edit task.

### Minimum-Change Constraint

Apply the minimum necessary edit policy:
- Modify only text directly needed to satisfy accepted comments.
- Preserve original scientific claim boundaries.
- Keep terminology and section structure stable unless change is required.

### Aggressive Rewrite Policy

`Moderate` is the default revision mode.

Use aggressive rewrite only after aggressive proposal gate:
- Explain why moderate revision is insufficient.
- Provide expected gains and risks.
- State required new evidence or experiments.
- Wait for explicit author approval before aggressive execution.

## Safety and Quality Checks

- Do not fabricate data, experiments, or citations.
- Flag unresolved reviewer items explicitly.
- Enforce global consistency regression:
  - Terminology consistency
  - Claim-method-result alignment
  - Abstract-body-conclusion coherence
  - Citation/reference consistency

## References

Load these only when needed:
- `references/decision-rules.md` for decision mapping and escalation rules.
- `references/workflow-checklist.md` for step-by-step execution checks.

## Behavior Contract

If information is missing or ambiguous, use conservative edits and ask for author confirmation instead of guessing.
