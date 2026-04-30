#!/usr/bin/env bash
# deploy-skills.sh — copy the SkillBuilder skill fileset into the current workspace.
# Usage: cd /path/to/target-workspace && /path/to/SkillBuilder/deploy-skills.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${PWD}"

if [[ "$TARGET" == "$SCRIPT_DIR" ]]; then
  echo "Error: current directory is the SkillBuilder workspace itself. cd into the target workspace first." >&2
  exit 1
fi

rsync -av --no-o --no-g --relative \
  --exclude='.github/agents/docs-to-skill.agent.md' \
  --include='.github/' \
  --include='.github/agents/' \
  --include='.github/instructions/' \
  --include='.github/instructions/**' \
  --include='.github/skills/' \
  --include='.github/skills/**' \
  --exclude='*' \
  "$SCRIPT_DIR/./" \
  "$TARGET/"
