# Checkout & Detached HEAD

To inspect the codebase at a specific point in time, you can "checkout" an old commit.

---

## 1. Checking Out a Commit

To switch your working directory to the state of an older commit, run:

```bash
git checkout <commit-hash>
```

When you do this, Git moves the `HEAD` pointer directly to that commit rather than pointing to a branch name. This state is called a **detached HEAD**.

---

## 2. The Detached HEAD State

In a detached HEAD state:
- You are looking at a snapshot of history.
- You can compile, run tests, and inspect files safely.
- If you make new commits here, they won't belong to any branch. If you switch branches, those commits will become "orphaned" and eventually deleted by Git's garbage collection.

---

## 3. Returning to Main/Master

To safely return to the latest commit on your main workspace and attach `HEAD` back to the branch pointer, check out the branch name again:

```bash
git switch main
```
or:
```bash
git checkout main
```
(Replace `main` with `master` if that is your default branch name).
