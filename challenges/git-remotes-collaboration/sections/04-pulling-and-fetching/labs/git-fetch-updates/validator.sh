#!/bin/bash
# validator.sh — git-remotes-collaboration / 04-pulling-and-fetching / git-fetch-updates
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
REMOTE_PATH="$HOME/git-remote-server.git"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

ACTIVE_BRANCH=$(git -C "$REPO_DIR" branch --show-current)
if [ "$ACTIVE_BRANCH" != "main" ] && [ "$ACTIVE_BRANCH" != "master" ]; then
  echo "FAIL: Current active branch is '$ACTIVE_BRANCH' (expected: 'main' or 'master')."
  exit 1
fi

# Get the latest remote commit hash
REMOTE_COMMIT=$(git -C "$REMOTE_PATH" rev-parse HEAD)

# Get local tracking branch commit hash
TRACKING_COMMIT=$(git -C "$REPO_DIR" rev-parse "origin/$ACTIVE_BRANCH" 2>/dev/null || echo "")

if [ -z "$TRACKING_COMMIT" ]; then
  echo "FAIL: Remote tracking branch 'origin/$ACTIVE_BRANCH' not found."
  exit 1
fi

# Verify fetch has been run (tracking branch commit matches remote commit)
if [ "$TRACKING_COMMIT" != "$REMOTE_COMMIT" ]; then
  echo "FAIL: Remote updates have not been fetched (origin/$ACTIVE_BRANCH is out of date)."
  exit 1
fi

# Verify local HEAD is NOT yet merged/updated to the remote commit (safety check)
LOCAL_COMMIT=$(git -C "$REPO_DIR" rev-parse HEAD)
if [ "$LOCAL_COMMIT" = "$REMOTE_COMMIT" ]; then
  echo "FAIL: You pulled/merged the changes instead of just fetching them. The local working tree is already updated."
  exit 1
fi

# Verify update.txt does NOT exist in working tree
if [ -f "$REPO_DIR/update.txt" ]; then
  echo "FAIL: update.txt exists in your working directory. You should only fetch updates, not merge or pull them."
  exit 1
fi

echo "PASS: Remote updates fetched successfully without modifying the local working directory!"
exit 0
