# Pulling & Fetching Updates

When working in a team, other developers will push changes to the remote repository. To incorporate their work into your local project copy, you must download those changes from the server.

Git offers two commands to download remote changes: `git fetch` and `git pull`.

---

## 1. Git Fetch (Safe Download)

`git fetch` downloads all new history, commits, and branches from the remote repository to your local computer.

```bash
git fetch <remote-name>
```

### Key Characteristic:
- `git fetch` **does not modify your working directory**.
- It updates your **remote-tracking branches** (like `origin/main` or `origin/feature-compare`).
- This makes it completely safe: you can inspect what others did (using `git log origin/main` or comparing changes) without risk of conflicts or merging into your current branch.

---

## 2. Git Pull (Download & Integrate)

`git pull` downloads remote changes and **immediately integrates** them into your current local branch.

```bash
git pull <remote-name> <branch-name>
```

### Under the Hood:
Under the hood, `git pull` is a shortcut that performs two operations:
1. `git fetch`: Download remote updates.
2. `git merge`: Merge the remote-tracking branch into your current branch.

Because `git pull` automatically runs a merge, it can result in **merge conflicts** if your local changes overlap with the remote changes.

---

## 3. Comparing Fetch vs Pull

| Feature | `git fetch` | `git pull` |
| :--- | :--- | :--- |
| **Working Directory** | Untouched | Updated with merged commits |
| **Safety** | Completely safe; inspect before merging | Automatic merge; potential conflicts |
| **Command Equivalent**| Fetches remote refs | `git fetch` followed immediately by `git merge` |
| **Inspection Workflow** | `git fetch origin` followed by `git log origin/<branch>` | Direct merge into current working branch |

---

## Lab Tasks

### Task 1: Fetch Remote Updates (`git-fetch-updates`)
1. Start the lab session:
   ```bash
   tld start git-fetch-updates
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Fetch updates from the remote repository without merging:
   ```bash
   git fetch origin
   ```
4. Verify that the remote tracking branch has been updated while leaving your local working directory untouched:
   ```bash
   git status
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Pull Remote Changes (`git-pull-changes`)
1. Start the lab session:
   ```bash
   tld start git-pull-changes
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Pull and integrate remote commits into your active `main` branch:
   ```bash
   git pull origin main
   ```
4. Verify that the working directory received the new files:
   ```bash
   ls -la
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 3: Compare Fetch vs Pull (`git-compare-fetch-vs-pull`)
1. Start the lab session:
   ```bash
   tld start git-compare-fetch-vs-pull
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Fetch the new branches from the remote without creating a local branch:
   ```bash
   git fetch origin
   ```
4. Inspect the remote branch `origin/feature-compare` and save its commit details to `fetch-log.txt`:
   ```bash
   git log origin/feature-compare -1 > fetch-log.txt
   ```
5. Confirm `fetch-log.txt` contains the remote commit message:
   ```bash
   cat fetch-log.txt
   ```
6. Validate your solution:
   ```bash
   tld check
   ```
