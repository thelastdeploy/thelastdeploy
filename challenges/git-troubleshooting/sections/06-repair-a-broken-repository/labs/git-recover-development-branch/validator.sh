#!/bin/bash
# validator.sh — git-troubleshooting / 06-repair-a-broken-repository / git-recover-development-branch
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
REMOTE_PATH="$HOME/git-remote-server.git"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify active branch is dev
ACTIVE_BRANCH=$(git -C "$REPO_DIR" branch --show-current)
if [ "$ACTIVE_BRANCH" != "dev" ]; then
  echo "FAIL: Current active branch is '$ACTIVE_BRANCH' (expected: 'dev'). Please checkout dev."
  exit 1
fi

# Verify they fetched remote changes (so refs/remotes/origin/dev exists)
if ! git -C "$REPO_DIR" show-ref --verify refs/remotes/origin/dev &>/dev/null; then
  echo "FAIL: Remote tracking branch 'origin/dev' not found. Did you run 'git fetch'?"
  exit 1
fi

# Verify local dev HEAD matches origin/dev HEAD
LOCAL_HEAD=$(git -C "$REPO_DIR" rev-parse HEAD)
REMOTE_HEAD=$(git -C "$REPO_DIR" rev-parse origin/dev)

if [ "$LOCAL_HEAD" != "$REMOTE_HEAD" ]; then
  echo "FAIL: Local dev branch ($LOCAL_HEAD) has not been aligned with origin/dev ($REMOTE_HEAD)."
  exit 1
fi

# Verify stable-feature.txt exists
if [ ! -f "$REPO_DIR/stable-feature.txt" ]; then
  echo "FAIL: 'stable-feature.txt' not found in working copy."
  exit 1
fi

# Verify bug files do NOT exist
if [ -f "$REPO_DIR/bug1.txt" ] || [ -f "$REPO_DIR/bug2.txt" ]; then
  echo "FAIL: Buggy files ('bug1.txt' or 'bug2.txt') still exist in the working directory. Did you run a hard reset?"
  exit 1
fi

# Verify working directory is clean
if [ -n "$(git -C "$REPO_DIR" status --porcelain)" ]; then
  echo "FAIL: Working directory has uncommitted modifications."
  exit 1
fi

echo "PASS: Local development branch successfully aligned with remote server state!"
exit 0
