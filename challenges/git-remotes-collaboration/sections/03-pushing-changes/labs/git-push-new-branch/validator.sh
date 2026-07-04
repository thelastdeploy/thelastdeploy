#!/bin/bash
# validator.sh — git-remotes-collaboration / 03-pushing-changes / git-push-new-branch
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
REMOTE_PATH="$HOME/git-remote-server.git"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify feature-login exists on remote
if ! git -C "$REMOTE_PATH" show-ref --verify refs/heads/feature-login &>/dev/null; then
  echo "FAIL: Branch 'feature-login' not found on the remote repository."
  exit 1
fi

# Verify tracking configuration exists
REMOTE_TRACKING=$(git -C "$REPO_DIR" config branch.feature-login.remote 2>/dev/null || echo "")
MERGE_REF=$(git -C "$REPO_DIR" config branch.feature-login.merge 2>/dev/null || echo "")

if [ "$REMOTE_TRACKING" != "origin" ]; then
  echo "FAIL: Branch 'feature-login' is not configured to track remote branch. Did you use '-u' or '--set-upstream'?"
  exit 1
fi

if [ "$MERGE_REF" != "refs/heads/feature-login" ]; then
  echo "FAIL: Upstream merge target is '$MERGE_REF' (expected: 'refs/heads/feature-login')."
  exit 1
fi

echo "PASS: New local branch pushed and tracking configured successfully!"
exit 0
