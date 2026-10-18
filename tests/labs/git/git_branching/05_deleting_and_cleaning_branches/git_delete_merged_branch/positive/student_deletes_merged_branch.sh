#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Deletes a Merged Branch
# Lab: git-delete-merged-branch
# ==============================================================================

# Step 1: Prepare repository state with merged feature-old and unmerged feature-active
student_exec \
  --step-name "Prepare repository with merged and active branches" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'initial' > ~/git-challenge/file.txt && git -C ~/git-challenge add file.txt && git -C ~/git-challenge commit -m 'Initial commit' && git -C ~/git-challenge checkout -b feature-old && echo 'old' >> ~/git-challenge/file.txt && git -C ~/git-challenge commit -am 'Old changes' && git -C ~/git-challenge checkout -b feature-active && echo 'active' >> ~/git-challenge/file.txt && git -C ~/git-challenge commit -am 'Active changes' && git -C ~/git-challenge checkout main && git -C ~/git-challenge merge feature-old" \
  --expect-exit-code 0

# Step 2: Delete merged branch feature-old
student_exec \
  --step-name "Delete merged branch feature-old" \
  --cmd "cd ~/git-challenge && git branch -d feature-old" \
  --expect-exit-code 0 \
  --expect-stdout-contains "Deleted branch feature-old"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Merged branch 'feature-old' deleted successfully!"
