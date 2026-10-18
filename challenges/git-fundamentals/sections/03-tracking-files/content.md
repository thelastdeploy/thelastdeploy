# Tracking Files

In Git, files pass through three states before being safely recorded in the history database:
1. **Working Directory**: Modifying local files that are not yet tracked or have unstaged modifications.
2. **Staging Area (Index)**: Staging files with `git add` to prepare them for the next commit.
3. **Repository (.git directory)**: Saving the staged snapshot to project history with `git commit`.

### The `git add` Command
Stages untracked or modified files, adding them to the Git index:
```bash
# Stage a specific file
git add README.md

# Stage all files in the current folder
git add .
```

### The `git commit` Command
Saves the staged snapshot of files to the local repository database. Always write a meaningful, concise commit message:
```bash
git commit -m "Initialize project with README document"
```

---

## Lab Tasks

### Task 1: Stage a Modified File (`git-stage-file`)
1. Start the lab session:
   ```bash
   tld start git-stage-file
   ```
2. Navigate to `~/git-challenge/` and stage `README.md` without committing it:
   ```bash
   cd "$HOME/git-challenge"
   git add README.md
   ```
3. Check status to verify that `README.md` is in the staging area:
   ```bash
   git status
   ```
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Commit Your Staged Changes (`git-commit-changes`)
1. Start the lab session:
   ```bash
   tld start git-commit-changes
   ```
2. Navigate to `~/git-challenge/` and commit the staged changes:
   ```bash
   cd "$HOME/git-challenge"
   git commit -m "Add README file"
   ```
3. Confirm that the working tree is clean:
   ```bash
   git status
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
