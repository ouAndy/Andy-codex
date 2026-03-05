# Paper Review Revision Skill Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a reusable Codex skill that revises a full manuscript from reviewer comments, applies minimum-necessary edits by default, and enforces skeptical review decisions plus aggressive-change approval gating.

**Architecture:** Implement one skill folder with a strict SKILL.md workflow and small reference files. Enforce behavior through lightweight shell tests that assert required policy text and workflow sections. Validate the finished skill with the skill-creator validator before handoff.

**Tech Stack:** Markdown skill spec, shell-based checks (`bash`, `rg`), Python validator from `~/.codex/skills/.system/skill-creator/scripts/quick_validate.py`.

---

### Task 1: Scaffold the Skill and Baseline Test

**Files:**
- Create: `skills/paper-review-revision/SKILL.md`
- Create: `skills/paper-review-revision/agents/openai.yaml`
- Create: `skills/paper-review-revision/references/decision-rules.md`
- Create: `skills/paper-review-revision/references/workflow-checklist.md`
- Create: `tests/skills/test_paper_review_skill_structure.sh`

**Step 1: Write the failing test**

```bash
mkdir -p tests/skills
cat > tests/skills/test_paper_review_skill_structure.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

SKILL_FILE="skills/paper-review-revision/SKILL.md"

rg -q '^name: paper-review-revision$' "$SKILL_FILE"
rg -q 'minimum necessary edit policy' "$SKILL_FILE"
rg -q 'Review Skeptic' "$SKILL_FILE"
rg -q 'accept|partial-accept|defer|needs-author-confirmation' "$SKILL_FILE"
rg -q 'aggressive proposal gate' "$SKILL_FILE"
EOF
chmod +x tests/skills/test_paper_review_skill_structure.sh
```

**Step 2: Run test to verify it fails**

Run: `bash tests/skills/test_paper_review_skill_structure.sh`  
Expected: FAIL because `skills/paper-review-revision/SKILL.md` does not exist yet.

**Step 3: Write minimal implementation (scaffold only)**

```bash
python3 /Users/andy/.codex/skills/.system/skill-creator/scripts/init_skill.py \
  paper-review-revision \
  --path /Users/andy/Library/CloudStorage/OneDrive-个人/onedrive同步/tools/science/skills \
  --resources references \
  --interface display_name="Paper Review Revision" \
  --interface short_description="Revise manuscript from reviewer comments with controlled policy gates." \
  --interface default_prompt="Revise my manuscript from reviewer comments using minimum necessary edits."
```

**Step 4: Run test to verify baseline still fails for missing required policy text**

Run: `bash tests/skills/test_paper_review_skill_structure.sh`  
Expected: FAIL on required policy lines not yet present.

**Step 5: Commit**

```bash
git add tests/skills/test_paper_review_skill_structure.sh skills/paper-review-revision
git commit -m "chore: scaffold paper-review-revision skill and baseline checks"
```

### Task 2: Implement Trigger Metadata and Core Workflow in SKILL.md

**Files:**
- Modify: `skills/paper-review-revision/SKILL.md`
- Test: `tests/skills/test_paper_review_skill_structure.sh`

**Step 1: Write the failing test for skeptical decision policy**

```bash
cat > tests/skills/test_paper_review_skeptic_policy.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

SKILL_FILE="skills/paper-review-revision/SKILL.md"

rg -q 'Only `accept` can execute automatically' "$SKILL_FILE"
rg -q 'All other labels require author confirmation' "$SKILL_FILE"
rg -q 'Do not blindly follow reviewer comments' "$SKILL_FILE"
EOF
chmod +x tests/skills/test_paper_review_skeptic_policy.sh
```

**Step 2: Run test to verify it fails**

Run: `bash tests/skills/test_paper_review_skeptic_policy.sh`  
Expected: FAIL because policy text is not fully implemented.

**Step 3: Write minimal implementation**

Replace `skills/paper-review-revision/SKILL.md` with a complete spec containing:

```markdown
---
name: paper-review-revision
description: Revise full manuscripts from reviewer comments. Use when user provides manuscript text plus review results and wants a clean revised full paper. Enforce minimum necessary edits, skeptical review evaluation, and aggressive-revision approval gating.
---

# Paper Review Revision

Process:
1. Normalize review input to `ReviewItem[]`.
2. Parse actionable edits.
3. Run Review Skeptic:
   - evidence sufficiency
   - scope consistency
   - cost-benefit
   - conflict detection
4. Label each item: `accept|partial-accept|defer|needs-author-confirmation`.
5. Only `accept` can execute automatically.
6. All other labels require author confirmation.
7. Apply minimum necessary edit policy.
8. If needed, raise aggressive proposal gate before aggressive rewrite.
9. Output one clean full revised manuscript.
```

**Step 4: Run tests to verify they pass**

Run:
- `bash tests/skills/test_paper_review_skill_structure.sh`
- `bash tests/skills/test_paper_review_skeptic_policy.sh`

Expected: PASS.

**Step 5: Commit**

```bash
git add skills/paper-review-revision/SKILL.md tests/skills/test_paper_review_skeptic_policy.sh
git commit -m "feat: define skeptical review and gating workflow in skill spec"
```

### Task 3: Add Reference Files for Deterministic Decisions

**Files:**
- Modify: `skills/paper-review-revision/references/decision-rules.md`
- Modify: `skills/paper-review-revision/references/workflow-checklist.md`
- Modify: `skills/paper-review-revision/SKILL.md`
- Test: `tests/skills/test_paper_review_references.sh`

**Step 1: Write the failing test for reference linkage**

