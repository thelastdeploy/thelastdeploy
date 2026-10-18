#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Tracks Remote Branch
# Lab: git-track-remote-branch
# ==============================================================================

# Step 1: Prepare remote repository with feature-team branch and local clone with fetched refs
student_exec \
  --step-name "Prepare remote repository and local clone" \
  --cmd "rm -rf ~/git-challenge ~/git-remote-server.git ~/temp-git-repo && git init -b main --bare ~/git-remote-server.git && git init -b main ~/temp-git-repo && git -C ~/temp-git-repo config user.name 'Developer' && git -C ~/temp-git-repo config user.email 'dev@example.com' && echo 'hello' > ~/temp-git-repo/hello.txt && git -C ~/temp-git-repo add hello.txt && git -C ~/temp-git-repo commit -m 'Initial commit' && git -C ~/temp-git-repo remote add origin ~/git-remote-server.git && git -C ~/temp-git-repo push -u origin HEAD && rm -rf ~/temp-git-repo && git clone ~/git-remote-server.git ~/git-challenge && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && git init -b main ~/temp-git-repo && git -C ~/temp-git-repo config user.name 'Other Developer' && git -C ~/temp-git-repo config user.email 'other@example.com' && git -C ~/temp-git-repo remote add origin ~/git-remote-server.git && git -C ~/temp-git-repo pull origin HEAD && git -C ~/temp-git-repo checkout -b feature-team && echo 'team code' > ~/temp-git-repo/team.txt && git -C ~/temp-git-repo add team.txt && git -C ~/temp-git-repo commit -m 'Add team file' && git -C ~/temp-git-repo push origin feature-team && rm -rf ~/temp-git-repo && git -C ~/git-challenge fetch origin" \
  --expect-exit-code 0

# Step 2: Switch to remote branch to create tracking branch
student_exec \
  --step-name "Switch to feature-team branch" \
  --cmd "cd ~/git-challenge && git switch feature-team" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Remote branch tracked and checked out successfully!"
