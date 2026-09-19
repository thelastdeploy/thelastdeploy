## File Metadata & Properties

Every file in a Linux filesystem maintains metadata alongside its raw content data. This metadata includes permissions, ownership, byte size, block counts, and key timestamps.

---

## 1. Inspecting Metadata (`stat`)

The `stat` command displays complete status information about a file or directory:

```bash
stat /etc/passwd
```

Key output attributes:
- **Size & Blocks**: Exact file size in bytes and allocated 512B blocks.
- **Access Time (atime)**: Timestamp when the file was last read.
- **Modify Time (mtime)**: Timestamp when the file content was last modified.
- **Change Time (ctime)**: Timestamp when the file metadata/inode (permissions, ownership) changed.

---

## 2. File Identification (`file` command)

Linux does not rely on filename extensions (`.txt`, `.sh`, `.png`) to determine file types. The `file` utility inspects magic bytes at the beginning of a file to reveal its true format (ASCII text, ELF executable, gzip compressed archive, etc.).

```bash
file /bin/bash
# Output: /bin/bash: ELF 64-bit LSB pie executable...
```

---

## Lab Tasks

### Task 1: Inspect File Metadata (`lnx-inspect-file-metadata`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-file-metadata
   ```
2. Run `stat` on the test file `$HOME/metadata-test/target_file.txt`.
3. Extract the exact file size in bytes and save it to `$HOME/metadata-test/file_size.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Investigate File Properties (`lnx-investigate-file-properties`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-file-properties
   ```
2. Determine the true file type of `$HOME/metadata-test/unknown_file` using the `file` command.
3. Save the single word output of the file type (e.g., `gzip` or `ASCII` or `ELF`) to `$HOME/metadata-test/file_type.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
