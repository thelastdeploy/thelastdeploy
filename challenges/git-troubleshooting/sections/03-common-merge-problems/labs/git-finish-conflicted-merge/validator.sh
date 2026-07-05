#!/bin/bash
# validator.sh — git-troubleshooting / 03-common-merge-problems / git-finish-conflicted-merge
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
FILE="$REPO_DIR/index.html"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify active merge state is cleared (no MERGE_HEAD)
if [ -f "$REPO_DIR/.git/MERGE_HEAD" ]; then
  echo "FAIL: Merge is still active. Please stage your resolutions and commit to finish."
  exit 1
fi

# Verify latest commit has 2 parents
PARENT_COUNT=$(git -C "$REPO_DIR" log -1 --format="%P" | wc -w)
if [ "$PARENT_COUNT" -ne 2 ]; then
  echo "FAIL: The latest commit is not a merge commit (parents found: $PARENT_COUNT, expected: 2)."
  exit 1
fi

# Verify file actually exists
if [ ! -f "$FILE" ]; then
  echo "FAIL: index.html not found."
  exit 1
fi

# Verify conflict markers are gone
if grep -qE "(<<<<<<<|=======|>>>>>>>)" "$FILE"; then
  echo "FAIL: index.html still contains conflict markers."
  exit 1
fi

# Verify content matches
if ! grep -q "line 1 main" "$FILE" || ! grep -q "line 1 feature" "$FILE"; then
  echo "FAIL: index.html does not contain both main and feature resolutions."
  exit 1
fi

# Verify working tree is clean
if [ -n "$(git -C "$REPO_DIR" status --porcelain)" ]; then
  echo "FAIL: Working tree or staging index is not clean."
  exit 1
fi

echo "PASS: Conflicted merge resolved and committed successfully!"
exit 0
