#!/bin/bash
# validator.sh — git-remotes-collaboration / 05-working-with-remote-branches / git-track-remote-branch
set -euo pipefail

REPO_DIR="$HOME/git-challenge"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify active branch is feature-team
ACTIVE_BRANCH=$(git -C "$REPO_DIR" branch --show-current)
if [ "$ACTIVE_BRANCH" != "feature-team" ]; then
  echo "FAIL: Current active branch is '$ACTIVE_BRANCH' (expected: 'feature-team'). Please checkout the remote feature-team branch."
  exit 1
fi

# Verify tracking configuration exists
REMOTE_TRACKING=$(git -C "$REPO_DIR" config branch.feature-team.remote 2>/dev/null || echo "")
MERGE_REF=$(git -C "$REPO_DIR" config branch.feature-team.merge 2>/dev/null || echo "")

if [ "$REMOTE_TRACKING" != "origin" ]; then
  echo "FAIL: Branch 'feature-team' is not configured to track origin."
  exit 1
fi

if [ "$MERGE_REF" != "refs/heads/feature-team" ]; then
  echo "FAIL: Upstream merge target is '$MERGE_REF' (expected: 'refs/heads/feature-team')."
  exit 1
fi

echo "PASS: Remote branch tracked and checked out successfully!"
exit 0
