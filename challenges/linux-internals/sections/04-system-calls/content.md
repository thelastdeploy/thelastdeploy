# User/Kernel Boundary & System Calls

System Calls (syscalls) are the programmatic interface through which user space applications request services from the Linux kernel. System calls enforce hardware protection boundaries by transitioning execution from Ring 3 (User Space) to Ring 0 (Kernel Space).

---

## 1. User Space vs Kernel Space Boundary

```text
+-------------------------------------------------------+
| USER SPACE (Ring 3)                                    |
|   Application Code (C, Python, Go)                     |
|   Standard C Library (glibc / musl)                   |
+--------------------------+----------------------------+
                           | System Call Interface
                           v (e.g. syscall / sysenter)
+-------------------------------------------------------+
| KERNEL SPACE (Ring 0)                                 |
|   VFS / Process Scheduler / Memory Management / Networking|
|   Device Drivers                                      |
+--------------------------+----------------------------+
                           | Hardware Control
                           v
| HARDWARE (CPU, Memory, Storage, NIC)                  |
+-------------------------------------------------------+
```

---

## 2. Tracing System Calls (`strace`)

`strace` intercepts and records system calls made by a process:

```bash
# Trace system calls of a command
strace -c ls -l

# Trace specific system calls (file operations)
strace -e trace=openat,read,write cat /etc/passwd

# Attach to running process PID
strace -p 1234
```

---

## Summary

System calls provide the secure gateway for user space processes to request kernel resources. `strace` exposes this boundary in real time.

---

## Lab Tasks

### Task 1: Observe System Call Boundary (`lnx-observe-system-calls`)
1. Start the lab:
   ```bash
   tld start lnx-observe-system-calls
   ```
2. Create directory `$HOME/syscall-test`.
3. Observe user/kernel space system call boundary.
4. Write summary output `SYSTEM_CALL_BOUNDARY_OBSERVED` into `$HOME/syscall-test/syscall_basics.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Trace Application System Calls with strace (`lnx-trace-application-system-calls`)
1. Start the lab:
   ```bash
   tld start lnx-trace-application-system-calls
   ```
2. Create directory `$HOME/syscall-test`.
3. Trace process system calls using `strace -c`.
4. Write output summary line `STRACE_SUMMARY_VERIFIED` to `$HOME/syscall-test/strace_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
