#!/bin/bash
# validator.sh — git-troubleshooting / 02-common-push-failures / git-fix-upstream-branch
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
REMOTE_PATH="$HOME/git-remote-server.git"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify dev branch exists on remote
if ! git -C "$REMOTE_PATH" show-ref --verify refs/heads/dev &>/dev/null; then
  echo "FAIL: Branch 'dev' not found on remote server. Did you push it?"
  exit 1
fi

# Verify tracking configuration exists
REMOTE_TRACKING=$(git -C "$REPO_DIR" config branch.dev.remote 2>/dev/null || echo "")
MERGE_REF=$(git -C "$REPO_DIR" config branch.dev.merge 2>/dev/null || echo "")

if [ "$REMOTE_TRACKING" != "origin" ]; then
  echo "FAIL: Branch 'dev' is not configured to track origin. Did you use '-u' or '--set-upstream'?"
  exit 1
fi

if [ "$MERGE_REF" != "refs/heads/dev" ]; then
  echo "FAIL: Upstream merge target is '$MERGE_REF' (expected: 'refs/heads/dev')."
  exit 1
fi

echo "PASS: Upstream tracking branch configured and pushed successfully!"
exit 0
