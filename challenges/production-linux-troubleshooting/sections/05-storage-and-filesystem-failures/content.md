# Storage Crashes & Filesystem Recovery

Storage outages occur due to root filesystem capacity exhaustion, deleted unlinked files locking disk blocks, read-only filesystem remounts caused by disk I/O errors, or corrupted `/etc/fstab` entries.

---

## 1. Unlinked File Space Leaks (`lsof +L1`)

When `df -h` shows 100% disk usage but `du -sh /*` fails to account for large files, processes are holding handles to deleted files:

```bash
# Locate processes holding handles to deleted unlinked files
lsof +L1

# Restart offending daemon to release disk space immediately
systemctl restart offending-daemon
```

---

## 2. Read-Only Filesystem Remount Recovery

When a filesystem experiences block device I/O errors, kernel remounts it read-only (`ro`):

```bash
# Check dmesg for storage errors
dmesg | grep -i "read-only"

# Remount filesystem read-write after resolving storage issue
mount -o remount,rw /data
```

---

## Summary

`lsof +L1` recovers hidden disk space leaks, and `mount -o remount,rw` recovers read-only remounted filesystems.

---

## Lab Tasks

### Task 1: Recover Failing Storage & Filesystem System (`lnx-recover-failing-storage-system`)
1. Start the lab:
   ```bash
   tld start lnx-recover-failing-storage-system
   ```
2. Create directory `$HOME/storage-outage-test`.
3. Diagnose and recover failing storage system (release unlinked open files or repair mount state).
4. Write output summary line `STORAGE_SYSTEM_RECOVERED` to `$HOME/storage-outage-test/storage_recovered.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
