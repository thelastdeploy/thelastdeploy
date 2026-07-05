#!/bin/bash
# validator.sh — git-troubleshooting / 04-working-tree-problems / git-clean-working-tree
set -euo pipefail

REPO_DIR="$HOME/git-challenge"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify untracked files are gone
for FILE in "$REPO_DIR/debug.log" "$REPO_DIR/temp.tmp" "$REPO_DIR/build/out.bin"; do
  if [ -f "$FILE" ]; then
    echo "FAIL: File '$FILE' still exists in working copy."
    exit 1
  fi
done

# Verify build/ directory is deleted (if it was clean)
if [ -d "$REPO_DIR/build" ]; then
  echo "FAIL: Directory 'build/' still exists in working copy."
  exit 1
fi

# Verify tracked file exists
if [ ! -f "$REPO_DIR/hello.txt" ]; then
  echo "FAIL: Tracked file 'hello.txt' is missing."
  exit 1
fi

# Verify status is clean
if [ -n "$(git -C "$REPO_DIR" status --porcelain)" ]; then
  echo "FAIL: Working tree is not clean."
  exit 1
fi

echo "PASS: Working tree cleaned successfully!"
exit 0
