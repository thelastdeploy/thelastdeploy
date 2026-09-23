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
2. Create directory `$HOME/kernel-modules`.
3. Inspect `/proc/modules` and module parameters in `/sys/module/`.
4. Write `KERNEL_MODULES_AND_PARAMETERS_ANALYZED` into `$HOME/kernel-modules/module_analysis.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Trace Device Kernel Interface (`lnx-trace-device-kernel-interface`)
1. Start the lab:
   ```bash
   tld start lnx-trace-device-kernel-interface
   ```
2. Inspect `/proc/devices` and `/proc/misc`.
3. Correlate `/dev` nodes with major/minor numbers in `/sys/dev/`.
4. Write `DEVICE_MAJOR_MINOR_INTERFACE_TRACED` into `$HOME/kernel-modules/device_interface.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
