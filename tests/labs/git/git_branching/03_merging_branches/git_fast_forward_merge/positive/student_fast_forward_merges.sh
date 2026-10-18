#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Performs Fast-Forward Merge
# Lab: git-fast-forward-merge
# ==============================================================================

# Step 1: Prepare repository state
student_exec \
  --step-name "Prepare repository with feature-ff branch ahead of main" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'initial' > ~/git-challenge/file.txt && git -C ~/git-challenge add file.txt && git -C ~/git-challenge commit -m 'Initial commit' && git -C ~/git-challenge checkout -b feature-ff && echo 'ff changes' > ~/git-challenge/ff.txt && git -C ~/git-challenge add ff.txt && git -C ~/git-challenge commit -m 'Add ff change' && git -C ~/git-challenge checkout main" \
  --expect-exit-code 0

# Step 2: Merge feature-ff into main
student_exec \
  --step-name "Perform fast-forward merge" \
  --cmd "cd ~/git-challenge && git merge feature-ff" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Fast-forward"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Fast-forward merge completed successfully!"
