# Filesystem and VFS Internals

Exploring Virtual File System (VFS) abstractions: inodes, dentries, file descriptors, and kernel page cache dirty writeback.

The Virtual File System (VFS) is the kernel abstraction layer enabling userspace processes to interact transparently with diverse filesystems (ext4, xfs, btrfs, tmpfs) using standard system call interfaces (`open`, `read`, `write`, `close`).

### Core VFS Data Structures
- **`inode`**: Represents a physical storage object (metadata, permissions, block pointers).
- **`dentry`**: Represents a directory entry mapping file paths to inodes.
- **`file`**: Represents an open file instance associated with a process file descriptor table (`/proc/[pid]/fd/`).


---

## Lab Tasks

### Task 1: Investigate VFS Abstraction Behavior (`lnx-investigate-vfs-behavior`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-vfs-behavior
   ```
2. Create directory `$HOME/vfs-internals`:
   ```bash
   mkdir -p ~/vfs-internals
   ```
3. Inspect `/proc/sys/fs/file-nr`, `/proc/self/fd/`, and `/proc/locks`:
   ```bash
   cat /proc/sys/fs/file-nr
   ls -la /proc/self/fd/
   head -n 5 /proc/locks
   ```
4. Write `VFS_FILE_DESCRIPTORS_AND_INODES_INVESTIGATED` into `$HOME/vfs-internals/vfs_structures.log`:
   ```bash
   echo 'VFS_FILE_DESCRIPTORS_AND_INODES_INVESTIGATED' > ~/vfs-internals/vfs_structures.log
   cat ~/vfs-internals/vfs_structures.log
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Trace Kernel File Operations (`lnx-trace-kernel-file-operations`)
1. Start the lab:
   ```bash
   tld start lnx-trace-kernel-file-operations
   ```
2. Create directory `$HOME/vfs-internals`:
   ```bash
   mkdir -p ~/vfs-internals
   ```
3. Examine dentry and inode cache metrics in `/proc/sys/fs/dentry-state` and `/proc/sys/fs/inode-state`:
   ```bash
   cat /proc/sys/fs/dentry-state
   cat /proc/sys/fs/inode-state
   ```
4. Write `KERNEL_FILE_OPERATIONS_AND_CACHE_TRACED` into `$HOME/vfs-internals/file_ops.log`:
   ```bash
   echo 'KERNEL_FILE_OPERATIONS_AND_CACHE_TRACED' > ~/vfs-internals/file_ops.log
   cat ~/vfs-internals/file_ops.log
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

