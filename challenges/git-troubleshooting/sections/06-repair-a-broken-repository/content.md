# Repairing a Broken Repository

In complex collaborative projects, a local branch can diverge so badly from the team's official remote repository that it becomes difficult to merge, rebase, or reconcile cleanly. Commit histories become cluttered, or local edits are incompatible with new upstream architecture.

When a local branch is beyond repair, the cleanest and safest solution is to **discard all local commits on that branch and align it exactly with the remote server branch**.

---

## The Force-Reset Repair Cycle

To align your local branch `dev` to match `origin/dev` exactly, replacing all local commits:

1. **Fetch Latest Remote Data**:
   Ensure you have the latest remote metadata and commits without altering your working directory:
   ```bash
   git fetch origin
   ```
2. **Force-Reset Local Branch**:
   Move your branch pointer to point exactly at `origin/dev` and reset your working tree:
   ```bash
   git reset --hard origin/dev
   ```

This deletes all local commits on `dev` that are not present on `origin/dev`, and aligns the working tree directly with the server version.

---

## Lab Tasks

### Task 1: Recover Development Branch (`git-recover-development-branch`)
1. Start the lab session:
   ```bash
   tld start git-recover-development-branch
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Fetch updates from `origin` to synchronize remote-tracking references:
   ```bash
   git fetch origin
   ```
4. Reset your active `dev` branch to match `origin/dev`, discarding buggy local commits:
   ```bash
   git reset --hard origin/dev
   ```
5. Confirm that `stable-feature.txt` is present and buggy files (`bug1.txt`, `bug2.txt`) have been purged:
   ```bash
   ls -la
   ```
6. Validate your solution:
   ```bash
   tld check
   ```
