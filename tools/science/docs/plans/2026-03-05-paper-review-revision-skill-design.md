# Paper Review Revision Skill Design

## 1. Objective

Create a reusable Codex skill that takes a full manuscript plus reviewer comments and outputs a clean revised full manuscript.

Core constraints:
- Default to moderate revision.
- Enforce minimum necessary edits.
- Do not blindly follow reviewer comments.
- Escalate to aggressive revision only through an explicit proposal-and-approval gate.

## 2. Inputs and Outputs

### Required inputs
- Full manuscript text (complete draft).
- Review results in either format:
  - Raw reviewer comments (Reviewer 1/2/3, free text), or
  - Structured issue list prepared by the author.

### Optional inputs
- Target journal constraints.
- Style/tone preferences.
- Word-limit constraints.

### Required output
- One clean, full revised manuscript ready to replace the previous draft.

## 3. Pipeline Architecture

### Stage A: Input Normalization
- Normalize review inputs into standard `ReviewItem[]`.
- Preserve reviewer provenance for traceability.

### Stage B: Review Parsing
- Convert each item into actionable edit intent:
  - issue type
  - severity
  - manuscript target scope
  - requested action
  - potential aggressive trigger

### Stage C: Review Skeptic (Critical Evaluation Layer)
- Evaluate each review item instead of auto-accepting:
  - Evidence sufficiency
  - Consistency with study scope and contribution boundary
  - Cost-benefit of requested change
  - Conflict with other reviewer items or manuscript facts
- Assign one decision label per item:
  - `accept`
  - `partial-accept`
  - `defer`
  - `needs-author-confirmation`
- Auto-execution policy:
  - Only `accept` can execute automatically.
  - All other labels require author confirmation.

### Stage D: Edit Policy Engine
- Apply the minimum necessary edit policy:
  - Modify only text directly required by accepted review items.
  - Avoid unnecessary changes to terminology, structure, and narrative order.
  - Keep conclusion claims within original evidence boundaries.
- Default revision mode: moderate.

### Stage E: Aggressive Proposal Gate
- Trigger only if moderate revision is unlikely to satisfy high-impact review concerns.
- Generate proposal containing:
  - why aggressive revision is needed
  - expected benefits
  - risks
  - required new evidence/experiments (no fabricated results)
  - fallback moderate plan
- Block aggressive rewriting until explicit author approval.

### Stage F: Section Rewriter + Global Regression
- Rewrite affected sections first.
- Run global consistency regression across:
  - terminology consistency
  - claim-method-result alignment
  - abstract/body/conclusion coherence
  - citation and reference consistency
- Produce final clean full manuscript.

## 4. Data Model

### ReviewItem
- `id`
- `reviewer`
- `raw_text`
- `severity`
- `issue_type`
- `target_scope`
- `requested_action`
- `aggressive_candidate`

### SkepticDecision
- `review_item_id`
- `decision` (`accept|partial-accept|defer|needs-author-confirmation`)
- `rationale`
- `required_author_input`

### EditTask
- `task_id`
- `linked_review_item_ids`
- `section_id`
- `minimal_scope`
- `edit_mode` (`moderate|aggressive`)
- `acceptance_checks`

### AggressiveProposal
- `trigger_reason`
- `expected_gain`
- `risk`
- `required_new_evidence`
- `fallback_plan`
- `author_approval` (`pending|approved|rejected`)

## 5. Decision Rules

1. Never fabricate data, experiments, or citations.
2. Prefer moderate revision unless a justified aggressive proposal is approved.
3. Enforce minimum necessary edits by default.
4. Do not auto-execute skeptic outcomes other than `accept`.
5. Resolve reviewer conflicts by explicit rationale and author confirmation when needed.

## 6. Failure and Edge Handling

- Ambiguous reviewer comments:
  - mark as `needs-author-confirmation` and keep conservative revision.
- Conflicting reviewer requests:
  - prioritize evidence-backed high-severity concerns, then ask author to choose.
- Requests requiring new experiments:
  - proposal only; do not synthesize fake outcomes.
- Scope drift detection:
  - rollback unrelated edits and re-apply minimum necessary scope.

## 7. Acceptance Criteria

1. Every review item is mapped to a skeptic decision.
2. Every accepted decision maps to at least one edit task.
3. Aggressive edits cannot run without explicit approval.
4. Final output is a single clean full manuscript.
5. Manuscript-level consistency checks pass.
6. Unresolved items are explicitly listed with reasons.

## 8. Out of Scope

- Generating fake experiment results.
- Auto-submitting response letters to journal systems.
- Replacing domain-expert judgment for factual scientific disputes.

