# Reading Git Errors

When a Git command fails, it outputs diagnostic error messages directly to the terminal. Many developers panic and copy-paste commands without reading these messages, but Git usually provides precise instructions on *why* it failed and *how* to fix it.

---

## Common Git Error Messages

### 1. `fatal: not a git repository (or any of the parent directories): .git`
- **Cause**: You are running a Git command outside of a Git-initialized folder.
- **Fix**: Check your working directory with `pwd`, change directory into your project with `cd`, or initialize the repository with `git init`.

### 2. `error: pathspec 'filename' did not match any file(s) known to git`
- **Cause**: You ran a command targeting a file path that Git cannot find (or is misspelled).
- **Fix**: Run `ls` to check the file spelling, make sure the relative path is correct, or check status with `git status`.

### 3. `fatal: The current branch has no upstream branch.`
- **Cause**: You are pushing a newly created local branch that does not exist on the remote server yet.
- **Fix**: Run `git push --set-upstream origin <branch-name>` (or `-u`) to link it to a remote branch.

### 4. `error: failed to push some refs to... [rejected - non-fast-forward]`
- **Cause**: The remote repository has commits that you do not have locally. Git prevents you from overwriting remote work.
- **Fix**: Run `git pull` to fetch and merge the remote changes, resolve conflicts if any, and push again.
