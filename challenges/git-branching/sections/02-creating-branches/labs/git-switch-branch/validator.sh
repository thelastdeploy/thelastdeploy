#!/bin/bash
# validator.sh — git-branching / 02-creating-branches / git-switch-branch
set -euo pipefail

REPO_DIR="$HOME/git-challenge"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify active branch is feature-login
ACTIVE_BRANCH=$(git -C "$REPO_DIR" branch --show-current)
if [ "$ACTIVE_BRANCH" != "feature-login" ]; then
  echo "FAIL: Current active branch is '$ACTIVE_BRANCH' (expected: 'feature-login')."
  exit 1
fi

echo "PASS: Successfully switched to branch 'feature-login'!"
exit 0
