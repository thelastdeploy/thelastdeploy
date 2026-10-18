#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Pushes Changes to Remote
# Lab: git-first-push
# ==============================================================================

# Step 1: Prepare remote repository and local clone with unpushed commit
student_exec \
  --step-name "Prepare repository with unpushed commit" \
  --cmd "rm -rf ~/git-challenge ~/git-remote-server.git ~/temp-git-repo && git init -b main --bare ~/git-remote-server.git && git init -b main ~/temp-git-repo && git -C ~/temp-git-repo config user.name 'Developer' && git -C ~/temp-git-repo config user.email 'dev@example.com' && echo 'hello' > ~/temp-git-repo/hello.txt && git -C ~/temp-git-repo add hello.txt && git -C ~/temp-git-repo commit -m 'Initial commit' && git -C ~/temp-git-repo remote add origin ~/git-remote-server.git && git -C ~/temp-git-repo push -u origin HEAD && rm -rf ~/temp-git-repo && git clone ~/git-remote-server.git ~/git-challenge && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && echo 'new feature' > ~/git-challenge/features.txt && git -C ~/git-challenge add features.txt && git -C ~/git-challenge commit -m 'Add local feature'" \
  --expect-exit-code 0

# Step 2: Push changes to remote origin
student_exec \
  --step-name "Push commits to origin main" \
  --cmd "cd ~/git-challenge && git push origin main" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Changes successfully pushed to the remote repository!"
