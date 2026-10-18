#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Compares Fetch vs Pull
# Lab: git-compare-fetch-vs-pull
# ==============================================================================

# Step 1: Prepare remote repository with feature-compare branch and local clone
student_exec \
  --step-name "Prepare remote repository and local clone" \
  --cmd "rm -rf ~/git-challenge ~/git-remote-server.git ~/temp-git-repo && git init -b main --bare ~/git-remote-server.git && git init -b main ~/temp-git-repo && git -C ~/temp-git-repo config user.name 'Developer' && git -C ~/temp-git-repo config user.email 'dev@example.com' && echo 'hello' > ~/temp-git-repo/hello.txt && git -C ~/temp-git-repo add hello.txt && git -C ~/temp-git-repo commit -m 'Initial commit' && git -C ~/temp-git-repo remote add origin ~/git-remote-server.git && git -C ~/temp-git-repo push -u origin HEAD && rm -rf ~/temp-git-repo && git clone ~/git-remote-server.git ~/git-challenge && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && git init -b main ~/temp-git-repo && git -C ~/temp-git-repo config user.name 'Other Developer' && git -C ~/temp-git-repo config user.email 'other@example.com' && git -C ~/temp-git-repo remote add origin ~/git-remote-server.git && git -C ~/temp-git-repo pull origin HEAD && git -C ~/temp-git-repo checkout -b feature-compare && echo 'compare' > ~/temp-git-repo/compare.txt && git -C ~/temp-git-repo add compare.txt && git -C ~/temp-git-repo commit -m 'Compare commit details' && git -C ~/temp-git-repo push origin feature-compare && rm -rf ~/temp-git-repo" \
  --expect-exit-code 0

# Step 2: Fetch updates and inspect remote tracking branch into fetch-log.txt
student_exec \
  --step-name "Fetch origin and record remote commit log" \
  --cmd "cd ~/git-challenge && git fetch origin && git log origin/feature-compare -1 > fetch-log.txt" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Remote changes fetched and compared successfully without merging!"
