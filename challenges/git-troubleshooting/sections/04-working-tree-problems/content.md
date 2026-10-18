# Working Tree Problems

When writing code, you often end up with untracked junk files, uncommitted edits in files that you want to throw away, or unfinished modifications that prevent you from switching branches. Git provides powerful tools to clean, restore, and stash changes.

---

## 1. Purging Untracked Files (`git clean`)

Untracked files are files in your working directory that are not tracked by Git and are not ignored by `.gitignore`. To delete them:

```bash
git clean -f
```
To also delete untracked directories, use the `-d` flag:
```bash
git clean -fd
```
Use `git clean -n` or `git clean -nd` to perform a **dry run** to inspect what files would be removed before running the actual deletion.

---

## 2. Discarding Local Modifications (`git restore`)

If you edit a tracked file and realize the edits are incorrect, you can restore the file to the state of the last committed index:

```bash
git restore <file-path>
```
*(In older Git versions, developers used `git checkout -- <file-path>` which achieves the same result)*.

---

## 3. Stashing Unfinished Work (`git stash`)

If you need to switch branches or pull changes, but have uncommitted modifications that you do not want to commit yet, you can **stash** them.

To shelf modifications to a clean stack:
```bash
git stash
```

This restores your working directory to a clean HEAD state. Once you are ready to recover your edits:
```bash
git stash pop
```
(This restores the stashed modifications and removes them from the stash stack).
To view all active stashes:
```bash
git stash list
```

---

## Lab Tasks

### Task 1: Clean Working Tree (`git-clean-working-tree`)
1. Start the lab session:
   ```bash
   tld start git-clean-working-tree
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Inspect the untracked files and directories:
   ```bash
   git status
   ```
4. Perform a dry-run to preview what will be removed:
   ```bash
   git clean -nd
   ```
5. Remove all untracked files and directories forcefully:
   ```bash
   git clean -fd
   ```
6. Confirm that only tracked files remain:
   ```bash
   git status
   ```
7. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Restore a Tracked File (`git-restore-file`)
1. Start the lab session:
   ```bash
   tld start git-restore-file
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Inspect the unstaged modifications in `app.js`:
   ```bash
   git diff app.js
   ```
4. Restore `app.js` to its committed state, discarding local edits:
   ```bash
   git restore app.js
   ```
5. Confirm that `app.js` has been restored to stable code:
   ```bash
   git status
   ```
6. Validate your solution:
   ```bash
   tld check
   ```

### Task 3: Stash Local Modifications (`git-stash-changes`)
1. Start the lab session:
   ```bash
   tld start git-stash-changes
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Inspect the unstaged modifications in `hello.txt`:
   ```bash
   git status
   ```
4. Save the uncommitted changes to the stash stack:
   ```bash
   git stash
   ```
5. Confirm that the working directory is now clean:
   ```bash
   git status
   ```
6. Verify that your changes are saved in the stash list:
   ```bash
   git stash list
   ```
7. Validate your solution:
   ```bash
   tld check
   ```
