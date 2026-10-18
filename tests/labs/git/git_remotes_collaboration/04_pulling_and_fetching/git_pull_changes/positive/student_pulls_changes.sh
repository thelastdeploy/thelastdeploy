#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Pulls Remote Changes
# Lab: git-pull-changes
# ==============================================================================

# Step 1: Prepare remote repository and local clone with remote update
student_exec \
  --step-name "Prepare remote repository and local clone" \
  --cmd "rm -rf ~/git-challenge ~/git-remote-server.git ~/temp-git-repo && git init -b main --bare ~/git-remote-server.git && git init -b main ~/temp-git-repo && git -C ~/temp-git-repo config user.name 'Developer' && git -C ~/temp-git-repo config user.email 'dev@example.com' && echo 'hello' > ~/temp-git-repo/hello.txt && git -C ~/temp-git-repo add hello.txt && git -C ~/temp-git-repo commit -m 'Initial commit' && git -C ~/temp-git-repo remote add origin ~/git-remote-server.git && git -C ~/temp-git-repo push -u origin HEAD && rm -rf ~/temp-git-repo && git clone ~/git-remote-server.git ~/git-challenge && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && git init -b main ~/temp-git-repo && git -C ~/temp-git-repo config user.name 'Other Developer' && git -C ~/temp-git-repo config user.email 'other@example.com' && git -C ~/temp-git-repo remote add origin ~/git-remote-server.git && git -C ~/temp-git-repo pull origin HEAD && echo 'updates from server' > ~/temp-git-repo/update.txt && git -C ~/temp-git-repo add update.txt && git -C ~/temp-git-repo commit -m 'Add updates on server' && git -C ~/temp-git-repo push origin HEAD && rm -rf ~/temp-git-repo" \
  --expect-exit-code 0

# Step 2: Pull changes from origin main
student_exec \
  --step-name "Pull changes from origin main" \
  --cmd "cd ~/git-challenge && git pull origin main" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Remote changes pulled and integrated successfully!"
