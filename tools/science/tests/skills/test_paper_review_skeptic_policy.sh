#!/usr/bin/env bash
set -euo pipefail

SKILL_FILE="skills/paper-review-revision/SKILL.md"

rg -q 'Only `accept` can execute automatically' "$SKILL_FILE"
rg -q 'All other labels require author confirmation' "$SKILL_FILE"
rg -q 'Do not blindly follow reviewer comments' "$SKILL_FILE"
