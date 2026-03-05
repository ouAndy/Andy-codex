#!/usr/bin/env bash
set -euo pipefail

SKILL_FILE="skills/paper-review-revision/SKILL.md"

rg -q '^name: paper-review-revision$' "$SKILL_FILE"
rg -q 'minimum necessary edit policy' "$SKILL_FILE"
rg -q 'Review Skeptic' "$SKILL_FILE"
rg -q 'accept|partial-accept|defer|needs-author-confirmation' "$SKILL_FILE"
rg -q 'aggressive proposal gate' "$SKILL_FILE"
