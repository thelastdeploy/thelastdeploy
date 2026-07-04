#!/bin/bash
# validator.sh — git-branching / 03-merging-branches / git-merge-feature
set -euo pipefail

REPO_DIR="$HOME/git-challenge"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify active branch is main or master
ACTIVE_BRANCH=$(git -C "$REPO_DIR" branch --show-current)
if [ "$ACTIVE_BRANCH" != "main" ] && [ "$ACTIVE_BRANCH" != "master" ]; then
  echo "FAIL: Current active branch is '$ACTIVE_BRANCH' (expected: 'main' or 'master'). Please checkout your main/master branch."
  exit 1
fi

# Verify feature-abc is merged into active branch
if ! git -C "$REPO_DIR" merge-base --is-ancestor feature-abc "$ACTIVE_BRANCH" 2>/dev/null; then
  echo "FAIL: Branch 'feature-abc' has not been merged into '$ACTIVE_BRANCH'."
  exit 1
fi

echo "PASS: Branch 'feature-abc' merged into '$ACTIVE_BRANCH' successfully!"
exit 0
