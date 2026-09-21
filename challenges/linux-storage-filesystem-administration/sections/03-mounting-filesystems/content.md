# Mounting Filesystems and Persistent Mounts

Mounting makes a formatted block storage device accessible by attaching it to a target directory (the **mount point**) in the root file system hierarchy.

## 1. Manual Mounting and Unmounting (`mount` and `umount`)

Attach a storage partition:
```bash
mount /dev/sdb1 /mnt/data
```

Detach a storage device safely:
```bash
umount /mnt/data
# or unmount by block device
umount /dev/sdb1
```

*If `umount` fails with `target is busy`, identify open files using `lsof /mnt/data` or `fuser -m /mnt/data`.*

## 2. Persistent Mounts (`/etc/fstab`)

Manual mounts do not survive system reboots. To configure persistent automatic volume mounting, add entries to `/etc/fstab`.

### The 6 Fields of `/etc/fstab`:
```fstab
# <file system>                          <mount point>  <type>  <options>  <dump>  <pass>
UUID=a1b2c3d4-e5f6-7890-abcd-1234567890  /mnt/data      ext4    defaults   0       2
```

1. **file system**: UUID (preferred for stability over `/dev/sd*`) or device path.
2. **mount point**: Absolute path to target directory.
3. **type**: Filesystem type (`ext4`, `xfs`, `vfat`).
4. **options**: Mount flags (`defaults`, `ro`, `noatime`, `nofail`).
5. **dump**: Backup flag (`0` to disable dump backups).
6. **pass**: Filesystem check order on boot (`1` for root `/`, `2` for secondary drives, `0` to skip).

## 3. Testing `/etc/fstab` Configurations

Always test `/etc/fstab` edits before rebooting:
```bash
mount -a
```
If `mount -a` executes cleanly without errors, all `/etc/fstab` entries are syntactically valid.
