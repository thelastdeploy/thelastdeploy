#!/bin/bash
# validator.sh — git-troubleshooting / 04-working-tree-problems / git-stash-changes
set -euo pipefail

REPO_DIR="$HOME/git-challenge"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify working directory changes in tracked files are clean
if [ -n "$(git -C "$REPO_DIR" diff)" ]; then
  echo "FAIL: Working tree still has unstaged changes. Did you stash them?"
  exit 1
fi

# Verify stash contains entries
STASH_LIST=$(git -C "$REPO_DIR" stash list)
if [ -z "$STASH_LIST" ]; then
  echo "FAIL: Stash list is empty. Run 'git stash' to save your work."
  exit 1
fi

# Verify stash contents contain hello.txt changes
if ! git -C "$REPO_DIR" stash show -p | grep -q "stash me"; then
  echo "FAIL: Stash does not contain the modified 'hello.txt' changes."
  exit 1
fi

echo "PASS: Changes stashed successfully!"
exit 0
