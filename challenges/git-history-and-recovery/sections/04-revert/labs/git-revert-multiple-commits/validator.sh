#!/bin/bash
# validator.sh — git-history-and-recovery / 04-revert / git-revert-multiple-commits
set -euo pipefail

REPO_DIR="$HOME/git-challenge"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify commit count is exactly 5
COMMIT_COUNT=$(git -C "$REPO_DIR" rev-list --count HEAD)
if [ "$COMMIT_COUNT" -ne 5 ]; then
  echo "FAIL: Repository has $COMMIT_COUNT commits (expected: 5). Did you use '--no-commit' and create a single commit?"
  exit 1
fi

# Verify the latest commit message
MSG=$(git -C "$REPO_DIR" log -1 --format="%B")
if [ "$MSG" != "Revert last two features" ]; then
  echo "FAIL: Latest commit message is '$MSG' (expected: 'Revert last two features')."
  exit 1
fi

# Verify reverted files do NOT exist
if [ -f "$REPO_DIR/three.txt" ] || [ -f "$REPO_DIR/four.txt" ]; then
  echo "FAIL: File 'three.txt' or 'four.txt' still exists in working directory."
  exit 1
fi

# Verify preserved files DO exist
if [ ! -f "$REPO_DIR/one.txt" ] || [ ! -f "$REPO_DIR/two.txt" ]; then
  echo "FAIL: File 'one.txt' or 'two.txt' is missing from the working directory."
  exit 1
fi

# Verify clean status
if [ -n "$(git -C "$REPO_DIR" status --porcelain)" ]; then
  echo "FAIL: Working tree or staging area is not clean."
  exit 1
fi

echo "PASS: Successfully reverted multiple commits in a single custom commit!"
exit 0
