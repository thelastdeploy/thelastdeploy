# Special Permissions (SUID, SGID, Sticky Bit)

Beyond standard read, write, and execute permissions (`rwx`), Linux supports three special permission bits for advanced file security control.

## 1. Set User ID (SUID - `4000` / `u+s`)

When an executable binary file with SUID set is run, the resulting process executes with the effective privileges of the **file owner** rather than the user launching it.

Example: `/usr/bin/passwd` has owner `root` and SUID set (`-rwsr-xr-x`), allowing unprivileged users to update `/etc/shadow`.

Find all SUID binaries on a system:
```bash
find / -perm -4000 -type f 2>/dev/null
```

## 2. Set Group ID (SGID - `2000` / `g+s`)

- **Executables**: Process executes with privileges of the file's group.
- **Directories**: Any new file created inside the directory automatically inherits the directory's group ownership instead of the creator's primary group.

## 3. Sticky Bit (`1000` / `+t`)

Applied to shared directories (like `/tmp` with mode `1777` / `drwxrwxrwt`). Prevents users from deleting or renaming files owned by other users within the shared directory.
