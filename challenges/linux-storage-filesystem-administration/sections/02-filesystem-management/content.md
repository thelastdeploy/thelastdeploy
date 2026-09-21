# Filesystem Management and Health

A filesystem structures raw storage block devices into files, directories, metadata blocks, and allocation tables.

## 1. Common Linux Filesystems

- **`ext4`**: Fourth Extended Filesystem. Standard, highly reliable Linux filesystem supporting journaling.
- **`xfs`**: High-performance 64-bit journaling filesystem (default on RHEL/CentOS).
- **`btrfs`**: Copy-on-write (CoW) filesystem with built-in snapshots, pooling, and self-healing features.

## 2. Identifying Filesystem Types and UUIDs

Every formatted partition is assigned a unique 128-bit UUID (Universally Unique Identifier):

```bash
# Print device name, UUID, and filesystem type
blkid

# Identify filesystem of raw block device
file -s /dev/sda1
```

## 3. Superblock Inspection and Health Checks

The **superblock** contains critical metadata regarding total block size, free inode count, mount counts, and filesystem state.

```bash
# Inspect ext4 superblock parameters
tune2fs -l /dev/sda1

# Check unmounted filesystem integrity
fsck /dev/sda1
```

*Note: Never run `fsck` on an actively mounted filesystem to prevent corruption.*
