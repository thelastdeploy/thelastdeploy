# Boot Failure Diagnosis & Error Analysis

Boot failures occur when a required component in the boot chain fails to initialize. Common failure points include invalid root filesystem UUIDs in `/etc/fstab`, corrupted initramfs images, or missing kernel modules.

---

## 1. Common Boot Failure Root Causes

| Failure Symptom | Common Root Cause | Diagnostic Strategy |
| :--- | :--- | :--- |
| `Kernel Panic: Unable to mount root fs` | Wrong `root=UUID=` in GRUB or missing storage driver in initramfs | Check GRUB parameters and `blkid` |
| Dropped to `Emergency Mode` | Invalid entry in `/etc/fstab` (non-existent UUID or bad mount option) | Inspect `/etc/fstab` and `journalctl -xb` |
| Frozen at GRUB prompt (`grub>`) | Corrupted `grub.cfg` or missing boot partition | Reinstall GRUB via chroot |

---

## 2. Emergency Mode Inspection

When boot drops into emergency mode:

```bash
# View boot errors from current boot attempt
journalctl -xb -p 3

# Test mounting all filesystems defined in /etc/fstab
mount -a
```

---

## Summary

Correlating GRUB kernel parameters, `/etc/fstab` device UUIDs, and `journalctl -xb` logs isolates boot failures effectively.

---

## Lab Tasks

### Task 1: Investigate Failed Boot Configuration (`lnx-investigate-failed-boot`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-failed-boot
   ```
2. Create directory `$HOME/boot-fail-test`.
3. Inspect sample broken `/etc/fstab` entries in `$HOME/boot-fail-test/fstab.broken` (referencing non-existent UUID `UUID=ffff-ffff`).
4. Write diagnosis line `BOOT_FAIL_REASON: invalid_fstab_uuid` to `$HOME/boot-fail-test/diag_report.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Recover Broken Boot Configuration (`lnx-recover-broken-boot-configuration`)
1. Start the lab:
   ```bash
   tld start lnx-recover-broken-boot-configuration
   ```
2. Inspect `$HOME/boot-fail-test/fstab.broken`.
3. Add `nofail` option or fix invalid UUID entry, writing repaired configuration to `$HOME/boot-fail-test/fstab.fixed`.
4. Validate your solution:
   ```bash
   tld check
   ```
