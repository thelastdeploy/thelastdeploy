# Cloning Repositories

If a project has already been started and is hosted on a remote server, the first thing you need to do is get a copy of it on your local machine. In Git, this process is called **cloning**.

---

## 1. The Git Clone Command

When you run `git clone`, Git downloads all versions of every file in the project's history. It initializes a new `.git` directory, pulls down all the history data, checks out a working copy of the latest version, and automatically configures a remote pointing back to the source URL.

```bash
git clone <remote-url> [local-directory-name]
```

- If you don't specify a `local-directory-name`, Git will create a folder named after the repository name.

---

## 2. Inspecting Remotes

Once cloned, you can inspect the remote repository connection details.

To list the configured remote servers:
```bash
git remote
```
(Usually, this outputs `origin`).

To list the URLs that Git has stored for reading and writing to the remote:
```bash
git remote -v
```

To see detailed configuration properties of a remote:
```bash
git remote show origin
```
This shows tracking branch status, pull/push rules, and endpoints.

---

## Lab Tasks

### Task 1: Clone a Remote Repository (`git-clone-repository`)
1. Start the lab session:
   ```bash
   tld start git-clone-repository
   ```
2. Clone the remote repository located at `$HOME/git-remote-server.git` into `~/git-challenge`:
   ```bash
   git clone "$HOME/git-remote-server.git" "$HOME/git-challenge"
   ```
3. Navigate into the cloned repository and verify `hello.txt` is present:
   ```bash
   cd "$HOME/git-challenge"
   ls -la hello.txt
   ```
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Inspect Remote Properties (`git-inspect-remote`)
1. Start the lab session:
   ```bash
   tld start git-inspect-remote
   ```
2. Navigate to `~/git-challenge/`:
   ```bash
   cd "$HOME/git-challenge"
   ```
3. Inspect remote URLs in verbose mode and save the output to `remote-details.txt`:
   ```bash
   git remote -v > remote-details.txt
   ```
4. View the contents of `remote-details.txt` to verify origin endpoints:
   ```bash
   cat remote-details.txt
   ```
5. Validate your solution:
   ```bash
   tld check
   ```
