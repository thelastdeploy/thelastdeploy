# System Behavior Tracing & Hidden Activity Investigation

Advanced troubleshooting requires observing live system execution behavior to uncover hidden activity, unlinked file descriptors holding disk space, or unexpected IPC signal delivery.

---

## 1. Unlinked Deleted Files Holding Disk Space

When a process keeps a file open after it is deleted (`rm`), the file entry is removed from its directory, but the underlying inode and data blocks remain allocated until the process closes the file handle:

```bash
# Find deleted files still held open by processes
lsof +L1

# Alternatively, inspect process file descriptors directly
ls -l /proc/*/fd/* 2>/dev/null | grep "(deleted)"
```

---

## 2. Advanced System Tracing (`strace` & `ltrace`)

```bash
# Trace all child processes spawned by a daemon
strace -ff -o /tmp/trace_out -p <PID>

# Trace library API calls (glibc)
ltrace -c /usr/bin/curl https://example.com
```

---

## Summary

Unlinked open file handles (`lsof +L1`) and multi-process tracing (`strace -ff`) reveal hidden disk space leaks and execution bugs.

---

## Lab Tasks

### Task 1: Trace System Execution Behavior (`lnx-trace-system-behavior`)
1. Start the lab:
   ```bash
   tld start lnx-trace-system-behavior
   ```
2. Create directory `$HOME/trace-test`.
3. Trace system execution behavior using `strace` or `ltrace`.
4. Write output summary line `SYSTEM_BEHAVIOR_TRACED` to `$HOME/trace-test/system_trace.log`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Investigate Hidden System and File Activity (`lnx-investigate-hidden-system-activity`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-hidden-system-activity
   ```
2. Create directory `$HOME/trace-test`.
3. Investigate deleted files held open by processes (`lsof +L1` or `/proc/*/fd/`).
4. Write output line `HIDDEN_ACTIVITY_INVESTIGATED` to `$HOME/trace-test/hidden_activity.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
