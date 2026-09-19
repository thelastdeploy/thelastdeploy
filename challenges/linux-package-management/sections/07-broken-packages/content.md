## Broken & Unmet Dependencies

System crashes, network disconnections, or interrupted package updates can leave package databases in a corrupted or half-installed state.

---

## 1. Package Database Locks

Package managers use lock files to prevent concurrent write operations:
- `/var/lib/dpkg/lock-frontend`
- `/var/lib/dpkg/lock`
- `/var/cache/apt/archives/lock`

If an install process crashes unexpectedly, a stale lock file remains on disk, causing subsequent `apt` commands to fail with:
`E: Could not get lock /var/lib/dpkg/lock-frontend`

---

## 2. Repairing Broken Installs

- **Fix Missing Dependencies (`apt --fix-broken install`)**: Automatically resolves unmet dependency trees.
- **Reconfigure Half-Installed Packages (`dpkg --configure -a`)**: Resumes post-installation configuration scripts for interrupted packages.

---

## Lab Tasks

### Task 1: Diagnose Broken Package (`lnx-diagnose-broken-package`)
1. Start the lab:
   ```bash
   tld start lnx-diagnose-broken-package
   ```
2. Inspect the status log `$HOME/broken-test/dpkg_status.log`.
3. Locate the package name marked with status `half-installed`.
4. Save the package name (`custom-app`) into `$HOME/broken-test/broken_package.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Repair Package State (`lnx-repair-package-state`)
1. Start the lab:
   ```bash
   tld start lnx-repair-package-state
   ```
2. Inspect `$HOME/broken-test/lock_zone`.
3. Clear the stale lock file `$HOME/broken-test/lock_zone/dpkg_lock.lock` left by a crashed updater process.
4. Validate your solution:
   ```bash
   tld check
   ```
