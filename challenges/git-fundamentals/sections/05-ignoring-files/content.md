# Ignoring Files

Often, you will have temporary files, build artifacts, compiled outputs, local configs, or dependency folders (like `node_modules` or `.venv`) that you do not want to commit or track in Git.

### The `.gitignore` File
You can prevent Git from tracking these files by listing match patterns inside a special text file named `.gitignore` at the root of your project directory.

#### Common Patterns:
```text
# Ignore all files ending with .log
*.log

# Ignore a specific file
config.local.json

# Ignore a folder
node_modules/
dist/

# Ignore files in a specific directory
logs/*.txt
```

---

## Lab Tasks

### Task 1: Configure Git Ignore List (`git-configure-gitignore`)
1. Start the lab session:
   ```bash
   tld start git-configure-gitignore
   ```
2. Navigate to `~/git-challenge/` and append the `*.log` rule to `.gitignore`:
   ```bash
   cd "$HOME/git-challenge"
   echo "*.log" >> .gitignore
   ```
3. Test that log files are now recognized as ignored by Git:
   ```bash
   git check-ignore -v debug.log
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
