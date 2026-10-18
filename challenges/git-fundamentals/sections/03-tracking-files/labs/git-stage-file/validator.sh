#!/bin/bash
set -euo pipefail

REPO_DIR="$HOME/git-challenge"

# Verify .git exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not initialized inside $REPO_DIR."
  exit 1
fi

# Verify README.md exists and is non-empty
if [ ! -f "$REPO_DIR/README.md" ] || [ ! -s "$REPO_DIR/README.md" ]; then
  echo "FAIL: README.md not found or is empty in $REPO_DIR."
  exit 1
fi

# Check if README.md is in Git index (staged)
if ! git -C "$REPO_DIR" diff --name-only --cached | grep -q "README.md"; then
  echo "FAIL: README.md is not added to the staging area."
  exit 1
fi

# Check that it has not been committed yet
if git -C "$REPO_DIR" log -1 >/dev/null 2>&1; then
  echo "FAIL: README.md has already been committed. It should only be staged."
  exit 1
fi

echo "PASS: README.md staged successfully."
