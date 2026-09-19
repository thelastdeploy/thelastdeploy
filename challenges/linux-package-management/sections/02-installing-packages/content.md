## Installing Packages

High-level package managers download software packages and their required dependencies automatically from remote software repositories.

---

## 1. Updating Package Repositories Index

Before installing new software, synchronize your local package cache with the latest remote repository indexes:

- **Debian / Ubuntu**:
  ```bash
  sudo apt update
  ```
- **Red Hat / Fedora**:
  ```bash
  sudo dnf check-update
  ```

---

## 2. Installing Packages

- **Debian / Ubuntu**:
  ```bash
  sudo apt install -y curl
  ```
- **Red Hat / Fedora**:
  ```bash
  sudo dnf install -y curl
  ```

---

## Lab Tasks

### Task 1: Install Required Package (`lnx-install-required-package`)
1. Start the lab:
   ```bash
   tld start lnx-install-required-package
   ```
2. Verify that the command `curl` is installed and accessible in your system PATH.
3. Save the output of `which curl` to `$HOME/pkg-test/curl_path.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Install Package from Repository (`lnx-install-package-from-repository`)
1. Start the lab:
   ```bash
   tld start lnx-install-package-from-repository
   ```
2. Ensure the `tar` archiving package is present on your system.
3. Save the single word `installed` to `$HOME/pkg-test/tar_status.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
