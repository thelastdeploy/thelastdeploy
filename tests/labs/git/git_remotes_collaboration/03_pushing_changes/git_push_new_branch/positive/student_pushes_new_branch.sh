#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Pushes a New Local Branch
# Lab: git-push-new-branch
# ==============================================================================

# Step 1: Prepare remote repository and local clone with feature-login branch
student_exec \
  --step-name "Prepare repository with feature-login branch" \
  --cmd "rm -rf ~/git-challenge ~/git-remote-server.git ~/temp-git-repo && git init -b main --bare ~/git-remote-server.git && git init -b main ~/temp-git-repo && git -C ~/temp-git-repo config user.name 'Developer' && git -C ~/temp-git-repo config user.email 'dev@example.com' && echo 'hello' > ~/temp-git-repo/hello.txt && git -C ~/temp-git-repo add hello.txt && git -C ~/temp-git-repo commit -m 'Initial commit' && git -C ~/temp-git-repo remote add origin ~/git-remote-server.git && git -C ~/temp-git-repo push -u origin HEAD && rm -rf ~/temp-git-repo && git clone ~/git-remote-server.git ~/git-challenge && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && git -C ~/git-challenge checkout -b feature-login && echo 'console.log(\"login\");' > ~/git-challenge/login.js && git -C ~/git-challenge add login.js && git -C ~/git-challenge commit -m 'Add login file'" \
  --expect-exit-code 0

# Step 2: Push new branch with upstream tracking
student_exec \
  --step-name "Push feature-login branch with -u" \
  --cmd "cd ~/git-challenge && git push -u origin feature-login" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: New local branch pushed and tracking configured successfully!"
