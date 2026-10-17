# Section 07 — Storage Administration Challenge

In this capstone challenge, you will synthesize your knowledge of Linux storage management to diagnose and restore access to an application storage volume.

## Problem Context

An application service reported read/write failures when attempting to persist data to its dedicated storage volume. You must audit:
1. Directory existence and mount point setup.
2. Configuration settings in `/etc/fstab` (or simulated equivalent).
3. Directory permissions and file ownership to ensure full application availability.

## Troubleshooting Checklist

- Verify that the target mount point directory exists.
- Check permissions (`chmod`) and ownership (`chown`) on the target location.
- Verify persistent mount parameters and formatting.
- Confirm successful end-to-end verification.

---

## Lab Tasks

### Task 1: Restore Missing Storage (`lnx-restore-missing-storage`)
1. Start the lab:
   ```bash
   tld start lnx-restore-missing-storage
   ```
2. Diagnose why the application cannot access its dedicated storage volume.
3. Update the mount point in `$HOME/storage-challenge/app/fstab_config` so `/mnt/wrong_path` is replaced with the correct path `$HOME/storage-challenge/mounts/app_data`:
   ```bash
   sed -i "s|/mnt/wrong_path|$HOME/storage-challenge/mounts/app_data|" ~/storage-challenge/app/fstab_config
   ```
4. Adjust permissions on `$HOME/storage-challenge/mounts/app_data` to `775`:
   ```bash
   chmod 775 ~/storage-challenge/mounts/app_data
   ```
5. Mark the application storage status as resolved by writing `STATUS: OK` to `$HOME/storage-challenge/app/status.txt`:
   ```bash
   echo "STATUS: OK" > ~/storage-challenge/app/status.txt
   ```
6. Validate your solution:
   ```bash
   tld check
   ```
