# Section 06 — Filesystem Troubleshooting

Filesystem issues in production environments range from unmounted partitions, corrupted superblocks, incorrect `/etc/fstab` entries, to read-only remounts triggered by I/O errors.

## Common Troubleshooting Vectors

1. **Mount Failures**: Non-existent mount point directories or missing device paths (`/dev/...`).
2. **Corrupted Options**: Syntax errors in `/etc/fstab` preventing automated boot mounting or breaking `mount -a`.
3. **Read-Only Mode**: Filesystem mounted read-only (`ro`) due to errors or explicit mount settings.
4. **Stale Stale Locks/Mounts**: Ghost mount points or processes locking directories.

## Diagnostic Steps

- Test manual mount execution: `mount /dev/sdX /mnt/target`.
- Verify mount configuration: `mount -a` tests all non-custom entries in `/etc/fstab`.
- Check kernel log messages: `dmesg | tail -n 30` or `journalctl -xe` to identify driver, superblock, or file system error codes.

---

## Lab Tasks

### Task 1: Diagnose Filesystem Problem (`lnx-diagnose-filesystem-problem`)
1. Start the lab:
   ```bash
   tld start lnx-diagnose-filesystem-problem
   ```
2. Diagnose why a storage mount configuration fails by inspecting `$HOME/storage-test/broken_app/fstab_mock` and `$HOME/storage-test/broken_app/diag/issue.txt`.
3. Create the missing mount target directory at `$HOME/storage-test/broken_app/mnt_missing_data`:
   ```bash
   mkdir -p ~/storage-test/broken_app/mnt_missing_data
   ```
4. Update `$HOME/storage-test/broken_app/fstab_mock` so the mount point points to `$HOME/storage-test/broken_app/mnt_missing_data`:
   ```bash
   sed -i "s|/mnt/missing_data|$HOME/storage-test/broken_app/mnt_missing_data|" ~/storage-test/broken_app/fstab_mock
   ```
5. Validate your solution:
   ```bash
   tld check
   ```
