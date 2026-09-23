# Kernel Initialization & initramfs Mechanics

After GRUB loads the Linux kernel binary (`vmlinuz`) into RAM, the kernel initializes hardware architecture drivers and mounts the `initramfs` (Initial RAM Filesystem) archive into memory as the temporary root directory.

---

## 1. Kernel Command Line Parameters (`/proc/cmdline`)

The kernel receives runtime configuration arguments passed by the bootloader:

```bash
# View arguments passed to the running kernel
cat /proc/cmdline

# Example /proc/cmdline output:
# BOOT_IMAGE=/vmlinuz-5.15.0-100-generic root=UUID=a1b2c3d4-e5f6-7890 ro quiet splash
```

Key kernel parameters:
- `root=UUID=...`: Specifies real root filesystem device UUID.
- `ro`: Mounts root filesystem read-only initially during boot.
- `quiet`: Suppresses non-critical kernel log messages during boot.
- `systemd.unit=...`: Overrides default systemd target at boot.

---

## 2. Inspecting Kernel Modules and initramfs

```bash
# Inspect running kernel version
uname -r

# List loaded kernel modules
lsmod

# Inspect contents of initramfs archive
lsinitramfs /boot/initrd.img-$(uname -r) | head -n 20
```

---

## Summary

`initramfs` contains kernel modules and early setup scripts required to mount the real root partition before pivoting root (`pivot_root`).

---

## Lab Tasks

### Task 1: Inspect Running Kernel and Parameters (`lnx-inspect-running-kernel`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-running-kernel
   ```
2. Create directory `$HOME/kernel-test`.
3. Inspect `/proc/cmdline` and kernel version (`uname -r`).
4. Write output summary line `KERNEL_CMDLINE_INSPECTED` to `$HOME/kernel-test/cmdline_info.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Investigate initramfs Image Contents (`lnx-investigate-initramfs`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-initramfs
   ```
2. Create directory `$HOME/kernel-test`.
3. Inspect initramfs image structure in `/boot/` using `lsinitramfs` or `ls -l /boot/initrd*`.
4. Write output summary `INITRAMFS_INSPECTED` to `$HOME/kernel-test/initramfs_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
