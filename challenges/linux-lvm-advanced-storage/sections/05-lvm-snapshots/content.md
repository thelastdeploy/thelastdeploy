# LVM Snapshots & Point-in-Time Recovery

An LVM snapshot is a copy-on-write (COW) point-in-time image of a Logical Volume. When data on the origin volume changes, original blocks are backed up to the snapshot volume before being overwritten.

---

## 1. Creating and Mounting LVM Snapshots

```bash
# Create a 1GB snapshot named 'lv_app_snap' of origin volume '/dev/vg_data/lv_app'
lvcreate -s -n lv_app_snap -L 1G /dev/vg_data/lv_app

# Mount snapshot (read-only recommended) for backup verification
mkdir -p /mnt/snapshot
mount -o ro /dev/vg_data/lv_app_snap /mnt/snapshot
```

---

## 2. Restoring from Snapshot (`lvconvert --merge`)

To rollback an origin volume back to snapshot state:

```bash
# Unmount origin volume
umount /mnt/app

# Merge snapshot back into origin volume
lvconvert --merge /dev/vg_data/lv_app_snap

# Remount origin volume
mount /dev/vg_data/lv_app /mnt/app
```

---

## Summary

LVM copy-on-write snapshots enable point-in-time backups and fast rollback capabilities (`lvconvert --merge`).

---

## Lab Tasks

### Task 1: Create and Restore LVM Snapshots (`lnx-create-and-restore-lvm-snapshot`)
1. Start the lab:
   ```bash
   tld start lnx-create-and-restore-lvm-snapshot
   ```
2. Create directory `$HOME/snap-test`.
3. Document snapshot creation (`lvcreate -s`) and merge rollback syntax (`lvconvert --merge`).
4. Write output summary line `LVM_SNAPSHOT_PROCEDURE_VERIFIED` to `$HOME/snap-test/snap_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
