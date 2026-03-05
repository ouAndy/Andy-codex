#!/usr/bin/env bash
set -euo pipefail

rg -q 'references/decision-rules.md' skills/paper-review-revision/SKILL.md
rg -q 'references/workflow-checklist.md' skills/paper-review-revision/SKILL.md
rg -q '^# Decision Matrix' skills/paper-review-revision/references/decision-rules.md
rg -q '^# Execution Checklist' skills/paper-review-revision/references/workflow-checklist.md
