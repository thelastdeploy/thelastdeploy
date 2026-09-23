# Linux Internals System Investigation Capstone Challenge

In this capstone challenge, an application service hangs or fails silently under production conditions. Rather than guessing, you must use Linux kernel internals tools (`/proc`, `strace`, `lsof`, `stat`, `pmap`) to investigate the system call execution boundary, identify the root cause of the failure, and document empirical proof.

---

## Investigation Methodology

1. **Process Inspection**: Check `/proc/<pid>/status`, `/proc/<pid>/cmdline`, and `/proc/<pid>/fd/`.
2. **System Call Trace**: Execute `strace -p <pid>` to observe where the process blocks (e.g. `futex`, `openat`, `flock`).
3. **Resource Analysis**: Inspect open files (`lsof`), virtual memory maps (`pmap`), and file locks (`/proc/locks`).
4. **Root Cause Proof**: Document empirical findings proving why the process is failing or hanging.

---

## Summary

Kernel internals diagnostics provide absolute clarity into process behavior, resolving complex failures that surface level tools cannot explain.

---

## Lab Tasks

### Task 1: Investigate System Behavior using Linux Internals Capstone (`lnx-investigate-system-from-internals`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-system-from-internals
   ```
2. Create directory `$HOME/internals-challenge`.
3. Investigate system behavior using `/proc`, `strace`, `lsof`, and syscall tracing.
4. Write output summary line `SYSTEM_BEHAVIOR_INVESTIGATED_FROM_INTERNALS: ROOT_CAUSE_PROVED` into `$HOME/internals-challenge/investigation.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
