#!/bin/bash
# validator.sh — git-remotes-collaboration / 06-sync-a-team-project / git-sync-local-and-remote
set -euo pipefail

REPO_DIR="$HOME/git-challenge"
REMOTE_PATH="$HOME/git-remote-server.git"

# Verify repository exists
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "FAIL: Git repository not found in $REPO_DIR."
  exit 1
fi

# Verify remote-update.txt is present locally (proves they pulled first)
if [ ! -f "$REPO_DIR/remote-update.txt" ]; then
  echo "FAIL: remote-update.txt not found. Did you pull the latest remote changes before starting?"
  exit 1
fi

# Verify team-feature exists on remote
if ! git -C "$REMOTE_PATH" show-ref --verify refs/heads/team-feature &>/dev/null; then
  echo "FAIL: Branch 'team-feature' not found on remote server. Did you push it?"
  exit 1
fi

# Verify tracking configuration exists
REMOTE_TRACKING=$(git -C "$REPO_DIR" config branch.team-feature.remote 2>/dev/null || echo "")
MERGE_REF=$(git -C "$REPO_DIR" config branch.team-feature.merge 2>/dev/null || echo "")

if [ "$REMOTE_TRACKING" != "origin" ]; then
  echo "FAIL: Branch 'team-feature' is not configured to track origin."
  exit 1
fi

if [ "$MERGE_REF" != "refs/heads/team-feature" ]; then
  echo "FAIL: Upstream merge target is '$MERGE_REF' (expected: 'refs/heads/team-feature')."
  exit 1
fi

# Verify feature.js exists in remote branch tree
if ! git -C "$REMOTE_PATH" cat-file -e "refs/heads/team-feature:feature.js" 2>/dev/null; then
  echo "FAIL: remote branch 'team-feature' does not contain feature.js."
  exit 1
fi

# Verify content of feature.js on remote
CONTENT=$(git -C "$REMOTE_PATH" cat-file -p "refs/heads/team-feature:feature.js")
if [ "$CONTENT" != 'console.log("team");' ]; then
  echo "FAIL: feature.js contains '$CONTENT' (expected: 'console.log(\"team\");')."
  exit 1
fi

echo "PASS: Local and remote synchronization completed successfully!"
exit 0
