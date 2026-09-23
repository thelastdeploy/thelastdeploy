# Filesystem & Executable Hardening

Securing sensitive configuration files and auditing special executable permissions (SUID/SGID) prevents unauthorized data access and local privilege escalation vectors.

---

## 1. Sensitive File Permission Baselines

| File Path | Recommended Mode | Owner:Group | Purpose |
| :--- | :--- | :--- | :--- |
| `/etc/passwd` | `644` (`-rw-r--r--`) | `root:root` | User account metadata |
| `/etc/shadow` | `600` or `640` (`-rw-------`) | `root:root` or `root:shadow` | Encrypted password hashes |
| `/etc/group` | `644` (`-rw-r--r--`) | `root:root` | System group definitions |
| `/etc/ssh/sshd_config` | `600` (`-rw-------`) | `root:root` | SSH daemon configuration |

---

## 2. Auditing SUID/SGID Executables

SUID (`chmod u+s`, mode `4000`) runs an executable with the permissions of the file owner (typically `root`). Unnecessary SUID binaries create dangerous privilege escalation risks:

```bash
# Locate all SUID files on the root filesystem
find / -perm -4000 -type f -exec ls -ld {} + 2>/dev/null

# Remove SUID bit from non-essential binary
chmod u-s /usr/bin/unnecessary_binary
```

---

## Summary

Restricting file permissions on sensitive configs and stripping unauthorized SUID flags closes major local exploit vectors.

---

## Lab Tasks

### Task 1: Harden Sensitive System Files (`lnx-harden-sensitive-files`)
1. Start the lab:
   ```bash
   tld start lnx-harden-sensitive-files
   ```
2. Create directory `$HOME/fs-sec-test`.
3. Document permissions baseline for `/etc/shadow`, `/etc/passwd`, and `/etc/ssh/sshd_config`.
4. Write audit line `FILE_PERMISSIONS_HARDENED` to `$HOME/fs-sec-test/file_perms.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Secure SUID/SGID Executable Permissions (`lnx-secure-executable-permissions`)
1. Start the lab:
   ```bash
   tld start lnx-secure-executable-permissions
   ```
2. Create directory `$HOME/fs-sec-test`.
3. Audit SUID/SGID binaries and document removal of unauthorized SUID bits (`chmod u-s`).
4. Write output summary `SUID_PERMISSIONS_AUDITED` to `$HOME/fs-sec-test/suid_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
