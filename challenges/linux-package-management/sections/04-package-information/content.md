## Package Metadata & Inspection

Package tools maintain comprehensive metadata about every package: version numbers, architectures, dependencies, maintainers, and installed file lists.

---

## 1. Inspecting Package Details

- **`apt-cache show <package>` / `dpkg -s <package>`**: Displays package description, version, section, maintainer, and installed size.
  ```bash
  apt-cache show nginx
  ```
- **`dpkg -L <package>`**: Lists every file installed on disk by a given package.
  ```bash
  dpkg -L nginx
  ```

---

## 2. Tracing File Ownership (`dpkg -S`)

To determine which installed package placed a specific file or binary on your system:
```bash
dpkg -S /bin/ls
# Output: coreutils: /bin/ls
```

---

## Lab Tasks

### Task 1: Find Package Information (`lnx-find-package-information`)
1. Start the lab:
   ```bash
   tld start lnx-find-package-information
   ```
2. Trace which package owns the binary `/bin/bash` using `dpkg -S /bin/bash` (or equivalent query).
3. Save the package name (`base-files` or `bash` or `coreutils`) to `$HOME/pkg-test/bash_owner.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Trace Installed Package (`lnx-trace-installed-package`)
1. Start the lab:
   ```bash
   tld start lnx-trace-installed-package
   ```
2. Inspect the mock package database log `$HOME/pkg-test/pkg_query.log`.
3. Locate the package name that installed the binary `/usr/bin/git`.
4. Save the package name (`git`) to `$HOME/pkg-test/git_package.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
