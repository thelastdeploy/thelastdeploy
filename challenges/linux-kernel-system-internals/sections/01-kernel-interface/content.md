# Kernel Interface

Understanding how the Linux kernel exposes live subsystem state and tuneables to userspace via virtual pseudo-filesystems (`/proc` and `/sys`).

The Linux kernel uses synthetic pseudo-filesystems—primarily `/proc` (procfs) and `/sys` (sysfs)—to expose kernel internal data structures, hardware state, and configuration interfaces directly to userspace without requiring custom kernel APIs.

### Procfs vs Sysfs
- **/proc**: Process-centric and legacy system subsystem view (`/proc/[pid]/`, `/proc/meminfo`, `/proc/sched_debug`).
- **/sys**: Structured, object-oriented kobject hierarchy modeling devices, drivers, buses, power, and kernel subsystems (`/sys/devices/`, `/sys/class/`, `/sys/bus/`).

Understanding procfs entries like `/proc/sys/` and sysfs dynamic attributes is fundamental to inspecting active kernel state directly from userspace.


---

## Lab Tasks

### Task 1: Explore Kernel Information (`lnx-explore-kernel-information`)
1. Start the lab:
   ```bash
   tld start lnx-explore-kernel-information
   ```
2. Create directory `$HOME/kernel-interface`.
3. Inspect `/proc/version`, `/proc/cmdline`, and `/proc/sys/kernel/osrelease`.
4. Write `KERNEL_VERSION_AND_CMDLINE_INSPECTED` to `$HOME/kernel-interface/kernel_info.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Investigate procfs and sysfs (`lnx-investigate-proc-and-sys`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-proc-and-sys
   ```
2. Explore process status in `/proc/self/status` and `/proc/self/smaps_rollup`.
3. Inspect device buses in `/sys/bus/` and system parameters in `/sys/kernel/`.
4. Write `PROC_SYS_SUBSYSTEM_HIERARCHY_ANALYZED` into `$HOME/kernel-interface/proc_sys_analysis.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
