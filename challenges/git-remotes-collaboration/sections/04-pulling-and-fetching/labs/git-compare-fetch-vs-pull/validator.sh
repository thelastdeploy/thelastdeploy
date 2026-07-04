#!/bin/bash
# validator.sh — git-remotes-collaboration / 04-pulling-and-fetching / git-compare-fetch-vs-pull
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
FILE="$REPO_DIR/fetch-log.txt"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify fetch-log.txt exists
if [ ! -f "$FILE" ]; then
  echo "FAIL: File '$FILE' not found. Did you save the remote commit message to fetch-log.txt?"
  exit 1
fi

# Verify tracking branch origin/feature-compare exists locally (proves they fetched)
if ! git -C "$REPO_DIR" show-ref --verify refs/remotes/origin/feature-compare &>/dev/null; then
  echo "FAIL: Remote branch 'origin/feature-compare' has not been fetched locally."
  exit 1
fi

# Verify the file contains the expected commit message
if ! grep -q "Compare commit details" "$FILE"; then
  echo "FAIL: File '$FILE' does not contain the expected remote commit message 'Compare commit details'."
  exit 1
fi

# Verify they did not check out or create a local feature-compare branch (safety check for fetch vs pull)
if git -C "$REPO_DIR" show-ref --verify refs/heads/feature-compare &>/dev/null; then
  echo "FAIL: Local branch 'feature-compare' exists. You should only fetch and inspect the remote tracking branch, not create a local branch or pull."
  exit 1
fi

echo "PASS: Remote changes fetched and compared successfully without merging!"
exit 0
