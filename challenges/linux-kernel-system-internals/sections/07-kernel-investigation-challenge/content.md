# Kernel Investigation Challenge

Root-cause an application/system failure where symptom is observed in userspace, but decisive diagnostic evidence resides in kernel interface layers.

In this 120 XP Expert capstone challenge, an application experiences severe performance degradation and random hanging. Userspace application logs reveal only generic timeouts.

To resolve the issue, you must look beneath the application layer down into kernel interfaces:
1. Check `/proc/[pid]/stack` to observe process kernel call stack stuck in `D` state.
2. Inspect `/proc/vmstat` and `/proc/meminfo` for kernel memory pool exhaustion.
3. Check VFS file descriptor limits in `/proc/sys/fs/file-nr`.
4. Inspect kernel dmesg ring buffer (`/proc/kmsg` or `dmesg`).

Synthesize all findings into a master kernel investigation diagnostic report.


---

## Lab Tasks

### Task 1: Investigate Kernel-Level Failure (`lnx-investigate-kernel-level-failure`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-kernel-level-failure
   ```
2. Create directory `$HOME/kernel-failure`:
   ```bash
   mkdir -p ~/kernel-failure
   ```
3. Investigate kernel memory, VFS limits, and kernel messages:
   ```bash
   cat /proc/sys/fs/file-nr
   grep -E "^(MemTotal|MemFree|Dirty|Writeback)" /proc/meminfo
   dmesg | tail -n 15 2>/dev/null || true
   ```
4. Write `KERNEL_LEVEL_FAILURE_ROOT_CAUSE_DIAGNOSED` into `$HOME/kernel-failure/kernel_investigation.log`:
   ```bash
   echo 'KERNEL_LEVEL_FAILURE_ROOT_CAUSE_DIAGNOSED' > ~/kernel-failure/kernel_investigation.log
   cat ~/kernel-failure/kernel_investigation.log
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

