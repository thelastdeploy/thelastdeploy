# Fixing Accidental Mistakes

Everyone makes mistakes. Committing changes to the wrong branch, committing too early, or accidentally committing sensitive credentials like passwords are very common scenarios. In this section, you will learn how to rectify these problems cleanly.

---

## 1. Committing to the Wrong Branch

If you accidentally commit work directly to `main` (or `master`) instead of a separate feature branch `feature-login`:
1. Create the new branch at your current HEAD (copying the commit):
   ```bash
   git branch feature-login
   ```
2. Reset `main` back by one commit, removing the accidental commit from the default branch:
   ```bash
   git reset --hard HEAD~1
   ```
This leaves `main` clean while preserving the commit safely on `feature-login`.

---

## 2. Undoing the Latest Local Commit

If you committed too early or want to edit your staged index before recommitting:
```bash
git reset --soft HEAD~1
```
This moves the branch pointer back by one commit, but keeps all file modifications staged in the index (ready to commit).

---

## 3. Removing Sensitive Files from History

If you committed a secret file `password.txt` in the latest commit, simply running `git rm password.txt` deletes the file moving forward, but **leaves the credential in commit history**.

To purge it from the current branch's latest commit entirely:
1. Untrack the file from Git index:
   ```bash
   git rm --cached password.txt
   ```
2. Add it to `.gitignore` to prevent tracking:
   ```bash
   echo "password.txt" >> .gitignore
   git add .gitignore
   ```
3. Amend your last commit to replace the commit without `password.txt`:
   ```bash
   git commit --amend --no-edit
   ```
This overwrites your last commit, replacing it with a clean commit that excludes `password.txt` while keeping the file on your local machine.

---

## Lab Tasks

### Task 1: Fix Commit on Wrong Branch (`git-wrong-branch-fix`)
1. Start the lab session:
   ```bash
   tld start git-wrong-branch-fix
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Inspect the commit history on `main`:
   ```bash
   git log --oneline
   ```
4. Create the branch `feature-login` at current HEAD:
   ```bash
   git branch feature-login
   ```
5. Reset `main` back to the initial commit:
   ```bash
   git reset --hard HEAD~1
   ```
6. Verify that `main` is clean and `feature-login` contains the login feature:
   ```bash
   git log --oneline feature-login
   ```
7. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Undo the Last Commit (`git-undo-last-commit`)
1. Start the lab session:
   ```bash
   tld start git-undo-last-commit
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Inspect the commit history:
   ```bash
   git log --oneline
   ```
4. Undo the last commit while preserving changes staged in the index:
   ```bash
   git reset --soft HEAD~1
   ```
5. Confirm that `three.txt` remains staged:
   ```bash
   git status
   ```
6. Validate your solution:
   ```bash
   tld check
   ```

### Task 3: Remove Sensitive File (`git-remove-sensitive-file`)
1. Start the lab session:
   ```bash
   tld start git-remove-sensitive-file
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Remove `password.txt` from the staging index:
   ```bash
   git rm --cached password.txt
   ```
4. Add `password.txt` to `.gitignore` and stage `.gitignore`:
   ```bash
   echo "password.txt" >> .gitignore
   git add .gitignore
   ```
5. Amend the latest commit to overwrite history without the password file:
   ```bash
   git commit --amend --no-edit
   ```
6. Verify that `password.txt` still exists locally as an ignored file:
   ```bash
   cat password.txt
   ```
7. Validate your solution:
   ```bash
   tld check
   ```
