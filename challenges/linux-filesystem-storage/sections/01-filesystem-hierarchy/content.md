## Filesystem Hierarchy Standard (FHS)

Linux structures all files and directories beneath a single root directory denoted by `/`. The **Filesystem Hierarchy Standard (FHS)** defines the primary directories and their intended contents in Unix-like systems.

---

## 1. Key System Directories

- `/etc`: Configuration files for system services, network settings, and applications (e.g., `/etc/hosts`, `/etc/fstab`).
- `/var`: Variable data files that change during system operation, including logs (`/var/log`), mail queues, and spool files.
- `/tmp`: Temporary files created by system applications or users. Often wiped upon reboot or periodically cleared.
- `/usr/bin`: Primary directory for user-facing executable commands and binaries (e.g., `ls`, `grep`, `curl`).
- `/home`: Personal home directories for regular users (e.g., `/home/username`).
- `/proc` & `/sys`: Virtual pseudo-filesystems exposing kernel parameters, running processes, and hardware status.

---

## 2. Navigating FHS Locations

Understanding where files reside allows Linux administrators to inspect configurations, analyze application logs, and locate system binaries efficiently.

---

## Lab Tasks

### Task 1: Explore System Directories (`lnx-explore-filesystem`)
1. Start the lab:
   ```bash
   tld start lnx-explore-filesystem
   ```
2. Locate the standard log directory where Linux services store log data.
3. Save the absolute path of the system log directory to a file named `log_path.txt` in your home directory (`$HOME/log_path.txt`).
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Locate System Data (`lnx-locate-system-data`)
1. Start the lab:
   ```bash
   tld start lnx-locate-system-data
   ```
2. Inspect the test environment directory `$HOME/fhs-test`.
3. Locate the file containing system configuration settings inside the test structure and copy it to `$HOME/fhs-test/system_config.cfg`.
4. Validate your solution:
   ```bash
   tld check
   ```
