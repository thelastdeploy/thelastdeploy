# Kernel Information Interfaces (/proc, /sys, /dev)

Linux exposes device drivers, kernel configuration parameters, and hardware structures through three virtual pseudo-filesystems: `/proc`, `/sys`, and `/dev`.

---

## 1. Virtual Filesystem Roles

| Pseudo-FS | Mount Type | Purpose |
| :--- | :--- | :--- |
| `/proc` | `procfs` | Process runtime information and kernel tuneables (`/proc/sys/`) |
| `/sys` | `sysfs` | Unified kernel object device model (buses, drivers, power management) |
| `/dev` | `devtmpfs` | Device nodes representing character and block hardware interfaces |

---

## 2. Block vs Character Devices (`/dev`)

- **Block Devices** (`b`): Access data in fixed-size blocks (disks, SSDs, partitions: `/dev/sda`, `/dev/nvme0n1`).
- **Character Devices** (`c`): Access data as unbuffered stream of bytes (tty, serial ports, random generators: `/dev/tty`, `/dev/urandom`).

```bash
# View sysctl kernel runtime tuneables
sysctl -a | head -n 20

# Inspect device model in sysfs
ls -la /sys/block/
```

---

## Summary

`/proc`, `/sys`, and `/dev` allow userspace tools to inspect and configure kernel subsystems without custom system calls.

---

## Lab Tasks

### Task 1: Inspect Kernel and Device Interfaces in sysfs and procfs (`lnx-inspect-kernel-device-interface`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-kernel-device-interface
   ```
2. Create directory `$HOME/sysfs-test`.
3. Inspect virtual filesystems (`/proc`, `/sys`, `/dev`).
4. Write output summary line `KERNEL_DEVICE_INTERFACES_INSPECTED` to `$HOME/sysfs-test/interfaces.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
