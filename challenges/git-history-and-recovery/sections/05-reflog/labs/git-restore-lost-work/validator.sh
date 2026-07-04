#!/bin/bash
# validator.sh — git-history-and-recovery / 05-reflog / git-restore-lost-work
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
CORRECT_FILE="$REPO_DIR/.correct-hash"
FILE="$REPO_DIR/lost.txt"

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

# Read correct hash
CORRECT_HASH=$(tr -d '[:space:]' < "$CORRECT_FILE")

# Verify local HEAD matches correct hash
LOCAL_HEAD=$(git -C "$REPO_DIR" rev-parse HEAD)
if [ "$LOCAL_HEAD" != "$CORRECT_HASH" ]; then
  echo "FAIL: Your local HEAD is at '$LOCAL_HEAD' (expected: '$CORRECT_HASH'). Have you reset back to the lost commit?"
  exit 1
fi

# Verify file actually exists and contains the correct contents
if [ ! -f "$FILE" ]; then
  echo "FAIL: File '$FILE' not found in working copy."
  exit 1
fi

CONTENT=$(cat "$FILE")
if [ "$CONTENT" != "lost" ]; then
  echo "FAIL: File '$FILE' contains '$CONTENT' (expected: 'lost')."
  exit 1
fi

echo "PASS: Lost commit successfully recovered and branch state restored!"
exit 0
