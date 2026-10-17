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
3. Set directory permissions to `755` on `$HOME/storage-test/mounted_dir` and save its `owner:group` identity to `$HOME/storage-test/sec_audit.txt`:
   ```bash
   chmod 755 ~/storage-test/mounted_dir
   stat -c "%U:%G" ~/storage-test/mounted_dir > ~/storage-test/sec_audit.txt
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
