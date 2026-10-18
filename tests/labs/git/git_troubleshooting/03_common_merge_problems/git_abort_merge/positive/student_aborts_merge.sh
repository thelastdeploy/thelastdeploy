#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Aborts a Conflicted Merge
# Lab: git-abort-merge
# ==============================================================================

# Step 1: Prepare git repository with active merge conflict
student_exec \
  --step-name "Prepare repository with conflicted merge state" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'line 1' > ~/git-challenge/index.html && git -C ~/git-challenge add index.html && git -C ~/git-challenge commit -m 'Initial commit' && git -C ~/git-challenge checkout -b feature && echo 'line 1 feature' > ~/git-challenge/index.html && git -C ~/git-challenge add index.html && git -C ~/git-challenge commit -m 'Feature edit' && git -C ~/git-challenge checkout - && echo 'line 1 main' > ~/git-challenge/index.html && git -C ~/git-challenge add index.html && git -C ~/git-challenge commit -m 'Main edit' && (git -C ~/git-challenge merge feature || true)" \
  --expect-exit-code 0

# Step 2: Abort the merge to restore pre-merge state
student_exec \
  --step-name "Execute git merge --abort" \
  --cmd "cd ~/git-challenge && git merge --abort" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Conflicted merge aborted successfully and repository clean!"
