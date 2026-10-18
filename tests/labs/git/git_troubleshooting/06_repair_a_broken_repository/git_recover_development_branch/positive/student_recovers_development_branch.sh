#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Recovers Development Branch
# Lab: git-recover-development-branch
# ==============================================================================

# Step 1: Prepare remote repository with dev branch and local clone with buggy commits
student_exec \
  --step-name "Prepare remote and local diverged dev branch" \
  --cmd "rm -rf ~/git-challenge ~/git-remote-server.git ~/temp-git-repo && git init -b main --bare ~/git-remote-server.git && git init -b main ~/temp-git-repo && git -C ~/temp-git-repo config user.name 'Developer' && git -C ~/temp-git-repo config user.email 'dev@example.com' && echo 'hello' > ~/temp-git-repo/hello.txt && git -C ~/temp-git-repo add hello.txt && git -C ~/temp-git-repo commit -m 'Initial commit' && git -C ~/temp-git-repo remote add origin ~/git-remote-server.git && git -C ~/temp-git-repo push -u origin HEAD && rm -rf ~/temp-git-repo && git clone ~/git-remote-server.git ~/git-challenge && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && git init -b main ~/temp-git-repo && git -C ~/temp-git-repo config user.name 'Other Developer' && git -C ~/temp-git-repo config user.email 'other@example.com' && git -C ~/temp-git-repo remote add origin ~/git-remote-server.git && git -C ~/temp-git-repo pull origin HEAD && git -C ~/temp-git-repo checkout -b dev && echo 'stable content' > ~/temp-git-repo/stable-feature.txt && git -C ~/temp-git-repo add stable-feature.txt && git -C ~/temp-git-repo commit -m 'Add stable feature' && git -C ~/temp-git-repo push origin dev && rm -rf ~/temp-git-repo && git -C ~/git-challenge checkout -b dev && echo 'bug 1' > ~/git-challenge/bug1.txt && git -C ~/git-challenge add bug1.txt && git -C ~/git-challenge commit -m 'Add bug 1' && echo 'bug 2' > ~/git-challenge/bug2.txt && git -C ~/git-challenge add bug2.txt && git -C ~/git-challenge commit -m 'Add bug 2'" \
  --expect-exit-code 0

# Step 2: Fetch remote origin and reset hard to origin/dev
student_exec \
  --step-name "Fetch origin and hard reset to origin/dev" \
  --cmd "cd ~/git-challenge && git fetch origin && git reset --hard origin/dev" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Local development branch successfully aligned with remote server state!"
