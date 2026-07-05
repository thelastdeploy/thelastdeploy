#!/bin/bash
# validator.sh — git-troubleshooting / 02-common-push-failures / git-fix-non-fast-forward
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

# Verify remote tracking branch has been updated (meaning they pushed)
LOCAL_HEAD=$(git -C "$REPO_DIR" rev-parse HEAD)
REMOTE_HEAD=$(git -C "$REPO_DIR" rev-parse "origin/$ACTIVE_BRANCH" 2>/dev/null || echo "")

if [ "$LOCAL_HEAD" != "$REMOTE_HEAD" ]; then
  echo "FAIL: Your local changes have not been successfully pushed to the remote repository."
  exit 1
fi

# Verify both local.txt and remote.txt exist on the remote HEAD
if ! git -C "$REMOTE_PATH" cat-file -e "HEAD:local.txt" 2>/dev/null; then
  echo "FAIL: The remote repository does not contain 'local.txt'."
  exit 1
fi

if ! git -C "$REMOTE_PATH" cat-file -e "HEAD:remote.txt" 2>/dev/null; then
  echo "FAIL: The remote repository does not contain 'remote.txt'."
  exit 1
fi

echo "PASS: Non-fast-forward push reject resolved and pushed successfully!"
exit 0
