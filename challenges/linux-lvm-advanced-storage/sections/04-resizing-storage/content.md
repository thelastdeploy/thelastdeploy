# Storage Resizing & Safe Reduction

One of LVM's greatest features is online storage expansion. Logical volumes and filesystems can be grown while applications remain active. However, reducing storage capacity is a high-risk operation that requires strict execution sequence.

---

## 1. Expanding Logical Volumes & Filesystems

Using `lvextend` with `-r` (or `--resizefs`) resizes both the underlying Logical Volume and the active filesystem automatically:

```bash
# Expand LV by 5 Gigabytes and automatically extend active filesystem (ext4 or XFS)
lvextend -L +5G -r /dev/vg_data/lv_app

# Alternatively, extend LV first then resize filesystem manually:
lvextend -L +5G /dev/vg_data/lv_app
resize2fs /dev/vg_data/lv_app     # For ext4
xfs_growfs /mnt/app               # For XFS (Note: XFS requires mount point)
```

---

## 2. Safe Storage Reduction Rules (ext4 Only)

> [!CAUTION]
> **XFS filesystems CANNOT be reduced**. Only ext2/ext3/ext4 filesystems support shrinking. Reducing a volume before shrinking the filesystem causes permanent data loss!

Safe ext4 reduction sequence:
1. **Unmount filesystem**: `umount /mnt/app`
2. **Filesystem check**: `e2fsck -f /dev/vg_data/lv_app`
3. **Shrink filesystem FIRST**: `resize2fs /dev/vg_data/lv_app 5G`
4. **Reduce Logical Volume SECOND**: `lvreduce -L 5G /dev/vg_data/lv_app`
5. **Remount filesystem**: `mount /dev/vg_data/lv_app /mnt/app`

---

## Summary

`lvextend -r` expands storage safely online. Ext4 reduction requires unmounting and shrinking the filesystem BEFORE calling `lvreduce`.

---

## Lab Tasks

### Task 1: Expand Logical Volume and Filesystem (`lnx-expand-logical-volume`)
1. Start the lab:
   ```bash
   tld start lnx-expand-logical-volume
   ```
2. Create directory `$HOME/resize-test`.
3. Document `lvextend -r` syntax for online storage expansion.
4. Write output summary line `LV_EXPAND_SYNTAX_VERIFIED` to `$HOME/resize-test/expand_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Reduce Storage Capacity Safely (`lnx-reduce-storage-safely`)
1. Start the lab:
   ```bash
   tld start lnx-reduce-storage-safely
   ```
2. Create directory `$HOME/resize-test`.
3. Document the 5 mandatory safe ext4 reduction steps in order into `$HOME/resize-test/safe_reduce_steps.txt`:
4. - `1. umount`
5. - `2. e2fsck -f`
6. - `3. resize2fs`
7. - `4. lvreduce`
8. - `5. mount`
9. Validate your solution:
   ```bash
   tld check
   ```
