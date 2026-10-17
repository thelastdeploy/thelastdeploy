# Storage & Data Pressure Scenarios

Recover from full production filesystems, unlinked open file handle space leaks (`deleted` files holding disk space), and inode exhaustion.

Storage issues in Linux often present perplexing contradictions: `df -h` shows 100% disk usage, but `du -sh /*` fails to account for the consumed space. This happens when running processes hold open file descriptors for unlinked (deleted) log files.

### Storage Investigation
- **Unlinked Open Files**: `lsof +L1` or `ls -l /proc/*/fd | grep deleted`.
- **Inode Exhaustion**: `df -i` (0 free inodes prevents new file creation even with gigabytes of free disk space).

---

## Lab Tasks

### Task 1: Recover Full Production Filesystem (`lnx-recover-full-production-filesystem`)
1. Start the lab session:
   ```bash
   tld start lnx-recover-full-production-filesystem
   ```
2. Create the destination directory for storage crisis logs:
   ```bash
   mkdir -p "$HOME/storage-crisis"
   ```
3. Identify deleted files held open by processes using `lsof +L1` or `ls -l /proc/*/fd`.
4. Restart or truncate target file descriptors to reclaim disk space.
5. Record the filesystem recovery verification marker into `$HOME/storage-crisis/filesystem_recovery.log`:
   ```bash
   echo "FULL_FILESYSTEM_SPACE_RECOVERED_SUCCESSFULLY" > "$HOME/storage-crisis/filesystem_recovery.log"
   ```
6. Verify file contents:
   ```bash
   cat "$HOME/storage-crisis/filesystem_recovery.log"
   ```
7. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Investigate Storage Performance Degradation (`lnx-investigate-storage-degradation`)
1. Start the lab session:
   ```bash
   tld start lnx-investigate-storage-degradation
   ```
2. Ensure the storage crisis directory exists:
   ```bash
   mkdir -p "$HOME/storage-crisis"
   ```
3. Diagnose storage latency spikes using `iostat -xz 1` or `df -i`.
4. Tune filesystem mount options (`noatime`, `nodiratime`) and sysctl writeback parameters.
5. Record the storage degradation diagnosis marker into `$HOME/storage-crisis/storage_degradation.txt`:
   ```bash
   echo "STORAGE_IO_DEGRADATION_DIAGNOSED_AND_TUNED" > "$HOME/storage-crisis/storage_degradation.txt"
   ```
6. Verify file contents:
   ```bash
   cat "$HOME/storage-crisis/storage_degradation.txt"
   ```
7. Validate your solution:
   ```bash
   tld check
   ```
