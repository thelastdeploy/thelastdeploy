# Bootloader & Kernel Boot Parameters

GRUB2 (GRand Unified Bootloader version 2) is the standard Linux bootloader. GRUB loads the kernel binary and initramfs into memory based on configuration files generated from `/etc/default/grub` and `/etc/grub.d/`.

---

## 1. GRUB Configuration Architecture

Administrators modify high-level boot options in `/etc/default/grub`, then generate the active configuration file (`/boot/grub/grub.cfg`):

```bash
# High-level default configuration file
cat /etc/default/grub

# Key configuration parameters:
# GRUB_DEFAULT=0
# GRUB_TIMEOUT=5
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"

# Generate new grub.cfg after modifying /etc/default/grub
update-grub
# OR on RHEL/CentOS/Fedora:
# grub2-mkconfig -o /boot/grub2/grub.cfg
```

---

## 2. Interactive Kernel Parameter Modification

During boot, administrators can interrupt GRUB menu execution by pressing `e` to edit kernel command line arguments temporarily (e.g., appending `init=/bin/bash` or `systemd.unit=emergency.target` to recover an unbootable system).

---

## Summary

High-level defaults in `/etc/default/grub` generate `/boot/grub/grub.cfg` via `update-grub` / `grub2-mkconfig`.

---

## Lab Tasks

### Task 1: Inspect Bootloader Configuration (`lnx-inspect-bootloader-configuration`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-bootloader-configuration
   ```
2. Create directory `$HOME/grub-test`.
3. Inspect `/etc/default/grub` file settings.
4. Write summary line `GRUB_CONFIG_INSPECTED` to `$HOME/grub-test/grub_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Manage Kernel Boot Parameters (`lnx-manage-kernel-boot-options`)
1. Start the lab:
   ```bash
   tld start lnx-manage-kernel-boot-options
   ```
2. Create directory `$HOME/grub-test`.
3. Create file `$HOME/grub-test/kernel_flags.txt` containing custom kernel flags configuration line `GRUB_CMDLINE_LINUX="quiet splash systemd.unit=multi-user.target"`.
4. Validate your solution:
   ```bash
   tld check
   ```
