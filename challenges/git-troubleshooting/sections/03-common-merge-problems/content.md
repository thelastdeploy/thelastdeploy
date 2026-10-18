# Common Merge Problems

Merge conflicts are part of collaborative coding, but sometimes a merge gets so messy or confusing that you want to start over, or you need to finalize it properly after editing conflicting lines. In this section, you will learn how to manage active merge states.

---

## 1. Aborting a Merge

If you run `git merge` and are confronted with complex conflict markers across multiple files, you might decide it is safer to stop the merge, align with your team, and try again later.

To completely cancel the merge and return your repository to the exact clean state before the merge attempt, use the `--abort` flag:

```bash
git merge --abort
```

This command removes conflict markers, clears `.git/MERGE_HEAD`, and resets the working directory to the pre-merge state.

---

## 2. Completing a Merge

If you choose to resolve the conflict:
1. Open the conflicted files.
2. Locate the conflict markers:
   ```text
   <<<<<<< HEAD
   local changes
   =======
   incoming changes
   >>>>>>> branch-name
   ```
3. Edit the file to keep the desired code, removing the conflict markers completely.
4. Stage the resolved files:
   ```bash
   git add <resolved-file>
   ```
5. Commit to complete the merge:
   ```bash
   git commit --no-edit
   ```
   (This creates a merge commit containing both branch parents).

---

## Lab Tasks

### Task 1: Abort a Conflicted Merge (`git-abort-merge`)
1. Start the lab session:
   ```bash
   tld start git-abort-merge
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Inspect the repository status to observe the active conflict:
   ```bash
   git status
   ```
4. Abort the conflicted merge:
   ```bash
   git merge --abort
   ```
5. Confirm that the repository working directory is clean:
   ```bash
   git status
   ```
6. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Finish a Conflicted Merge (`git-finish-conflicted-merge`)
1. Start the lab session:
   ```bash
   tld start git-finish-conflicted-merge
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Inspect `index.html` to see the conflict markers:
   ```bash
   cat index.html
   ```
4. Resolve the conflict by keeping both lines (`line 1 main` and `line 1 feature`) and removing all marker lines:
   ```bash
   printf "line 1 main\nline 1 feature\n" > index.html
   ```
5. Stage the resolved file:
   ```bash
   git add index.html
   ```
6. Complete the merge commit:
   ```bash
   git commit --no-edit
   ```
7. Confirm that the merge commit has been created:
   ```bash
   git log -1
   ```
8. Validate your solution:
   ```bash
   tld check
   ```
