#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Fixes Non-Fast-Forward Push Reject
# Lab: git-fix-non-fast-forward
# ==============================================================================

# Step 1: Prepare remote repository and local clone with diverged histories
student_exec \
  --step-name "Prepare diverged remote and local histories" \
  --cmd "rm -rf ~/git-challenge ~/git-remote-server.git ~/temp-git-repo && git init -b main --bare ~/git-remote-server.git && git init -b main ~/temp-git-repo && git -C ~/temp-git-repo config user.name 'Developer' && git -C ~/temp-git-repo config user.email 'dev@example.com' && echo 'hello' > ~/temp-git-repo/hello.txt && git -C ~/temp-git-repo add hello.txt && git -C ~/temp-git-repo commit -m 'Initial commit' && git -C ~/temp-git-repo remote add origin ~/git-remote-server.git && git -C ~/temp-git-repo push -u origin HEAD && rm -rf ~/temp-git-repo && git clone ~/git-remote-server.git ~/git-challenge && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && git init -b main ~/temp-git-repo && git -C ~/temp-git-repo config user.name 'Other Developer' && git -C ~/temp-git-repo config user.email 'other@example.com' && git -C ~/temp-git-repo remote add origin ~/git-remote-server.git && git -C ~/temp-git-repo pull origin HEAD && echo 'remote edits' > ~/temp-git-repo/remote.txt && git -C ~/temp-git-repo add remote.txt && git -C ~/temp-git-repo commit -m 'Add remote file' && git -C ~/temp-git-repo push origin HEAD && rm -rf ~/temp-git-repo && echo 'local edits' > ~/git-challenge/local.txt && git -C ~/git-challenge add local.txt && git -C ~/git-challenge commit -m 'Add local file'" \
  --expect-exit-code 0

# Step 2: Pull remote changes and push merged history
student_exec \
  --step-name "Pull and push merged history" \
  --cmd "cd ~/git-challenge && git pull origin main --no-edit && git push origin main" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Non-fast-forward push reject resolved and pushed successfully!"
