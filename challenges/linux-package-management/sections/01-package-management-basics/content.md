## Package Management Basics

Linux distributions use package managers to automate the installation, configuration, upgrading, and removal of software packages.

---

## 1. Package Manager Ecosystems

- **Debian / Ubuntu (`apt`, `dpkg`)**: Uses `.deb` package files.
  - High-level manager: `apt` / `apt-get`
  - Low-level installer: `dpkg`
- **Red Hat / Fedora / CentOS (`dnf`, `yum`, `rpm`)**: Uses `.rpm` package files.
  - High-level manager: `dnf` / `yum`
  - Low-level installer: `rpm`

---

## 2. Inspecting Installed Packages

- **Debian/Ubuntu**:
  ```bash
  dpkg -l
  apt list --installed
  ```
- **Red Hat/Fedora**:
  ```bash
  rpm -qa
  dnf list installed
  ```

---

## Lab Tasks

### Task 1: Identify Package Manager (`lnx-identify-package-manager`)
1. Start the lab:
   ```bash
   tld start lnx-identify-package-manager
   ```
2. Determine whether your system uses `apt` or `dnf` as its primary high-level package manager.
3. Save the package manager binary name (`apt` or `dnf`) to `$HOME/pkg-test/pkg_manager.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Inspect Installed Packages (`lnx-inspect-installed-packages`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-installed-packages
   ```
2. Query your system's package database to verify if `bash` is installed.
3. Save the single word `installed` to `$HOME/pkg-test/bash_status.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
