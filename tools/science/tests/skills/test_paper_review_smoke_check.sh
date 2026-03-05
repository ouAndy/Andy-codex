#!/usr/bin/env bash
set -euo pipefail

rg -q 'minimum necessary edit policy' skills/paper-review-revision/SKILL.md
rg -q 'aggressive proposal gate' skills/paper-review-revision/SKILL.md
rg -q 'Only `accept` can execute automatically' skills/paper-review-revision/SKILL.md
