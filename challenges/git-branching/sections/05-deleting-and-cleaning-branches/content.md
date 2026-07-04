# Deleting & Cleaning Branches

As you develop more features, your repository will accumulate many branches. To keep your workspace clean and organized, you should delete feature branches once they are successfully merged.

---

## 1. Listing Branches

To list all local branches in your repository:
```bash
git branch
```

The branch marked with an asterisk `*` is the branch you are currently on.

To list both local and remote branches:
```bash
git branch -a
```

---

## 2. Deleting a Merged Branch

If a branch has already been merged into your current branch (e.g. `main`), you can safely delete it using the `-d` (lowercase) flag:

```bash
git branch -d <branch-name>
```

For example:
```bash
git branch -d feature-login
```

This acts as a safety check: if the branch has **not** been merged, Git will warn you and prevent the deletion to avoid losing work.

---

## 3. Forcing Deletion of an Unmerged Branch

If you want to discard an experimental or abandoned branch without merging it, you must use the `-D` (uppercase) flag to force deletion:

```bash
git branch -D <branch-name>
```
This skips the safety checks and permanently deletes the branch.
