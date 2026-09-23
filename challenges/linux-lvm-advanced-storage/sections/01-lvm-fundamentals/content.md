# LVM Fundamentals & Storage Hierarchy

Logical Volume Manager (LVM) provides an abstraction layer between physical storage devices (disks/partitions) and the operating system's filesystems. LVM allows storage pools to be resized, extended across multiple physical disks, snapshotted, and migrated online without unmounting active volumes.

---

## 1. The LVM Storage Stack Hierarchy

```text
+-----------------------------------------------------------+
| Filesystem Mount Point (/data)                            |
+-----------------------------+-----------------------------+
                              |
+-----------------------------v-----------------------------+
| Logical Volume (LV: /dev/vg_data/lv_app)                 |
+-----------------------------+-----------------------------+
                              |
+-----------------------------v-----------------------------+
| Volume Group (VG: vg_data)                                 |
+-----------------------------+-----------------------------+
                              |
            +-----------------+-----------------+
            |                                   |
+-----------v---------------+       +-----------v---------------+
| Physical Volume (PV1)     |       | Physical Volume (PV2)     |
| (/dev/sdb1)               |       | (/dev/sdc1)               |
+---------------------------+       +---------------------------+
```

---

## 2. Core LVM Layers Defined

1. **Physical Volumes (PV)**: Raw block devices or partitions initialized for LVM (e.g., `/dev/sdb1`, `/dev/nvme0n1p2`).
2. **Volume Groups (VG)**: Storage pool aggregating one or more Physical Volumes into a single storage allocation pool.
3. **Logical Volumes (LV)**: Virtual storage partitions allocated out of a Volume Group, formatted with a filesystem (ext4/XFS), and mounted to the directory tree.

---

## 3. Core LVM Command Suite

| Layer | Create | Display Summary | Detailed View | Scan Devices |
| :--- | :--- | :--- | :--- | :--- |
| **Physical Volume** | `pvcreate` | `pvs` | `pvdisplay` | `pvscan` |
| **Volume Group** | `vgcreate` | `vgs` | `vgdisplay` | `vgscan` |
| **Logical Volume** | `lvcreate` | `lvs` | `lvdisplay` | `lvscan` |

---

## Summary

LVM decouples physical disk geometry from logical partitions, enabling flexible online storage management.

---

## Lab Tasks

### Task 1: Identify LVM Components and Layer Hierarchy (`lnx-identify-lvm-components`)
1. Start the lab:
   ```bash
   tld start lnx-identify-lvm-components
   ```
2. Create directory `$HOME/lvm-test`.
3. Write the 5 LVM hierarchy layers in order into `$HOME/lvm-test/lvm_hierarchy.txt`:
4. - Line 1: `1. Physical Volume (PV)`
5. - Line 2: `2. Volume Group (VG)`
6. - Line 3: `3. Logical Volume (LV)`
7. - Line 4: `4. Filesystem`
8. - Line 5: `5. Mount Point`
9. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Inspect LVM Storage Allocation (`lnx-inspect-lvm-storage`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-lvm-storage
   ```
2. Create directory `$HOME/lvm-test`.
3. Run LVM inspection tools (`pvs`, `vgs`, `lvs` or display commands).
4. Write output summary line `LVM_STORAGE_INSPECTED` into `$HOME/lvm-test/storage_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
