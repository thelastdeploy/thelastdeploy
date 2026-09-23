# Logical Volume Provisioning & Filesystem Formatting

Logical Volumes (LV) are carved out of Volume Groups and exposed as block devices (`/dev/<vg_name>/<lv_name>`). Once created, LVs are formatted with a filesystem (ext4/XFS) and mounted into the system directory hierarchy.

---

## 1. Creating Logical Volumes (`lvcreate`)

```bash
# Create a 10 Gigabyte Logical Volume named 'lv_app' inside 'vg_data'
lvcreate -L 10G -n lv_app vg_data

# Create a Logical Volume using 100% of remaining free space in Volume Group
lvcreate -l 100%FREE -n lv_data vg_data

# Display allocated Logical Volumes
lvs
```

---

## 2. Formatting & Mounting Logical Volumes

```bash
# Format with ext4 filesystem
mkfs.ext4 /dev/vg_data/lv_app

# Format with XFS filesystem
mkfs.xfs /dev/vg_data/lv_data

# Create mount directory and mount
mkdir -p /mnt/app
mount /dev/vg_data/lv_app /mnt/app

# Add to /etc/fstab for persistent boot mount
# /dev/mapper/vg_data-lv_app  /mnt/app  ext4  defaults  0  2
```

---

## Summary

`lvcreate` provisions logical block devices, formatted with `mkfs.ext4` or `mkfs.xfs` for filesystem storage.

---

## Lab Tasks

### Task 1: Configure Filesystem on Logical Volume (`lnx-configure-lvm-filesystem`)
1. Start the lab:
   ```bash
   tld start lnx-configure-lvm-filesystem
   ```
2. Create directory `$HOME/lv-test`.
3. Document formatting and fstab mount entry syntax for Logical Volumes.
4. Write summary `LV_FILESYSTEM_CONFIGURED` into `$HOME/lv-test/mount_info.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Create Logical Volumes (`lnx-create-logical-volume`)
1. Start the lab:
   ```bash
   tld start lnx-create-logical-volume
   ```
2. Create directory `$HOME/lv-test`.
3. Document `lvcreate` syntax (`lvcreate -L 2G -n lv_app vg_data`).
4. Write output summary `LV_CREATE_SYNTAX_VERIFIED` to `$HOME/lv-test/lv_info.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
