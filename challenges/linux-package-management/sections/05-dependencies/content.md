## Package Dependencies

Linux software packages rarely run in total isolation. They rely on shared system libraries (`.so` files) and dependent helper packages.

---

## 1. Inspecting Package Dependencies

- **`apt-cache depends <package>`**: Displays prerequisite packages required by a target package.
  ```bash
  apt-cache depends nginx
  ```
- **`dpkg -I <package.deb>`**: Inspects control metadata inside an uninstalled `.deb` archive to reveal `Depends:`, `Recommends:`, and `Conflicts:` headers.
- **`ldd <binary_path>`**: Prints shared object (`.so`) dynamic library dependencies required by a compiled binary:
  ```bash
  ldd /usr/bin/curl
  ```

---

## Lab Tasks

### Task 1: Investigate Package Dependencies (`lnx-investigate-package-dependencies`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-package-dependencies
   ```
2. Inspect the mock dependency log `$HOME/pkg-test/deps.log`.
3. Locate the direct dependency package required by `web-app-v2`.
4. Save the required dependency package name (`libssl-dev`) into `$HOME/pkg-test/req_dep.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
