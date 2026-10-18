#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Merges a Feature Branch
# Lab: git-merge-feature
# ==============================================================================

# Step 1: Prepare repository state with diverged branches
student_exec \
  --step-name "Prepare repository with diverged feature-abc branch" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'initial' > ~/git-challenge/file.txt && git -C ~/git-challenge add file.txt && git -C ~/git-challenge commit -m 'Initial commit' && git -C ~/git-challenge checkout -b feature-abc && echo 'feature changes' > ~/git-challenge/feature.txt && git -C ~/git-challenge add feature.txt && git -C ~/git-challenge commit -m 'Add feature' && git -C ~/git-challenge checkout main && echo 'main changes' > ~/git-challenge/main.txt && git -C ~/git-challenge add main.txt && git -C ~/git-challenge commit -m 'Update main'" \
  --expect-exit-code 0

# Step 2: Merge feature-abc into main
student_exec \
  --step-name "Merge feature-abc branch" \
  --cmd "cd ~/git-challenge && git merge feature-abc -m 'Merge feature-abc into main'" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Branch 'feature-abc' merged into 'main' successfully!"
