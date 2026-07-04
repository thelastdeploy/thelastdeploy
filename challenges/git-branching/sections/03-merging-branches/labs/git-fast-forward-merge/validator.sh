#!/bin/bash
# validator.sh — git-branching / 03-merging-branches / git-fast-forward-merge
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

# Verify feature-ff is merged
if ! git -C "$REPO_DIR" merge-base --is-ancestor feature-ff "$ACTIVE_BRANCH" 2>/dev/null; then
  echo "FAIL: Branch 'feature-ff' has not been merged into '$ACTIVE_BRANCH'."
  exit 1
fi

# Verify it was a fast-forward merge (tip of active branch must be exactly the tip of feature-ff)
ACTIVE_TIP=$(git -C "$REPO_DIR" rev-parse "$ACTIVE_BRANCH")
FF_TIP=$(git -C "$REPO_DIR" rev-parse feature-ff)

if [ "$ACTIVE_TIP" != "$FF_TIP" ]; then
  echo "FAIL: Merge was not fast-forwarded. A separate merge commit was created."
  exit 1
fi

echo "PASS: Fast-forward merge completed successfully!"
exit 0
