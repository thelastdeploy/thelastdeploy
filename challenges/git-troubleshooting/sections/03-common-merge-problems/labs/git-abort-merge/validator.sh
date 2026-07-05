#!/bin/bash
# validator.sh — git-troubleshooting / 03-common-merge-problems / git-abort-merge
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
FILE="$REPO_DIR/index.html"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify active merge state is cleared (MERGE_HEAD does not exist)
if [ -f "$REPO_DIR/.git/MERGE_HEAD" ]; then
  echo "FAIL: Merge is still active. Please run 'git merge --abort' to cancel."
  exit 1
fi

# Verify file has been restored to pre-merge state
if [ ! -f "$FILE" ]; then
  echo "FAIL: index.html not found."
  exit 1
fi

CONTENT=$(cat "$FILE")
if [ "$CONTENT" != "line 1 main" ]; then
  echo "FAIL: index.html contains '$CONTENT' (expected: 'line 1 main')."
  exit 1
fi

# Verify working tree is clean
if [ -n "$(git -C "$REPO_DIR" status --porcelain)" ]; then
  echo "FAIL: Working tree is not clean."
  exit 1
fi

echo "PASS: Conflicted merge aborted successfully and repository clean!"
exit 0
