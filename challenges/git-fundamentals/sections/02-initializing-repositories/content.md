# Initializing Repositories

To start tracking a project with Git, you must initialize a Git repository in the project's root directory.

### The `git init` Command
Running `git init` converts an existing, unversioned directory into a Git repository or creates a new empty repository.
This command creates a hidden directory named `.git` in the project root. This `.git` folder contains all the Git metadata, objects, refs, and configuration settings that track your project changes.

```bash
# Initialize a repository in the current directory
git init

# Or initialize a repository inside a specific directory
git init my-project
```

---

## Lab Tasks

### Task 1: Initialize a New Repository (`git-create-repository`)
1. Start the lab session:
   ```bash
   tld start git-create-repository
   ```
2. Navigate to `~/git-challenge/` and initialize the repository:
   ```bash
   cd "$HOME/git-challenge"
   git init
   ```
3. Verify that the hidden `.git/` folder has been generated:
   ```bash
   ls -la "$HOME/git-challenge/.git"
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
