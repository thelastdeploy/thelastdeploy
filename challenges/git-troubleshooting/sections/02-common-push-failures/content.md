# Common Push Failures

When sharing your local commits, push commands can fail due to remote repository state or tracking configuration errors. In this section, you will learn how to diagnose and resolve these common push rejections.

---

## 1. Non-Fast-Forward Rejections

A **non-fast-forward reject** occurs when your local branch history is behind or has diverged from the remote branch history.

If another developer pushed commits to the remote branch while you made local commits without pulling first, Git rejects your push to prevent silently overwriting the remote history.

### Resolution Workflow:
1. **Pull and Integrate**: Download remote updates and merge them into your local branch:
   ```bash
   git pull origin main --no-edit
   ```
2. **Resolve Conflicts**: If both sides edited the same lines, resolve conflicts and commit. If no overlapping edits exist, Git performs an automatic merge commit.
3. **Push**:
   ```bash
   git push origin main
   ```

---

## 2. Missing Upstream Tracking

If you create a local branch using `git switch -c <branch>`, it does not have a linked remote-tracking branch by default. Running `git push` without arguments results in:
`fatal: The current branch has no upstream branch.`

### Resolution Workflow:
Push and tell Git to establish an upstream tracking relationship using the `-u` (or `--set-upstream`) flag:
```bash
git push -u origin <branch-name>
```

On subsequent pushes, you can simply run:
```bash
git push
```

---

## Lab Tasks

### Task 1: Fix Non-Fast-Forward Reject (`git-fix-non-fast-forward`)
1. Start the lab session:
   ```bash
   tld start git-fix-non-fast-forward
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Attempt to push to observe the non-fast-forward rejection message:
   ```bash
   git push origin main
   ```
4. Pull the remote changes to integrate the remote commit into your local branch:
   ```bash
   git pull origin main --no-edit
   ```
5. Push the merged history to the remote repository:
   ```bash
   git push origin main
   ```
6. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Fix Upstream Tracking Branch (`git-fix-upstream-branch`)
1. Start the lab session:
   ```bash
   tld start git-fix-upstream-branch
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Observe that the active `dev` branch does not have an upstream tracking branch configured:
   ```bash
   git status
   ```
4. Push `dev` to the remote repository while configuring upstream tracking using the `-u` flag:
   ```bash
   git push -u origin dev
   ```
5. Confirm that upstream tracking has been configured:
   ```bash
   git branch -vv
   ```
6. Validate your solution:
   ```bash
   tld check
   ```
