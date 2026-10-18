#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Fixes Upstream Tracking Branch
# Lab: git-fix-upstream-branch
# ==============================================================================

# Step 1: Prepare remote repository and local clone with untracked dev branch
student_exec \
  --step-name "Prepare repository with untracked dev branch" \
  --cmd "rm -rf ~/git-challenge ~/git-remote-server.git ~/temp-git-repo && git init -b main --bare ~/git-remote-server.git && git init -b main ~/temp-git-repo && git -C ~/temp-git-repo config user.name 'Developer' && git -C ~/temp-git-repo config user.email 'dev@example.com' && echo 'hello' > ~/temp-git-repo/hello.txt && git -C ~/temp-git-repo add hello.txt && git -C ~/temp-git-repo commit -m 'Initial commit' && git -C ~/temp-git-repo remote add origin ~/git-remote-server.git && git -C ~/temp-git-repo push -u origin HEAD && rm -rf ~/temp-git-repo && git clone ~/git-remote-server.git ~/git-challenge && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && git -C ~/git-challenge checkout -b dev && echo 'dev edits' > ~/git-challenge/dev.txt && git -C ~/git-challenge add dev.txt && git -C ~/git-challenge commit -m 'Add dev file'" \
  --expect-exit-code 0

# Step 2: Push dev branch with upstream tracking
student_exec \
  --step-name "Push dev branch with -u upstream tracking" \
  --cmd "cd ~/git-challenge && git push -u origin dev" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Upstream tracking branch configured and pushed successfully!"
