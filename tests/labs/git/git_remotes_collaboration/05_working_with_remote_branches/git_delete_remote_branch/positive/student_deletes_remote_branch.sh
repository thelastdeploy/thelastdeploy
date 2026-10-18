#!/usr/bin/env bash
# ==============================================================================
# Positive Test Journey: Student Deletes Remote Branch
# Lab: git-delete-remote-branch
# ==============================================================================

# Step 1: Prepare remote repository with feature-trash branch and local clone
student_exec \
  --step-name "Prepare remote repository and local clone" \
  --cmd "rm -rf ~/git-challenge ~/git-remote-server.git ~/temp-git-repo && git init -b main --bare ~/git-remote-server.git && git init -b main ~/temp-git-repo && git -C ~/temp-git-repo config user.name 'Developer' && git -C ~/temp-git-repo config user.email 'dev@example.com' && echo 'hello' > ~/temp-git-repo/hello.txt && git -C ~/temp-git-repo add hello.txt && git -C ~/temp-git-repo commit -m 'Initial commit' && git -C ~/temp-git-repo remote add origin ~/git-remote-server.git && git -C ~/temp-git-repo push -u origin HEAD && rm -rf ~/temp-git-repo && git clone ~/git-remote-server.git ~/git-challenge && git -C ~/git-challenge config user.name 'Developer' && git -C ~/git-challenge config user.email 'dev@example.com' && git init -b main ~/temp-git-repo && git -C ~/temp-git-repo config user.name 'Other Developer' && git -C ~/temp-git-repo config user.email 'other@example.com' && git -C ~/temp-git-repo remote add origin ~/git-remote-server.git && git -C ~/temp-git-repo pull origin HEAD && git -C ~/temp-git-repo checkout -b feature-trash && echo 'trash code' > ~/temp-git-repo/trash.txt && git -C ~/temp-git-repo add trash.txt && git -C ~/temp-git-repo commit -m 'Add trash file' && git -C ~/temp-git-repo push origin feature-trash && rm -rf ~/temp-git-repo && git -C ~/git-challenge fetch origin" \
  --expect-exit-code 0

# Step 2: Delete remote branch from origin
student_exec \
  --step-name "Delete remote feature-trash branch" \
  --cmd "cd ~/git-challenge && git push origin --delete feature-trash" \
  --expect-exit-code 0

# Step 3: Validate solution via tld check
student_exec \
  --step-name "Run tld check validation" \
  --cmd "tld check" \
  --expect-exit-code 0 \
  --expect-stdout-contains "PASS: Remote branch deleted successfully!"
