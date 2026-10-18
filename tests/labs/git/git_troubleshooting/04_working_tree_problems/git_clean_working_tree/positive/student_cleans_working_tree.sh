#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Cleans Working Tree
# Lab: git-clean-working-tree
# ==============================================================================

# Step 1: Prepare git repository with untracked files and directory
student_exec \
  --step-name "Prepare repository with untracked files" \
  --cmd "rm -rf ~/git-challenge && mkdir -p ~/git-challenge/build && git -C ~/git-challenge init -b main && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'hello' > ~/git-challenge/hello.txt && git -C ~/git-challenge add hello.txt && git -C ~/git-challenge commit -m 'Initial commit' && echo 'log data' > ~/git-challenge/debug.log && echo 'temp data' > ~/git-challenge/temp.tmp && echo 'binary' > ~/git-challenge/build/out.bin" \
  --expect-exit-code 0

# Step 2: Clean working tree using git clean -fd
student_exec \
  --step-name "Execute git clean -fd" \
  --cmd "cd ~/git-challenge && git clean -fd" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Working tree cleaned successfully!"
