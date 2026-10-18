#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Inspects Remote Properties
# Lab: git-inspect-remote
# ==============================================================================

# Step 1: Prepare cloned repository state
student_exec \
  --step-name "Prepare cloned repository" \
  --cmd "rm -rf ~/git-challenge ~/git-remote-server.git ~/temp-git-repo && git init -b main --bare ~/git-remote-server.git && git init -b main ~/temp-git-repo && git -C ~/temp-git-repo config user.name 'Developer' && git -C ~/temp-git-repo config user.email 'dev@example.com' && echo 'hello' > ~/temp-git-repo/hello.txt && git -C ~/temp-git-repo add hello.txt && git -C ~/temp-git-repo commit -m 'Initial commit' && git -C ~/temp-git-repo remote add origin ~/git-remote-server.git && git -C ~/temp-git-repo push -u origin HEAD && rm -rf ~/temp-git-repo && git clone ~/git-remote-server.git ~/git-challenge" \
  --expect-exit-code 0

# Step 2: Save remote verbose details to remote-details.txt
student_exec \
  --step-name "Inspect and save remote details" \
  --cmd "cd ~/git-challenge && git remote -v > remote-details.txt" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Remote repository details inspected and recorded successfully!"
