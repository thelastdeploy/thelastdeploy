# System & Kernel Internals Mastery

Demonstrate mastery of Linux kernel interfaces: procfs, sysfs, virtual memory address spaces (VMA), VFS inode tables, and ftrace kernel tracing.

System mastery evaluates your ability to look beneath userspace abstractions down into kernel data structures (`task_struct`, VMA maps, VFS file descriptor tables, page fault metrics).


---

## Lab Tasks

### Task 1: Investigate Linux From Kernel Up (`lnx-investigate-linux-from-kernel-up`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-linux-from-kernel-up
   ```
2. Create directory `$HOME/mastery-internals`.
3. Analyze kernel state interfaces in `/proc`, `/sys`, and `/sys/kernel/tracing`.
4. Write `KERNEL_AND_SYSTEM_INTERNALS_MASTERED` into `$HOME/mastery-internals/internals_mastery.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
