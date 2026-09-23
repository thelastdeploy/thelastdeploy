# Linux Boot Sequence & Stage Architecture

The Linux boot process transforms powered-off hardware into a fully functional multi-user operating system through a sequence of deterministic stages. Each stage initializes specific hardware components before handing off control to the next layer in the boot chain.

---

## The Linux Boot Chain Architecture

```text
+-----------------------+
|  1. Firmware          |  BIOS / UEFI initializes hardware & locates bootloader
+-----------+-----------+
            |
            v
+-----------------------+
|  2. Bootloader        |  GRUB2 loads kernel (vmlinuz) & initramfs into RAM
+-----------+-----------+
            |
            v
+-----------------------+
|  3. Linux Kernel      |  Decompresses kernel, initializes hardware drivers & CPU
+-----------+-----------+
            |
            v
+-----------------------+
|  4. initramfs         |  Temporary RAM root filesystem mounts real root (/)
+-----------+-----------+
            |
            v
+-----------------------+
|  5. systemd (PID 1)   |  Executes userspace units & reaches default target
+-----------------------+
```

---

## Boot Stages Detailed

1. **Firmware (BIOS / UEFI)**: Performs POST (Power-On Self-Test), identifies boot devices, and executes bootloader code from MBR (Master Boot Record) or EFI System Partition (ESP).
2. **Bootloader (GRUB2)**: Presents boot menu, loads selected Linux kernel (`vmlinuz-x.y.z`) and initial RAM filesystem (`initrd.img`) into memory, and passes kernel boot arguments.
3. **Kernel Initialization**: Sets up memory management, device drivers, and CPU architecture routines.
4. **initramfs / initrd**: Minimal temporary filesystem containing storage/RAID/NVMe drivers required to locate, unlock (LUKS), and mount the real root (`/`) filesystem.
5. **systemd Userspace**: Replaces initramfs PID 1, mounts filesystems from `/etc/fstab`, and starts system services up to `multi-user.target` or `graphical.target`.

---

## Summary

Understanding the handoff between Firmware -> Bootloader -> Kernel -> initramfs -> systemd enables targeted troubleshooting when a server fails during boot.

---

## Lab Tasks

### Task 1: Identify Core Boot Components (`lnx-identify-boot-components`)
1. Start the lab:
   ```bash
   tld start lnx-identify-boot-components
   ```
2. Create directory `$HOME/boot-test`.
3. Inspect boot files in `/boot` directory.
4. Write output summary line `BOOT_COMPONENTS_INSPECTED` to `$HOME/boot-test/boot_files.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Trace Linux Boot Process Stages (`lnx-trace-linux-boot-process`)
1. Start the lab:
   ```bash
   tld start lnx-trace-linux-boot-process
   ```
2. Create directory `$HOME/boot-test`.
3. Write the 5 Linux boot stages in order into `$HOME/boot-test/boot_stages.txt`:
4. - Line 1: `1. FIRMWARE`
5. - Line 2: `2. BOOTLOADER`
6. - Line 3: `3. KERNEL`
7. - Line 4: `4. INITRAMFS`
8. - Line 5: `5. SYSTEMD`
9. Validate your solution:
   ```bash
   tld check
   ```
