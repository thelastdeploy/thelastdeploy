# Rescue Mode & Emergency Target Recovery

When a Linux system cannot complete normal boot processing, administrators boot into special single-user targets (`rescue.target` or `emergency.target`) or chroot from a live CD to perform system repairs.

---

## 1. Systemd Rescue vs Emergency Targets

- **`rescue.target`**: Mounts all local filesystems and starts basic services with a single-user root shell.
- **`emergency.target`**: Mounts root filesystem read-only without initializing extra services; provides minimal shell for critical repairs.

```bash
# Switch to rescue mode from running system
systemctl isolate rescue.target

# Remount root filesystem as read-write in emergency shell
mount -o remount,rw /
```

---

## 2. Live Environment `chroot` Recovery

When system bootloader or core binaries are corrupted, boot from a live USB environment and chroot into the host root partition:

```bash
# Mount host root partition to /mnt
mount /dev/sda1 /mnt

# Bind virtual filesystems
mount --bind /dev /mnt/dev
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys

# Chroot into host environment
chroot /mnt
```

---

## Summary

`mount -o remount,rw /` and live environment `chroot` provide full administrative control to recover unbootable Linux systems.

---

## Lab Tasks

### Task 1: Recover System from Rescue Target (`lnx-recover-system-from-rescue-mode`)
1. Start the lab:
   ```bash
   tld start lnx-recover-system-from-rescue-mode
   ```
2. Create directory `$HOME/rescue-test`.
3. Document root filesystem remount command syntax (`mount -o remount,rw /`).
4. Write summary `RESCUE_MODE_RECOVERY_VERIFIED` to `$HOME/rescue-test/rescue_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
