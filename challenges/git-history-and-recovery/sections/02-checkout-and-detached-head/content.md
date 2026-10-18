# Checkout & Detached HEAD

To inspect the codebase at a specific point in time or test an earlier revision, you can "checkout" an old commit.

---

## 1. Checking Out a Commit

To switch your working directory to the state of an older commit, run:

```bash
git checkout <commit-hash>
```

When you do this, Git moves the `HEAD` pointer directly to that commit rather than pointing to a branch reference. This state is known as a **detached HEAD**.

---

## 2. The Detached HEAD State

In a detached HEAD state:
- You are looking at a snapshot of history.
- You can compile, run tests, and inspect files safely.
- If you make new commits here, they won't belong to any branch. If you switch branches later without creating a branch pointer, those commits will become "orphaned" and eventually cleaned up by Git.

---

## 3. Returning to Main / Master

To safely return to the latest commit on your main workspace and reattach `HEAD` back to the branch pointer, switch back to the branch:

```bash
git switch main
```
or:
```bash
git checkout main
```
*(Use `master` if your default branch is named `master`)*.

---

## Lab Tasks

### Task 1: Checkout an Old Commit (`git-checkout-old-commit`)
1. Start the lab session:
   ```bash
   tld start git-checkout-old-commit
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Inspect the commit history to locate the second commit ("Second commit"):
   ```bash
   git log --oneline
   ```
4. Check out the second commit using its commit hash or relative reference (`main~1`):
   ```bash
   git checkout main~1
   ```
5. Confirm that HEAD is now detached at the second commit:
   ```bash
   git status
   ```
6. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Return to Main Branch (`git-return-to-main`)
1. Start the lab session:
   ```bash
   tld start git-return-to-main
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Observe that HEAD is currently detached:
   ```bash
   git status
   ```
4. Reattach HEAD by switching back to the `main` branch:
   ```bash
   git switch main
   ```
5. Confirm that HEAD is attached to `main`:
   ```bash
   git status
   ```
6. Validate your solution:
   ```bash
   tld check
   ```
