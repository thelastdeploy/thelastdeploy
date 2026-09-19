## Links and Inodes

In Linux, a directory entry maps a human-readable filename to a numerical identifier known as an **inode** (index node).

---

## 1. What is an Inode?

An **inode** stores essential metadata about a file except its name or actual data content. This includes:
- Inode number
- File ownership (UID, GID)
- Access permission bits (`chmod`)
- File size and block locations
- Link count (number of hard links referencing this inode)

You can view inode numbers using `ls -i` or `stat`:
```bash
ls -i /etc/hosts
# Output: 2752512 /etc/hosts
```

---

## 2. Hard Links vs. Symbolic Links (Symlinks)

Linux supports two distinct link mechanisms:

### Hard Links (`ln target link_name`)
- Creates an additional directory entry pointing directly to the **same inode number**.
- Cannot span across different filesystems or mount points.
- Deleting the original file does not delete the data as long as at least one hard link remains (link count > 0).

### Symbolic Links / Symlinks (`ln -s target link_name`)
- Creates a distinct new file with its own unique inode.
- Contains a text path reference pointing to the target file or directory.
- Can point across different filesystems and directories.
- If the original file is moved or deleted, the symlink breaks (dangling link).

---

## Lab Tasks

### Task 1: Create a Symbolic Link (`lnx-create-symbolic-link`)
1. Start the lab:
   ```bash
   tld start lnx-create-symbolic-link
   ```
2. Create a symbolic link named `$HOME/link-test/current_config.conf` pointing to `$HOME/link-test/configs/app_v2.conf`.
3. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Identify File Links & Inodes (`lnx-identify-file-links`)
1. Start the lab:
   ```bash
   tld start lnx-identify-file-links
   ```
2. Inspect the files in `$HOME/link-test/check_zone`.
3. Find which file shares the exact same inode number as `$HOME/link-test/check_zone/original.txt`.
4. Save the name of that hard-linked file (e.g. `file_b.txt`) into `$HOME/link-test/same_inode.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
