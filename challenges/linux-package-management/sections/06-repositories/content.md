## Repositories & Sources

Linux package managers download packages from remote web servers known as **software repositories**.

---

## 1. Repository Configuration Files

- **Debian / Ubuntu**:
  - Primary sources list: `/etc/apt/sources.list`
  - Modular sources directory: `/etc/apt/sources.list.d/*.list`
- **Red Hat / Fedora**:
  - Repository configuration directory: `/etc/yum.repos.d/*.repo`

---

## 2. APT Sources Format

A standard APT source entry consists of:
```text
deb http://archive.ubuntu.com/ubuntu focal main restricted universe multiverse
```
- `deb`: Indicates compiled binary packages (or `deb-src` for source code).
- URL: The remote HTTP/HTTPS repository endpoint.
- Distribution codename: e.g. `focal` or `jammy`.
- Components: `main`, `universe`, `multiverse`, `restricted`.

---

## Lab Tasks

### Task 1: Investigate Package Repositories (`lnx-investigate-package-repositories`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-package-repositories
   ```
2. Inspect the mock sources file `$HOME/repo-test/sources.list`.
3. Locate the primary distribution codename used in the active `deb` repository URL (e.g. `focal`).
4. Save the codename (`focal`) into `$HOME/repo-test/repo_codename.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
