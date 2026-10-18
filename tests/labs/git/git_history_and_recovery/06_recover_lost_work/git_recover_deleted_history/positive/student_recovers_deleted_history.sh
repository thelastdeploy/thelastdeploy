#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Deleted Branch History
# Lab: git-recover-deleted-history
# ==============================================================================

# Step 1: Prepare git repository with deleted experimental branch
student_exec \
  --step-name "Prepare repository with deleted branch" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'hello' > ~/git-challenge/file.txt && git -C ~/git-challenge add file.txt && git -C ~/git-challenge commit -m 'Initial commit' && git -C ~/git-challenge checkout -b experimental && echo 'experimental ideas' > ~/git-challenge/experiment.txt && git -C ~/git-challenge add experiment.txt && git -C ~/git-challenge commit -m 'Add experiment file' && git -C ~/git-challenge rev-parse HEAD > ~/git-challenge/.correct-hash && (git -C ~/git-challenge checkout master 2>/dev/null || git -C ~/git-challenge checkout main) && git -C ~/git-challenge branch -D experimental" \
  --expect-exit-code 0

# Step 2: Restore deleted branch as experimental-restored using reflog entry HEAD@{1}
student_exec \
  --step-name "Create experimental-restored branch from reflog" \
  --cmd "cd ~/git-challenge && git branch experimental-restored HEAD@{1}" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Deleted branch successfully recovered and restored!"
