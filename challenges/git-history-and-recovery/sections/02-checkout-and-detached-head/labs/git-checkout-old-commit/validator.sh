#!/bin/bash
# validator.sh — git-history-and-recovery / 02-checkout-and-detached-head / git-checkout-old-commit
set -euo pipefail

REPO_DIR="$HOME/git-challenge"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Find default branch (main or master)
DEFAULT_BRANCH=""
if git -C "$REPO_DIR" show-ref --verify refs/heads/main &>/dev/null; then
  DEFAULT_BRANCH="main"
elif git -C "$REPO_DIR" show-ref --verify refs/heads/master &>/dev/null; then
  DEFAULT_BRANCH="master"
else
  echo "FAIL: Default branch not found."
  exit 1
fi

# Verify HEAD is detached (symbolic-ref HEAD exits with error because HEAD points to a commit hash, not a branch ref)
if git -C "$REPO_DIR" symbolic-ref -q HEAD &>/dev/null; then
  echo "FAIL: HEAD is not detached. You are still on branch '$(git -C "$REPO_DIR" branch --show-current)'."
  exit 1
fi

# Calculate expected hash of second commit (which is DEFAULT_BRANCH~1)
EXPECTED_HASH=$(git -C "$REPO_DIR" rev-parse "$DEFAULT_BRANCH~1" 2>/dev/null || echo "")
if [ -z "$EXPECTED_HASH" ]; then
  echo "FAIL: Could not calculate the second commit hash."
  exit 1
fi

LOCAL_HEAD=$(git -C "$REPO_DIR" rev-parse HEAD)
if [ "$LOCAL_HEAD" != "$EXPECTED_HASH" ]; then
  echo "FAIL: HEAD is pointing to '$LOCAL_HEAD' (expected the second commit: '$EXPECTED_HASH')."
  exit 1
fi

echo "PASS: Successfully checked out the second commit and entered detached HEAD state!"
exit 0
