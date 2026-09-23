# Storage & Data Pressure Scenarios

Recover from full production filesystems, unlinked open file handle space leaks (`deleted` files holding disk space), and inode exhaustion.

Storage issues in Linux often present perplexing contradictions: `df -h` shows 100% disk usage, but `du -sh /*` fails to account for the consumed space. This happens when running processes hold open file descriptors for unlinked (deleted) log files.

### Storage Investigation
- **Unlinked Open Files**: `lsof +L1` or `ls -l /proc/*/fd | grep deleted`.
- **Inode Exhaustion**: `df -i` (0 free inodes prevents new file creation even with gigabytes of free disk space).


---

## Lab Tasks

### Task 1: Recover Full Production Filesystem (`lnx-recover-full-production-filesystem`)
1. Start the lab:
   ```bash
   tld start lnx-recover-full-production-filesystem
   ```
2. Create directory `$HOME/storage-crisis`.
3. Identify deleted files held open by processes using `lsof +L1`.
4. Restart or truncate target file descriptors to reclaim disk space.
5. Write `FULL_FILESYSTEM_SPACE_RECOVERED_SUCCESSFULLY` into `$HOME/storage-crisis/filesystem_recovery.log`.
6. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Investigate Storage Performance Degradation (`lnx-investigate-storage-degradation`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-storage-degradation
   ```
2. Diagnose storage latency spikes using `ioping` and `iostat`.
3. Tune filesystem mount options (`noatime`, `nodiratime`) and sysctl writeback parameters.
4. Write `STORAGE_IO_DEGRADATION_DIAGNOSED_AND_TUNED` into `$HOME/storage-crisis/storage_degradation.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
