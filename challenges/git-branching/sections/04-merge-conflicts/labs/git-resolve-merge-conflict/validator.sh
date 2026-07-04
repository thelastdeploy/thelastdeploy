#!/bin/bash
# validator.sh — git-branching / 04-merge-conflicts / git-resolve-merge-conflict
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
FILE="$REPO_DIR/index.html"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify index.html exists
if [ ! -f "$FILE" ]; then
  echo "FAIL: index.html not found."
  exit 1
fi

# Verify no conflict markers remain
if grep -qE "(<<<<<<<|=======|>>>>>>>)" "$FILE"; then
  echo "FAIL: Conflict markers still remain in index.html. Please resolve the conflict."
  exit 1
fi

# Verify index.html is staged
if ! git -C "$REPO_DIR" diff --name-only --cached | grep -q "index.html"; then
  echo "FAIL: index.html is not added to the staging area."
  exit 1
fi

# Verify we are still in merge state (not committed yet)
if [ ! -f "$REPO_DIR/.git/MERGE_HEAD" ]; then
  echo "FAIL: The merge has already been committed or aborted. You should only stage the resolved conflict."
  exit 1
fi

echo "PASS: Merge conflict in index.html resolved and staged successfully!"
exit 0
