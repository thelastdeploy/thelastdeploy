# Synchronizing a Team Project

In a real development team, synchronizing your code with your colleagues is a daily cycle. Let's look at the standard process to safely sync your local changes with a remote repository.

---

## The Synchronization Cycle

1. **Pull Latest Changes**: Before starting new work, pull updates from the server to ensure your local history is aligned with the remote:
   ```bash
   git pull origin main
   ```
2. **Create a Local Feature Branch**: Isolate your new feature onto its own branch:
   ```bash
   git switch -c <branch-name>
   ```
3. **Commit Your Work**: Add and commit your files:
   ```bash
   git add <filename>
   git commit -m "Implement feature description"
   ```
4. **Push and Set Upstream**: Upload your branch, mapping it to origin:
   ```bash
   git push -u origin <branch-name>
   ```
5. **Merge (on server/PR)**: Typically, changes are reviewed and merged on the server via Pull Requests. Once merged, the feature branch can be deleted remotely and locally.

Always pulling before coding is the best practice to prevent merge conflicts.

---

## Lab Tasks

### Task 1: Sync Local and Remote Project (`git-sync-local-and-remote`)
1. Start the lab session:
   ```bash
   tld start git-sync-local-and-remote
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Pull the latest remote updates from `origin main`:
   ```bash
   git pull origin main
   ```
4. Verify that `remote-update.txt` has been received in your working copy:
   ```bash
   ls -la
   ```
5. Create and switch to a new branch named `team-feature`:
   ```bash
   git switch -c team-feature
   ```
6. Create `feature.js` with the required JavaScript statement:
   ```bash
   echo 'console.log("team");' > feature.js
   ```
7. Stage and commit the new file:
   ```bash
   git add feature.js
   git commit -m "Add team feature implementation"
   ```
8. Push the `team-feature` branch to `origin` and establish upstream tracking with `-u`:
   ```bash
   git push -u origin team-feature
   ```
9. Validate your solution:
   ```bash
   tld check
   ```
