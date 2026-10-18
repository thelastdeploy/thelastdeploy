# Undoing with Git Reset

The `git reset` command is used to undo commits by moving the branch pointer back in time. Git provides three modes of reset, which determine what happens to your staging area (index) and working directory changes when a commit is undone.

---

## The Three Reset Modes

Assume we want to undo the most recent commit (`HEAD~1`):

### 1. Soft Reset (`--soft`)
```bash
git reset --soft HEAD~1
```
- **Branch Pointer**: Moves back by one commit.
- **Staging Area**: **Preserved**. Changes from the undone commit remain staged in the index (ready to commit).
- **Working Directory**: **Preserved**. Your files are unmodified.

### 2. Mixed Reset (`--mixed` / Default)
```bash
git reset HEAD~1
```
*(or `git reset --mixed HEAD~1`)*
- **Branch Pointer**: Moves back by one commit.
- **Staging Area**: **Reset**. Changes are unstaged from the index.
- **Working Directory**: **Preserved**. Your files are unmodified (they appear as modified, unstaged files).

### 3. Hard Reset (`--hard`)
```bash
git reset --hard HEAD~1
```
- **Branch Pointer**: Moves back by one commit.
- **Staging Area**: **Reset**.
- **Working Directory**: **Reset**. **All changes since that commit are permanently discarded.**

> [!WARNING]
> A `git reset --hard` will permanently overwrite uncommitted changes in your working directory. Use it with extreme caution!

---

## Summary Comparison

| Mode | HEAD / Commit Pointer | Staging Area (Index) | Working Directory |
| :--- | :--- | :--- | :--- |
| **`--soft`** | Moves back | Kept staged | Kept untouched |
| **`--mixed`** (default) | Moves back | Unstaged | Kept untouched |
| **`--hard`** | Moves back | Discarded | Discarded |

---

## Lab Tasks

### Task 1: Perform a Soft Reset (`git-soft-reset`)
1. Start the lab session:
   ```bash
   tld start git-soft-reset
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Inspect the commit history:
   ```bash
   git log --oneline
   ```
4. Perform a soft reset to undo the latest commit (`HEAD~1`) while keeping changes staged:
   ```bash
   git reset --soft HEAD~1
   ```
5. Confirm that the commit was undone and `three.txt` remains staged in index:
   ```bash
   git status
   ```
6. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Perform a Mixed Reset (`git-mixed-reset`)
1. Start the lab session:
   ```bash
   tld start git-mixed-reset
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Inspect the commit history:
   ```bash
   git log --oneline
   ```
4. Perform a mixed reset to undo the latest commit (`HEAD~1`) and unstage the changes:
   ```bash
   git reset HEAD~1
   ```
5. Confirm that the commit was undone and `three.txt` appears as an unstaged untracked/modified file:
   ```bash
   git status
   ```
6. Validate your solution:
   ```bash
   tld check
   ```

### Task 3: Perform a Hard Reset (`git-hard-reset`)
1. Start the lab session:
   ```bash
   tld start git-hard-reset
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Inspect the commit history:
   ```bash
   git log --oneline
   ```
4. Perform a hard reset to undo the latest commit (`HEAD~1`) and discard all working tree changes:
   ```bash
   git reset --hard HEAD~1
   ```
5. Confirm that the working tree and staging area are completely clean:
   ```bash
   git status
   ```
6. Validate your solution:
   ```bash
   tld check
   ```
