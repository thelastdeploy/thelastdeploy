# Working with Remote Branches

Collaboration involves working on multiple branches that exist on the remote repository. In this section, you will learn how to track remote branches locally and how to delete remote branches once a feature has been merged or discarded.

---

## 1. Tracking a Remote Branch

When you fetch updates, Git creates read-only remote-tracking branches (like `origin/feature-team`). You cannot make commits directly onto these branches. 

To start working on a remote branch locally, you must create a local branch that tracks it.

If you check out or switch to the branch name, Git will automatically look for a matching remote-tracking branch. When found, it creates a local tracking branch linked to the remote branch:
```bash
git switch <branch-name>
```
or:
```bash
git checkout <branch-name>
```

Under the hood, this is equivalent to:
```bash
git checkout --track origin/<branch-name>
```

You can inspect your branches and their tracking upstream branches using:
```bash
git branch -vv
```

---

## 2. Deleting a Remote Branch

Once a feature is merged or abandoned, the branch pointer should be deleted not only locally but also on the remote repository to prevent branch clutter.

To delete a branch from the remote server, use `git push` with the `--delete` flag:

```bash
git push origin --delete <branch-name>
```

For example, to delete `feature-trash` from origin:
```bash
git push origin --delete feature-trash
```

This deletes the pointer on the remote repository and removes the branch from the remote server.

---

## Lab Tasks

### Task 1: Track a Remote Branch (`git-track-remote-branch`)
1. Start the lab session:
   ```bash
   tld start git-track-remote-branch
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Check out the remote branch `feature-team` so that Git creates a local tracking branch:
   ```bash
   git switch feature-team
   ```
4. Verify that your active branch is `feature-team` and that it tracks `origin/feature-team`:
   ```bash
   git branch -vv
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Delete a Remote Branch (`git-delete-remote-branch`)
1. Start the lab session:
   ```bash
   tld start git-delete-remote-branch
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Delete the `feature-trash` branch from the remote `origin` repository:
   ```bash
   git push origin --delete feature-trash
   ```
4. Confirm that the remote branch is no longer present on the server:
   ```bash
   git branch -r
   ```
5. Validate your solution:
   ```bash
   tld check
   ```
