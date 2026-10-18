#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Finishes a Conflicted Merge
# Lab: git-finish-conflicted-merge
# ==============================================================================

# Step 1: Prepare git repository with active merge conflict
student_exec \
  --step-name "Prepare repository with conflicted merge state" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'line 1' > ~/git-challenge/index.html && git -C ~/git-challenge add index.html && git -C ~/git-challenge commit -m 'Initial commit' && git -C ~/git-challenge checkout -b feature && echo 'line 1 feature' > ~/git-challenge/index.html && git -C ~/git-challenge add index.html && git -C ~/git-challenge commit -m 'Feature edit' && git -C ~/git-challenge checkout - && echo 'line 1 main' > ~/git-challenge/index.html && git -C ~/git-challenge add index.html && git -C ~/git-challenge commit -m 'Main edit' && (git -C ~/git-challenge merge feature || true)" \
  --expect-exit-code 0

# Step 2: Resolve conflict by keeping both lines, stage, and commit
student_exec \
  --step-name "Resolve conflict and commit merge" \
  --cmd "cd ~/git-challenge && printf 'line 1 main\nline 1 feature\n' > index.html && git add index.html && git commit --no-edit" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Conflicted merge resolved and committed successfully!"
