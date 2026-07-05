#!/bin/bash
# validator.sh — git-troubleshooting / 05-accidental-mistakes / git-wrong-branch-fix
set -euo pipefail

REPO_DIR="$HOME/git-challenge"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Find default branch
DEFAULT_BRANCH=""
if git -C "$REPO_DIR" show-ref --verify refs/heads/main &>/dev/null; then
  DEFAULT_BRANCH="main"
elif git -C "$REPO_DIR" show-ref --verify refs/heads/master &>/dev/null; then
  DEFAULT_BRANCH="master"
else
  echo "FAIL: Default branch not found."
  exit 1
fi

# Verify default branch commit count is exactly 1 (meaning it was reset)
COMMIT_COUNT=$(git -C "$REPO_DIR" rev-list --count "$DEFAULT_BRANCH")
if [ "$COMMIT_COUNT" -ne 1 ]; then
  echo "FAIL: Default branch '$DEFAULT_BRANCH' has $COMMIT_COUNT commits (expected: 1)."
  exit 1
fi

# Verify feature-login branch exists
if ! git -C "$REPO_DIR" show-ref --verify refs/heads/feature-login &>/dev/null; then
  echo "FAIL: Branch 'feature-login' not found."
  exit 1
fi

# Verify feature-login branch commit message is correct
MSG=$(git -C "$REPO_DIR" log -1 refs/heads/feature-login --format="%B")
if [ "$MSG" != "Add login feature" ]; then
  echo "FAIL: Latest commit on 'feature-login' is '$MSG' (expected: 'Add login feature')."
  exit 1
fi

echo "PASS: Accidental commit moved to 'feature-login' and default branch reset successfully!"
exit 0
