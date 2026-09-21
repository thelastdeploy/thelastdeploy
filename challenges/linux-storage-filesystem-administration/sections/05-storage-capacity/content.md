# Section 05 — Storage Capacity

Filesystem capacity management extends beyond simple monitoring of free space. Disk exhaustion can occur due to file size accumulation or inode depletion.

## Core Capacity Commands

- `df -h`: Report file system disk space usage in human-readable format.
- `df -i`: Display inode utilization for mounted filesystems.
- `du -sh <dir>`: Summarize total disk space consumed by a directory.
- `du -ah <dir> | sort -rh | head -n 10`: Identify top disk-consuming files.

## Investigating Storage & Inodes

When `df -h` shows space remaining but file creation fails with `No space left on device`, check inode availability using `df -i`. Millions of tiny log or cache files can exhaust inode tables before block storage fills up.

## Unlinked Open Files

When a file is deleted (`rm`) while a running process holds an open file handle, the disk space is not freed until the process terminates or closes the file descriptor.

- `lsof +L1`: List open files that have been deleted (link count 0).
- Terminating or restarting the holding process releases the locked filesystem blocks.
