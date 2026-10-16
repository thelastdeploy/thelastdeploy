# File Security and Overly Broad Access

Overly permissive file and directory permissions allow unauthorized local users or compromised processes to modify configuration settings, steal private credentials, or inject malicious code.

## 1. Auditing Permission Modes (`stat` and `ls`)

To inspect octal permission masks formatted numerically:

```bash
stat -c "%a %n" /var/www/app/config.json
# Output: 777 /var/www/app/config.json
```

Mode `777` (`rwxrwxrwx`) grants full read, write, and execute rights to any local system user and represents a major security vulnerability.

## 2. Searching for World-Writable Files

Locate any files that allow arbitrary write access to the `Other` category (`-perm -0002` or `-perm -o+w`):

```bash
find /etc -type f -perm -0002
```

## 3. Finding Unowned Files (`-nouser` / `-nogroup`)

Files whose owning UID or GID no longer exist in `/etc/passwd` or `/etc/group`:

```bash
find /var/www -nouser -o -nogroup
```

---

## Lab Tasks

### Task 1: Audit File Permissions and Octal Masks (`lnx-audit-file-permissions`)
1. Start the lab:
   ```bash
   tld start lnx-audit-file-permissions
   ```
2. Audit the numeric octal permission masks of files in `$HOME/sec-test/configs/` using `stat`.
3. Save the audited octal modes to `$HOME/sec-test/permission_audit.txt` with entries formatted as:
   - `app.conf: <octal_mode>`
   - `db.conf: <octal_mode>`
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Find Insecure World-Writable Files (`lnx-find-insecure-files`)
1. Start the lab:
   ```bash
   tld start lnx-find-insecure-files
   ```
2. Inspect file permissions across `$HOME/sec-test/audit_dir/`.
3. Locate all world-writable files using `find -perm -0002` and write their paths to `$HOME/sec-test/insecure_files.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
