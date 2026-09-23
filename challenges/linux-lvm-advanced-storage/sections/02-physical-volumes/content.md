# Physical Volumes & Volume Groups

Physical Volumes (PV) convert physical partitions or raw block devices into LVM-manageable storage. Volume Groups (VG) aggregate one or more PVs into a unified storage pool.

---

## 1. Creating Physical Volumes (`pvcreate`)

Initialize block devices for LVM use:

```bash
# Initialize disk partition as Physical Volume
pvcreate /dev/sdb1

# Initialize raw disk device
pvcreate /dev/sdc

# View physical volume summary
pvs
```

---

## 2. Managing Volume Groups (`vgcreate` & `vgextend`)

Create storage pools and extend capacity by adding additional Physical Volumes:

```bash
# Create a Volume Group named 'vg_data' from /dev/sdb1
vgcreate vg_data /dev/sdb1

# Extend 'vg_data' by adding a second Physical Volume (/dev/sdc1)
vgextend vg_data /dev/sdc1

# View volume group total and free space
vgs
```

---

## Summary

`pvcreate` initializes raw disks, and `vgextend` expands Volume Group storage capacity dynamically.

---

## Lab Tasks

### Task 1: Create and Initialize Physical Volume (`lnx-create-physical-volume`)
1. Start the lab:
   ```bash
   tld start lnx-create-physical-volume
   ```
2. Create directory `$HOME/pv-test`.
3. Document `pvcreate` command syntax for block device initialization.
4. Write output summary line `PV_CREATE_COMMAND_VERIFIED` to `$HOME/pv-test/pv_info.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Manage Volume Groups (`lnx-manage-volume-group`)
1. Start the lab:
   ```bash
   tld start lnx-manage-volume-group
   ```
2. Create directory `$HOME/pv-test`.
3. Document `vgcreate` and `vgextend` syntax.
4. Write summary `VG_MANAGEMENT_VERIFIED` to `$HOME/pv-test/vg_info.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
