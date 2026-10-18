# Finish a Feature

Now that you've learned individual branching, merging, and deleting commands, let's tie them all together into a standard, cohesive Git workflow used by developers every day.

---

## The Feature Branch Workflow

Whenever you start working on a new feature or fix:
1. **Create and switch** to a clean feature branch:
   ```bash
   git switch -c feature-name
   ```
2. **Work and commit** your changes in the branch:
   ```bash
   git add .
   git commit -m "Describe your changes"
   ```
3. **Switch back** to the main branch:
   ```bash
   git switch main
   ```
4. **Merge** your feature branch changes:
   ```bash
   git merge feature-name
   ```
5. **Delete** the local feature branch once it has been successfully integrated:
   ```bash
   git branch -d feature-name
   ```

Following this workflow ensures that the main branch remains clean and deployable at all times.

---

## Lab Tasks

### Task 1: Complete Feature Workflow (`git-complete-feature-workflow`)
1. Start the lab session:
   ```bash
   tld start git-complete-feature-workflow
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Create and switch to a new branch named `auth-feature`:
   ```bash
   git switch -c auth-feature
   ```
4. Create the file `auth.js` with the required JavaScript statement:
   ```bash
   echo 'console.log("auth");' > auth.js
   ```
5. Stage and commit `auth.js` with a commit message describing the auth feature:
   ```bash
   git add auth.js
   git commit -m "Implement auth feature"
   ```
6. Switch back to the `main` branch:
   ```bash
   git switch main
   ```
7. Merge the `auth-feature` branch into `main`:
   ```bash
   git merge auth-feature
   ```
8. Clean up by deleting the merged `auth-feature` branch:
   ```bash
   git branch -d auth-feature
   ```
9. Validate your solution:
   ```bash
   tld check
   ```
