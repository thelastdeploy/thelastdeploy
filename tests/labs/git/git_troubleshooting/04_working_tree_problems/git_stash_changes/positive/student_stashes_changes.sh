#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Stashes Local Modifications
# Lab: git-stash-changes
# ==============================================================================

# Step 1: Prepare git repository with unstaged changes in tracked file
student_exec \
  --step-name "Prepare repository with unstaged changes" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'hello' > ~/git-challenge/hello.txt && git -C ~/git-challenge add hello.txt && git -C ~/git-challenge commit -m 'Initial commit' && echo 'stash me' > ~/git-challenge/hello.txt" \
  --expect-exit-code 0

# Step 2: Stash changes using git stash
student_exec \
  --step-name "Execute git stash" \
  --cmd "cd ~/git-challenge && git stash" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Changes stashed successfully!"
