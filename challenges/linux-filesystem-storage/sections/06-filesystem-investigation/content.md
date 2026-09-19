## Filesystem Investigation

System administrators frequently encounter storage warnings where a partition reports 100% usage. Investigating storage issues requires methodical troubleshooting:

---

## 1. Block Storage vs Inode Storage Exhaustion

A filesystem can become full in two distinct ways:
1. **Block Storage Exhaustion**: Large files consume all available byte storage capacity (`df -h`).
2. **Inode Exhaustion**: Millions of tiny files exhaust all available inode allocation numbers even if gigabytes of free disk space remain (`df -i`).

---

## 2. Uncovering Hidden & Orphaned Files

Orphaned log files, hidden dotfiles (`.cache`), or unlinked open files held by running processes can consume significant disk space.

### Finding Hidden Files:
```bash
find /target/dir -name ".*" -size +1M
```

### Finding Open Unlinked Files (`lsof`):
If deleting a file does not free up disk space, a process may still hold an active file descriptor pointing to it:
```bash
lsof +L1
```

---

## Lab Tasks

### Task 1: Investigate Storage Usage (`lnx-investigate-storage-usage`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-storage-usage
   ```
2. Inspect `$HOME/storage-investigation`.
3. Locate the hidden log dump file consuming space inside a subfolder and identify its file name (e.g. `.hidden_dump.log`).
4. Save the file name to `$HOME/storage-investigation/culprit.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
