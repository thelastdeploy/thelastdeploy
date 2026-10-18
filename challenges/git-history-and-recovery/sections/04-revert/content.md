# Undoing with Git Revert

While `git reset` rewrites history by moving branch pointers backward, modifying history on shared branches can cause significant synchronization errors for team members.

To undo changes in shared history safely without rewriting past commits, Git provides **`git revert`**.

---

## 1. How Git Revert Works

`git revert` does not delete or alter any existing commits. Instead, it computes the changes introduced by a specific commit, inverses those changes, and creates a **brand new commit** applying the inverse.

```bash
git revert <commit-hash>
```

For example, to revert the latest commit (`HEAD`):
```bash
git revert HEAD --no-edit
```

The `--no-edit` flag accepts the default generated commit message (e.g. `Revert "Add API key config"`).

---

## 2. Reverting Multiple Commits

You can revert multiple commits in sequence. If you want to undo multiple commits together without creating a separate revert commit for each one, use the `-n` (or `--no-commit`) flag:

```bash
git revert --no-commit <commit-hash-1> <commit-hash-2>
```

This applies the inverse changes of the specified commits to your staging area and working directory, letting you inspect the final state and create a single consolidated commit manually.

---

## Lab Tasks

### Task 1: Revert a Bad Commit (`git-revert-bad-commit`)
1. Start the lab session:
   ```bash
   tld start git-revert-bad-commit
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Inspect the commit history:
   ```bash
   git log --oneline
   ```
4. Revert the latest commit that accidentally introduced the sensitive API key:
   ```bash
   git revert HEAD --no-edit
   ```
5. Confirm that `app.config` no longer contains `api_key` while retaining valid configurations:
   ```bash
   cat app.config
   ```
6. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Revert Multiple Commits (`git-revert-multiple-commits`)
1. Start the lab session:
   ```bash
   tld start git-revert-multiple-commits
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Inspect the commit history:
   ```bash
   git log --oneline
   ```
4. Revert the last two commits (`HEAD` and `HEAD~1`) without auto-committing:
   ```bash
   git revert --no-commit HEAD HEAD~1
   ```
5. Confirm the staging area has staged the deletions of `three.txt` and `four.txt`:
   ```bash
   git status
   ```
6. Create a single commit with the exact commit message:
   ```bash
   git commit -m "Revert last two features"
   ```
7. Validate your solution:
   ```bash
   tld check
   ```
