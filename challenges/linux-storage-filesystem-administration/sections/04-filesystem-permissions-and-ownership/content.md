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
