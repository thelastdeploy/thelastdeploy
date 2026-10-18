# First Project Checkpoint

Let's synthesize all the concepts you have learned in this module to save your first complete project state:
1. Initialize a new Git repository.
2. Configure `.gitignore` to prevent tracking temporary files.
3. Create the main source file `index.html`.
4. Stage and commit all files to record the initial stable revision of your project.

Completing this lab validates that you can configure and manage the basic lifecycle of a local Git workspace.

---

## Lab Tasks

### Task 1: Save Your Project State (`git-save-project-state`)
1. Start the lab session:
   ```bash
   tld start git-save-project-state
   ```
2. Navigate to `~/git-challenge/` and initialize a new repository:
   ```bash
   cd "$HOME/git-challenge"
   git init
   ```
3. Create a `.gitignore` file configured to ignore all `.tmp` files:
   ```bash
   echo "*.tmp" > .gitignore
   ```
4. Create the initial project file `index.html`:
   ```bash
   echo "<h1>My Project</h1>" > index.html
   ```
5. Stage and commit both `.gitignore` and `index.html`:
   ```bash
   git add .gitignore index.html
   git commit -m "Initial commit with project files"
   ```
6. Confirm that repository status is clean:
   ```bash
   git status
   ```
7. Validate your solution:
   ```bash
   tld check
   ```
