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
