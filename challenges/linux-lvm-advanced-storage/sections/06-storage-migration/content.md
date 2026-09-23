# Storage Migration & Data Relocation

LVM allows administrators to migrate data away from failing or slow physical storage devices onto new physical disks online without taking filesystems offline using `pvmove`.

---

## Online Data Migration (`pvmove`)

```bash
# Add new physical volume to volume group
pvcreate /dev/sdc1
vgextend vg_data /dev/sdc1

# Move all allocated physical extents from old disk (/dev/sdb1) to new disk (/dev/sdc1)
pvmove /dev/sdb1 /dev/sdc1

# Remove old disk from volume group and wipe PV label
vgreduce vg_data /dev/sdb1
pvremove /dev/sdb1
```

---

## Summary

`pvmove` migrates extents between Physical Volumes online while applications continue reading and writing to logical volumes.

---

## Lab Tasks

### Task 1: Migrate LVM Storage Online (`lnx-migrate-lvm-storage`)
1. Start the lab:
   ```bash
   tld start lnx-migrate-lvm-storage
   ```
2. Create directory `$HOME/mig-test`.
3. Document `pvmove` data migration procedure syntax.
4. Write output summary `PVMOVE_MIGRATION_VERIFIED` to `$HOME/mig-test/pvmove_info.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
