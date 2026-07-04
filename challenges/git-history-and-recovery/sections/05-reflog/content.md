# The Safety Net: Git Reflog

What happens if you accidentally run `git reset --hard` and lose a commit containing hours of work? Since that commit no longer appears in `git log`, is it gone forever?

In most cases, **no**. Git has a safety net called the **Reference Log** (or **Reflog**).

---

## 1. What is the Reflog?

While `git log` shows the history of the current branch, `git reflog` records **every single change to HEAD** on your local machine.

Every time you:
- Make a commit
- Switch branches
- Pull changes
- Reset branch pointers
- Checkout a detached HEAD

Git logs that transition in the reflog. The reflog entries are kept locally (typically for 30 to 90 days) and are never pushed to remote servers.

---

## 2. Using Git Reflog

To view the reference log:

```bash
git reflog
```

This displays a list of actions with reference pointers like `HEAD@{0}`, `HEAD@{1}`, etc., along with the commit hash at each step.

### Restoring Lost Work:
Once you locate the hash of the lost commit in the reflog, you can restore it:
- **By resetting back to it**:
  ```bash
  git reset --hard <lost-commit-hash>
  ```
- **By checking it out as a new branch**:
  ```bash
  git checkout -b branch-name <lost-commit-hash>
  ```
- **By cherry-picking it**:
  ```bash
  git cherry-pick <lost-commit-hash>
  ```