```bash
cat > tests/skills/test_paper_review_references.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

rg -q 'references/decision-rules.md' skills/paper-review-revision/SKILL.md
rg -q 'references/workflow-checklist.md' skills/paper-review-revision/SKILL.md
rg -q '^## Decision Matrix' skills/paper-review-revision/references/decision-rules.md
rg -q '^## Execution Checklist' skills/paper-review-revision/references/workflow-checklist.md
EOF
chmod +x tests/skills/test_paper_review_references.sh
```

**Step 2: Run test to verify it fails**

Run: `bash tests/skills/test_paper_review_references.sh`  
Expected: FAIL before reference content is added.

**Step 3: Write minimal implementation**

Populate `decision-rules.md` with:
- Decision matrix for `accept|partial-accept|defer|needs-author-confirmation`
- Aggressive proposal triggers
- Minimum necessary edit boundary checks

Populate `workflow-checklist.md` with:
- End-to-end checklist from normalization to final consistency regression
- Stop conditions (missing manuscript, ambiguous review item, unresolved conflicts)

Link both files in `SKILL.md` under a “Load references when needed” section.

**Step 4: Run test to verify it passes**

Run: `bash tests/skills/test_paper_review_references.sh`  
Expected: PASS.

**Step 5: Commit**

```bash
git add skills/paper-review-revision/references skills/paper-review-revision/SKILL.md tests/skills/test_paper_review_references.sh
git commit -m "feat: add decision matrix and workflow checklist references"
```

### Task 4: Add Manuscript Output Contract and Regression Requirements

**Files:**
- Modify: `skills/paper-review-revision/SKILL.md`
- Test: `tests/skills/test_paper_review_output_contract.sh`

**Step 1: Write the failing test for output contract**

```bash
cat > tests/skills/test_paper_review_output_contract.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

SKILL_FILE="skills/paper-review-revision/SKILL.md"
rg -q 'Output: one clean full revised manuscript' "$SKILL_FILE"
rg -q 'Do not fabricate data, experiments, or citations' "$SKILL_FILE"
rg -q 'global consistency regression' "$SKILL_FILE"
EOF
chmod +x tests/skills/test_paper_review_output_contract.sh
```

**Step 2: Run test to verify it fails**

Run: `bash tests/skills/test_paper_review_output_contract.sh`  
Expected: FAIL until output contract text is present.

**Step 3: Write minimal implementation**

Add explicit SKILL.md sections:
- Required output contract (single clean full manuscript).
- Safety constraints (no fabricated evidence).
- Regression checks (terminology, claim-result consistency, abstract/body/conclusion coherence).

**Step 4: Run test to verify it passes**

Run: `bash tests/skills/test_paper_review_output_contract.sh`  
Expected: PASS.

**Step 5: Commit**

```bash
git add skills/paper-review-revision/SKILL.md tests/skills/test_paper_review_output_contract.sh
git commit -m "feat: enforce output contract and regression guardrails"
```

### Task 5: Validate Skill Package with System Validator

**Files:**
- Modify: `skills/paper-review-revision/SKILL.md` (if validator reports issues)
- Test: validator output

**Step 1: Run validation (expected first failure only if formatting issues exist)**

Run:
`python3 /Users/andy/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/paper-review-revision`  
Expected: PASS. If FAIL, note exact error and continue.

**Step 2: Write minimal fixes (only if failing)**

Example fixes:
- Frontmatter keys strictly `name` + `description`.
- Lowercase hyphenated skill name.
- Remove unsupported metadata fields.

**Step 3: Re-run validation**

Run:
`python3 /Users/andy/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/paper-review-revision`  
Expected: PASS.

**Step 4: Run all tests**

Run:
```bash
bash tests/skills/test_paper_review_skill_structure.sh
bash tests/skills/test_paper_review_skeptic_policy.sh
bash tests/skills/test_paper_review_references.sh
bash tests/skills/test_paper_review_output_contract.sh
```
Expected: PASS all.

**Step 5: Commit**

```bash
git add skills/paper-review-revision tests/skills
git commit -m "chore: validate paper-review-revision skill package"
```

### Task 6: Smoke Test the Skill with Realistic Inputs

**Files:**
- Create: `tests/fixtures/paper-review/sample-manuscript.md`
- Create: `tests/fixtures/paper-review/sample-review-raw.md`
- Create: `tests/fixtures/paper-review/sample-review-structured.md`
- Create: `tests/fixtures/paper-review/expected-behaviors.md`

**Step 1: Write the failing smoke-check script**

```bash
cat > tests/skills/test_paper_review_smoke_check.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

rg -q 'minimum necessary edits' skills/paper-review-revision/SKILL.md
rg -q 'aggressive proposal gate' skills/paper-review-revision/SKILL.md
rg -q 'Only `accept` can execute automatically' skills/paper-review-revision/SKILL.md
EOF
chmod +x tests/skills/test_paper_review_smoke_check.sh
```

**Step 2: Run test to verify behavior contract**

Run: `bash tests/skills/test_paper_review_smoke_check.sh`  
Expected: PASS.

**Step 3: Add minimal fixtures for manual dry-run**

Add small markdown fixtures for:
- manuscript excerpt
- raw reviewer comments
- structured issue list
- expected behavior notes (what must/must not happen)

**Step 4: Manual dry-run checklist**

Run through one simulated prompt using fixtures and verify:
- non-accepted skeptic labels are blocked pending author confirmation
- no fabricated evidence
- output stays a clean full-manuscript style

**Step 5: Commit**

```bash
git add tests/fixtures/paper-review tests/skills/test_paper_review_smoke_check.sh
git commit -m "test: add smoke fixtures and behavior checks for paper-review-revision skill"
```

