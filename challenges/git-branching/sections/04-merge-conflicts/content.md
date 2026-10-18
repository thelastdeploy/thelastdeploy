# Resolving Merge Conflicts

When you try to merge two branches that modified the **same lines of the same file** in different ways, Git won't know which version to keep. This causes a **merge conflict**.

---

## Conflict Indicators

When a conflict occurs:
1. Git halts the merge process and prints a warning.
2. It modifies the conflicted file, adding **conflict markers** to highlight the differences:

```html
<<<<<<< HEAD
<h1>Welcome to Main Site</h1>
=======
<h1>Welcome to My Feature Page</h1>
>>>>>>> feature-branch
```

- **`<<<<<<< HEAD`**: Indicates the beginning of the changes on your current branch.
- **`=======`**: Divides your changes from the changes in the incoming branch.
- **`>>>>>>> feature-branch`**: Indicates the end of the changes from the incoming branch.

---

## Resolving a Conflict

To resolve a conflict, you must manually edit the conflicted files:
1. Open the file in an editor.
2. Decide which content to keep (or write a new version combining both).
3. **Remove all conflict markers** (`<<<<<<<`, `=======`, and `>>>>>>>`).
4. Stage the resolved files using:
   ```bash
   git add <resolved-file>
   ```
5. Complete the merge commit by running:
   ```bash
   git commit
   ```
   (Alternatively, in modern Git, you can run `git merge --continue`).

---

## Lab Tasks

### Task 1: Resolve Merge Conflict (`git-resolve-merge-conflict`)
1. Start the lab session:
   ```bash
   tld start git-resolve-merge-conflict
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Inspect `index.html` to find conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`):
   ```bash
   cat index.html
   ```
4. Resolve the conflict by removing the conflict markers and saving your desired clean content:
   ```bash
   echo "<h1>Merged Site</h1>" > index.html
   ```
5. Stage the resolved file without completing the commit yet:
   ```bash
   git add index.html
   ```
6. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Complete the Merge Commit (`git-complete-merge`)
1. Start the lab session:
   ```bash
   tld start git-complete-merge
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Complete the merge commit for the staged resolution:
   ```bash
   git commit -m "Merge branch feature-conflict into main"
   ```
4. Confirm that the merge commit has been created with two parents:
   ```bash
   git log -1 --format="%h %P"
   ```
5. Validate your solution:
   ```bash
   tld check
   ```
