#!/bin/bash
# validator.sh — git-remotes-collaboration / 04-pulling-and-fetching / git-pull-changes
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

# Verify local HEAD matches remote commit hash
LOCAL_COMMIT=$(git -C "$REPO_DIR" rev-parse HEAD)
if [ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" ]; then
  echo "FAIL: Local HEAD commit ($LOCAL_COMMIT) is not up-to-date with remote HEAD ($REMOTE_COMMIT). Did you pull?"
  exit 1
fi

# Verify update.txt exists
if [ ! -f "$REPO_DIR/update.txt" ]; then
  echo "FAIL: update.txt not found in working copy."
  exit 1
fi

echo "PASS: Remote changes pulled and integrated successfully!"
exit 0
