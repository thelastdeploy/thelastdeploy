# Kernel Modules and Device Drivers

Understanding dynamic kernel module loading (`lsmod`, `modprobe`, `insmod`), module dependency tracking, character/block device nodes, and udev device events.

Linux kernel modules (`.ko` binaries) allow dynamic extension of kernel capability at runtime without rebuilding the kernel core image.

### Module & Device Management
- **Module State**: `/proc/modules`, `/sys/module/`, `lsmod`, `modinfo`.
- **Devices**: Major and minor numbers define device driver binding (`/proc/devices`, `/dev/`). Character devices process byte streams; block devices support random access seekable blocks.


---

## Lab Tasks

### Task 1: Investigate Kernel Modules (`lnx-investigate-kernel-modules`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-kernel-modules
   ```
2. Create directory `$HOME/kernel-modules`:
   ```bash
   mkdir -p ~/kernel-modules
   ```
3. Inspect `/proc/modules` and module parameters in `/sys/module/`:
   ```bash
   head -n 10 /proc/modules
   ls -la /sys/module/ | head -n 10
   ```
4. Write `KERNEL_MODULES_AND_PARAMETERS_ANALYZED` into `$HOME/kernel-modules/module_analysis.txt`:
   ```bash
   echo 'KERNEL_MODULES_AND_PARAMETERS_ANALYZED' > ~/kernel-modules/module_analysis.txt
   cat ~/kernel-modules/module_analysis.txt
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Trace Device Kernel Interface (`lnx-trace-device-kernel-interface`)
1. Start the lab:
   ```bash
   tld start lnx-trace-device-kernel-interface
   ```
2. Create directory `$HOME/kernel-modules`:
   ```bash
   mkdir -p ~/kernel-modules
   ```
3. Inspect `/proc/devices`, `/proc/misc`, and device mappings in `/sys/dev/`:
   ```bash
   cat /proc/devices
   cat /proc/misc
   ls -la /sys/dev/char/ | head -n 10
   ```
4. Write `DEVICE_MAJOR_MINOR_INTERFACE_TRACED` into `$HOME/kernel-modules/device_interface.log`:
   ```bash
   echo 'DEVICE_MAJOR_MINOR_INTERFACE_TRACED' > ~/kernel-modules/device_interface.log
   cat ~/kernel-modules/device_interface.log
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

