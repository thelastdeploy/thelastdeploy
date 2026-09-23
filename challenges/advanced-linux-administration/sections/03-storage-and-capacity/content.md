# Storage & Capacity Management

Managing LVM volume groups, online logical volume expansion, filesystem growth, and proactive disk capacity planning.

Production Linux storage administration requires managing dynamic disk allocation without causing downtime. Logical Volume Manager (LVM) combined with online filesystem expansion (`xfs_growfs`, `resize2fs`) ensures zero-downtime storage scaling.

### LVM Capacity Operations
1. **Extend Physical Volume**: `pvcreate /dev/sdb1`, `vgextend vg_data /dev/sdb1`.
2. **Extend Logical Volume**: `lvextend -L +50G /dev/vg_data/lv_app`.
3. **Expand Filesystem**: `resize2fs /dev/vg_data/lv_app` (ext4) or `xfs_growfs /mnt/data` (XFS).


---

## Lab Tasks

### Task 1: Plan Server Storage (`lnx-plan-server-storage`)
1. Start the lab:
   ```bash
   tld start lnx-plan-server-storage
   ```
2. Create directory `$HOME/storage-admin`.
3. Plan LVM Volume Group allocations, thin provisioning pools, and mount point options.
4. Write `ENTERPRISE_STORAGE_LAYOUT_PLANNED` into `$HOME/storage-admin/storage_plan.conf`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Manage Production Storage (`lnx-manage-production-storage`)
1. Start the lab:
   ```bash
   tld start lnx-manage-production-storage
   ```
2. Extend LVM Volume Group and Logical Volume.
3. Perform live online expansion of mount point filesystem without unmounting.
4. Write `LIVE_PRODUCTION_STORAGE_EXPANDED_SUCCESSFULLY` into `$HOME/storage-admin/lvm_expansion.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
