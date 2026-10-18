#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Clones a Remote Repository
# Lab: git-clone-repository
# ==============================================================================

# Step 1: Prepare remote bare repository
student_exec \
  --step-name "Prepare remote repository" \
  --cmd "rm -rf ~/git-challenge ~/git-remote-server.git ~/temp-git-repo && git init -b main --bare ~/git-remote-server.git && git init -b main ~/temp-git-repo && git -C ~/temp-git-repo config user.name 'Developer' && git -C ~/temp-git-repo config user.email 'dev@example.com' && echo 'hello' > ~/temp-git-repo/hello.txt && git -C ~/temp-git-repo add hello.txt && git -C ~/temp-git-repo commit -m 'Initial commit' && git -C ~/temp-git-repo remote add origin ~/git-remote-server.git && git -C ~/temp-git-repo push -u origin HEAD && rm -rf ~/temp-git-repo" \
  --expect-exit-code 0

# Step 2: Clone remote repository into ~/git-challenge
student_exec \
  --step-name "Clone remote repository" \
  --cmd "git clone ~/git-remote-server.git ~/git-challenge" \
  --expect-exit-code 0 \
  --expect-stderr-contains "Cloning into"

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Remote repository cloned successfully!"
