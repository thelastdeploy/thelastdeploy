#!/bin/bash
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
TARGET_FILE="$REPO_DIR/latest_commit.txt"

# Verify .git exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not initialized inside $REPO_DIR."
  exit 1
fi

if [ ! -f "$TARGET_FILE" ] || [ ! -s "$TARGET_FILE" ]; then
  echo "FAIL: File latest_commit.txt not found or is empty in $REPO_DIR."
  exit 1
fi

EXPECTED_HASH=$(git -C "$REPO_DIR" rev-parse HEAD | tr -d '\r' | xargs)
ACTUAL_HASH=$(tr -d '\r' < "$TARGET_FILE" | xargs)

if [ "$EXPECTED_HASH" != "$ACTUAL_HASH" ]; then
  echo "FAIL: Expected commit hash '$EXPECTED_HASH', but found '$ACTUAL_HASH'."
  exit 1
fi

echo "PASS: Latest commit hash successfully identified."
