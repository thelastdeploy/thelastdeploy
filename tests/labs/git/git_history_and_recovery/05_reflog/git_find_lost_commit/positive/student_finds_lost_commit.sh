#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Finds a Lost Commit via Reflog
# Lab: git-find-lost-commit
# ==============================================================================

# Step 1: Prepare git repository with a commit discarded by hard reset
student_exec \
  --step-name "Prepare repository with discarded commit" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'hello' > ~/git-challenge/file.txt && git -C ~/git-challenge add file.txt && git -C ~/git-challenge commit -m 'Initial commit' && echo 'lost' > ~/git-challenge/lost.txt && git -C ~/git-challenge add lost.txt && git -C ~/git-challenge commit -m 'Add critical data' && git -C ~/git-challenge rev-parse HEAD > ~/git-challenge/.correct-hash && git -C ~/git-challenge reset --hard HEAD~1" \
  --expect-exit-code 0

# Step 2: Extract lost commit hash from reflog into lost-hash.txt
student_exec \
  --step-name "Extract lost commit hash via reflog" \
  --cmd "cd ~/git-challenge && git rev-parse HEAD@{1} > lost-hash.txt" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Correct lost commit hash identified and recorded!"
