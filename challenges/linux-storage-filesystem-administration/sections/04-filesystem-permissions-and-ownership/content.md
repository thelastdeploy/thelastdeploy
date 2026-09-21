# Filesystem Permissions and Ownership

Newly created or formatted storage volumes inherit root-only default permissions (`root:root` with mode `755` or `700`) upon initial mounting.

## 1. Setting Mount Point Ownership

To allow an application account or non-root group to read and write to a mounted volume, adjust mount point directory ownership:

```bash
chown -R appuser:appgroup /mnt/appdata
```

## 2. Directory Permission Modes

Set appropriate directory permissions to control user access:

```bash
# Grant Owner full access, Group read/execute, Others read/execute
chmod 755 /mnt/appdata

# Restrict access strictly to Owner only
chmod 700 /mnt/private_storage
```

## 3. Security Mount Options (`/etc/fstab`)

Harden mounted filesystems using mount options:
- `ro`: Mount storage volume in Read-Only mode.
- `noexec`: Prevent execution of binary files residing on the volume.
- `nosuid`: Disable SUID/SGID bit evaluation on the volume.

---

## Lab Tasks

### Task 1: Secure Mounted Storage Permissions (`lnx-secure-mounted-storage`)
1. Start the lab:
   ```bash
   tld start lnx-secure-mounted-storage
   ```
2. Secure mounted directory permissions and ownership.
3. Set strict directory owner permissions (`755` or `700`) on mounted storage directories and record audit status in `$HOME/storage-test/sec_audit.txt`.
4. Validate your solution:
   ```bash
   tld check
   ```
