# Understanding Git History

Git keeps a record of all commits in a project's timeline. Navigating, reading, and understanding this history is key to resolving code regressions and recovering lost work.

---

## 1. Commits and Hashes

Every time you commit changes, Git creates a commit object. This object contains:
- A unique SHA-1 hash (a 40-character hexadecimal string representing the commit contents, e.g. `2ff2218d8a...`).
- Author details and timestamp.
- The commit message.
- A pointer to the parent commit(s).

---

## 2. Navigating the Log

To inspect the commit history of your active branch, use the `git log` command:

```bash
git log
```

### Useful Log Formats:
- **`git log --oneline`**: Shows each commit as a single line (short hash and commit message). Great for a quick overview.
- **`git log -n <number>`**: Restricts the output to the last `N` commits.
- **`git log --graph`**: Displays an ASCII graph of the branch and merge history.
