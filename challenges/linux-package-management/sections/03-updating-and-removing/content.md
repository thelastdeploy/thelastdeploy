## Updating & Removing Packages

Maintaining system security requires regularly updating software packages and cleanly removing unused or obsolete applications.

---

## 1. Upgrading Packages

- **Debian / Ubuntu**:
  ```bash
  sudo apt list --upgradable
  sudo apt upgrade -y
  ```
- **Red Hat / Fedora**:
  ```bash
  sudo dnf check-update
  sudo dnf upgrade -y
  ```

---

## 2. Package Removal vs Purge

- **Remove (`apt remove` / `dnf remove`)**: Uninstalls binary executables but leaves application configuration files in place.
- **Purge (`apt purge`)**: Uninstalls binaries **and** completely deletes configuration files.
- **Autoremove (`apt autoremove` / `dnf autoremove`)**: Removes orphaned dependency packages that were installed automatically but are no longer needed.

---

## Lab Tasks

### Task 1: Manage Outdated Packages (`lnx-manage-outdated-packages`)
1. Start the lab:
   ```bash
   tld start lnx-manage-outdated-packages
   ```
2. Inspect the mock package manager log `$HOME/pkg-test/upgrades.log`.
3. Count the number of packages marked as `upgradable` in the log.
4. Save the count integer (e.g. `3`) to `$HOME/pkg-test/upgradable_count.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
