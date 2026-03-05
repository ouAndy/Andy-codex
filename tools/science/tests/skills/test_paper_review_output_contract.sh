#!/usr/bin/env bash
set -euo pipefail

SKILL_FILE="skills/paper-review-revision/SKILL.md"

rg -q 'Output: one clean full revised manuscript' "$SKILL_FILE"
rg -q 'Do not fabricate data, experiments, or citations' "$SKILL_FILE"
rg -q 'global consistency regression' "$SKILL_FILE"
