## Disk Usage and Space Management

Monitoring filesystem utilization prevents storage exhaustion, which can crash databases, application services, or cause system unresponsiveness.

---

## 1. Disk Free (`df`)

The `df` command reports overall disk space usage across mounted filesystems:

```bash
df -h
```
- `-h`: Displays sizes in human-readable formats (K, M, G).
- `-T`: Displays the filesystem type (ext4, xfs, btrfs).
- `-i`: Displays inode utilization instead of block storage.

---

## 2. Disk Usage (`du`)

The `du` command estimates directory space usage by traversing subfolders:

```bash
du -sh /var/log/*
```
- `-s`: Summarizes total space for each specified target directory.
- `-h`: Human-readable format.
- `du -ah --max-depth=1 /path`: Lists directory contents up to a specific depth.

---

## 3. Finding Large Files (`find`)

To locate large files across the storage hierarchy:
```bash
find /var/log -type f -size +10M
```

---

## Lab Tasks

### Task 1: Check Disk Space (`lnx-check-disk-space`)
1. Start the lab:
   ```bash
   tld start lnx-check-disk-space
   ```
2. Run `df -h /` to check the root filesystem.
3. Save the filesystem mount point path of root (`/`) to `$HOME/disk-test/root_mount.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Find Large Files (`lnx-find-large-files`)
1. Start the lab:
   ```bash
   tld start lnx-find-large-files
   ```
2. Inspect `$HOME/disk-test/logs`.
3. Locate the largest file inside `$HOME/disk-test/logs` and save its filename (e.g., `heavy_dump.log`) into `$HOME/disk-test/largest_file.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
