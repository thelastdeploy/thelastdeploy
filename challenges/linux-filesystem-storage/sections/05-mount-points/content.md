## Mount Points & Filesystems

In Linux, storage devices (hard drives, SSDs, USB drives, virtual disk partitions) must be attached to the directory tree before they can be accessed. This attachment point is called a **mount point**.

---

## 1. What is Mounting?

Mounting connects a formatted filesystem partition to a specific target directory (e.g. `/mnt/storage` or `/var`). Once mounted, files written inside that directory are stored directly on the mounted storage device.

---

## 2. Inspecting Mounted Filesystems

### `findmnt`
Lists mounted filesystems in a clean tree structure:
```bash
findmnt
findmnt /
```

### `mount` & `/proc/mounts`
Displays raw active mount commands and active kernel mount tables:
```bash
mount | grep ext4
cat /proc/mounts
```

---

## 3. Persistent Mounts (`/etc/fstab`)

The `/etc/fstab` configuration file defines filesystems and storage UUIDs that should automatically mount upon system boot.

---

## Lab Tasks

### Task 1: Identify Mounted Filesystems (`lnx-identify-mounted-filesystems`)
1. Start the lab:
   ```bash
   tld start lnx-identify-mounted-filesystems
   ```
2. Query active mount points to determine the pseudo-filesystem mounted at `/proc`.
3. Save the filesystem type name (e.g., `proc`) into `$HOME/mount-test/proc_fstype.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
