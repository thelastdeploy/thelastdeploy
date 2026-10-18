# Recovering Lost Branches & Commits

One of the most stressful experiences in software development is accidentally deleting a branch containing unmerged changes. Because the branch pointer is deleted, it no longer appears in your branch list (`git branch`).

However, as long as commits were created in that branch, Git still keeps the commit objects in its internal database, and the checkout history remains in your local **reflog**.

---

## Restoring a Deleted Branch

Let's assume you had a branch named `experimental` that was deleted using `git branch -D experimental`.

To restore this branch:
1. Run `git reflog` to view your HEAD moves history.
2. Look for the last transition onto or within that branch (e.g. `checkout: moving from experimental to main` or `commit: Add experiment file`).
3. Note the commit hash or selector associated with that entry (e.g. `HEAD@{1}`).
4. Recreate the branch pointing exactly at that commit:
   ```bash
   git branch experimental-restored <commit-hash-or-selector>
   ```

Now, the branch `experimental-restored` points to that commit, restoring your files and commit history!

---

## Lab Tasks

### Task 1: Recover Deleted History (`git-recover-deleted-history`)
1. Start the lab session:
   ```bash
   tld start git-recover-deleted-history
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Inspect the reference log to find the commit where the experiment was committed (`"Add experiment file"`):
   ```bash
   git reflog
   ```
4. Recreate the branch with the name `experimental-restored` pointing to that commit:
   ```bash
   git branch experimental-restored HEAD@{1}
   ```
   *(or use the specific commit hash found in your reflog output)*
5. Verify that `experimental-restored` is listed and points to the experiment commit:
   ```bash
   git log --oneline experimental-restored
   ```
6. Validate your solution:
   ```bash
   tld check
   ```
