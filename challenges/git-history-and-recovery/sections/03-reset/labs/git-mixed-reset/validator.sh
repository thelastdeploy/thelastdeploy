#!/bin/bash
# validator.sh — git-history-and-recovery / 03-reset / git-mixed-reset
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
  echo "FAIL: Current active branch is '$ACTIVE_BRANCH' (expected: 'main' or 'master')."
  exit 1
fi

# Verify commit count is exactly 2
COMMIT_COUNT=$(git -C "$REPO_DIR" rev-list --count HEAD)
if [ "$COMMIT_COUNT" -ne 2 ]; then
  echo "FAIL: Repository has $COMMIT_COUNT commits (expected: 2). Did you reset HEAD~1?"
  exit 1
fi

# Verify three.txt is NOT staged
if git -C "$REPO_DIR" diff --cached --name-only | grep -q "three.txt"; then
  echo "FAIL: File 'three.txt' is still staged. Did you use the '--mixed' (or default) reset?"
  exit 1
fi

# Verify three.txt exists in working tree
if [ ! -f "$REPO_DIR/three.txt" ]; then
  echo "FAIL: File 'three.txt' not found in working directory."
  exit 1
fi

echo "PASS: Mixed reset completed successfully!"
exit 0
