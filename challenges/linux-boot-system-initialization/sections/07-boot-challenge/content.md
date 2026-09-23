# Unbootable System Recovery Capstone Challenge

In this capstone challenge, a production Linux server fails during startup following a series of system configuration edits. The machine reaches GRUB and loads the kernel, but fails to reach a usable login environment.

---

## Troubleshooting Checklist

1. **Kernel Parameters**: Verify `/proc/cmdline` for typos or incorrect `root=UUID` flags.
2. **Mount Configurations**: Inspect `/etc/fstab` for invalid mount entries or syntax errors.
3. **Initramfs Integrity**: Verify storage driver module availability in initramfs.
4. **Service Dependencies**: Inspect `journalctl -xb` for failing systemd units blocking boot targets.

---

## Lab Tasks

### Task 1: Recover Unbootable Linux Server Capstone (`lnx-recover-unbootable-system`)
1. Start the lab:
   ```bash
   tld start lnx-recover-unbootable-system
   ```
2. Create directory `$HOME/boot-capstone`.
3. Create recovery script `$HOME/boot-capstone/repair_boot.sh` that fixes corrupted boot settings.
4. Write summary line `UNBOOTABLE_SYSTEM_RECOVERED` into `$HOME/boot-capstone/recovery.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
