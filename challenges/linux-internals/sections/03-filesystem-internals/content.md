# VFS Architecture, Inodes & File Handles

The Virtual Filesystem (VFS) is a kernel abstraction layer that provides a uniform API (`open`, `read`, `write`, `close`) across different underlying filesystems (ext4, XFS, btrfs, procfs, sysfs).

---

## 1. VFS Data Structures

The VFS manages four primary data objects:

1. **Superblock**: Contains overall filesystem metadata (block size, total inodes, status).
2. **Inode (Index Node)**: Stores metadata for an individual file (permissions, UID/GID, size, timestamp, data block pointers). Note: Inodes do NOT store filenames!
3. **Dentry (Directory Entry)**: Maps a filename to an inode number.
4. **File Object**: Represents an open file instance created when a process invokes `open()`.

---

## 2. Inode Inspection & File Descriptors

```bash
# View inode number and metadata of a file
stat /etc/passwd

# View active system file descriptor allocation
cat /proc/sys/fs/file-nr

# List processes locking files
cat /proc/locks
```

---

## Summary

VFS decouples application file I/O from specific storage drivers through Superblocks, Inodes, Dentries, and File Objects.

---

## Lab Tasks

### Task 1: Explore Inodes and Filesystem Metadata (`lnx-explore-inodes-and-filesystems`)
1. Start the lab:
   ```bash
   tld start lnx-explore-inodes-and-filesystems
   ```
2. Create directory `$HOME/vfs-test`.
3. Inspect inode metadata (`stat`) and system inode usage (`df -i`).
4. Write output summary line `INODE_METADATA_EXPLORED` to `$HOME/vfs-test/inode_report.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Trace File Access and Open File Table (`lnx-trace-file-access`)
1. Start the lab:
   ```bash
   tld start lnx-trace-file-access
   ```
2. Create directory `$HOME/vfs-test`.
3. Inspect open file tables (`lsof`) and file locks (`/proc/locks`).
4. Write output line `FILE_LOCKS_TRACED` into `$HOME/vfs-test/file_locks.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
