# The Safety Net: Git Reflog

What happens if you accidentally run `git reset --hard` and lose a commit containing hours of work? Since that commit no longer appears in `git log`, is it gone forever?

In most cases, **no**. Git has a safety net called the **Reference Log** (or **Reflog**).

---

## 1. What is the Reflog?

While `git log` displays the chronological history of the current branch, `git reflog` records **every single update to HEAD** on your local machine.

Every time you:
- Make a commit
- Switch branches
- Pull changes
- Reset branch pointers
- Checkout a detached HEAD

Git logs that transition in the reflog. Reflog entries are stored locally (typically for 30 to 90 days) and are never pushed to remote servers.

---

## 2. Using Git Reflog

To view the reference log:

```bash
git reflog
```

This displays a list of actions with reference selectors like `HEAD@{0}`, `HEAD@{1}`, etc., along with the commit hash at each step.

### Restoring Lost Work:
Once you locate the hash or selector of the lost commit in the reflog, you can restore it:
- **By resetting back to it**:
  ```bash
  git reset --hard <lost-commit-hash-or-selector>
  ```
- **By creating a new branch at that commit**:
  ```bash
  git checkout -b <branch-name> <lost-commit-hash>
  ```
- **By cherry-picking it**:
  ```bash
  git cherry-pick <lost-commit-hash>
  ```

---

## Lab Tasks

### Task 1: Find a Lost Commit (`git-find-lost-commit`)
1. Start the lab session:
   ```bash
   tld start git-find-lost-commit
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Inspect the reference log to locate the lost commit with message `"Add critical data"`:
   ```bash
   git reflog
   ```
4. Output the commit hash of the lost commit (`HEAD@{1}`) into a file named `lost-hash.txt`:
   ```bash
   git rev-parse HEAD@{1} > lost-hash.txt
   ```
5. Confirm that `lost-hash.txt` contains the commit hash:
   ```bash
   cat lost-hash.txt
   ```
6. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Restore Lost Work (`git-restore-lost-work`)
1. Start the lab session:
   ```bash
   tld start git-restore-lost-work
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Inspect the reflog to find the commit prior to the hard reset:
   ```bash
   git reflog
   ```
4. Reset `main` back to the lost commit (`HEAD@{1}`) using a hard reset:
   ```bash
   git reset --hard HEAD@{1}
   ```
5. Verify that `lost.txt` has been restored in your working directory:
   ```bash
   cat lost.txt
   ```
6. Validate your solution:
   ```bash
   tld check
   ```
