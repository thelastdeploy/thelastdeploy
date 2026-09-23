# Severe Resource Exhaustion & Cascading Failures

Severe resource exhaustion occurs when runaway memory leaks, CPU lockups, or process handle depletion cascade across the operating system, triggering kernel OOM (Out-Of-Memory) killer invocations or unresponsive system shells.

---

## 1. Kernel Out-Of-Memory (OOM) Investigation

When RAM is completely exhausted, the Linux kernel OOM killer terminates processes to prevent kernel crash:

```bash
# Search dmesg and system logs for OOM killer invocations
dmesg -T | grep -i oom
journalctl -k | grep -i "Out of memory"
```

---

## 2. Resource Starvation Diagnostics

```bash
# Check memory allocation and active swap thrashing
free -m
vmstat 1 5

# Check per-process thread and memory consumption
ps aux --sort=-%mem | head -n 10

# Check system file descriptor exhaustion
cat /proc/sys/fs/file-nr
```

---

## Summary

Inspecting kernel logs (`dmesg | grep oom`) and process memory (`ps aux --sort=-%mem`) identifies memory leak culprits.

---

## Lab Tasks

### Task 1: Investigate Severe Resource Exhaustion (`lnx-investigate-resource-exhaustion`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-resource-exhaustion
   ```
2. Create directory `$HOME/res-outage-test`.
3. Investigate severe resource exhaustion and OOM killer log entries.
4. Write output summary line `RESOURCE_EXHAUSTION_DIAGNOSED` to `$HOME/res-outage-test/exhaustion_report.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Recover Resource-Starved Production Server (`lnx-recover-resource-starved-server`)
1. Start the lab:
   ```bash
   tld start lnx-recover-resource-starved-server
   ```
2. Create directory `$HOME/res-outage-test`.
3. Terminate runaway memory leak process and restore system responsiveness.
4. Write proof line `RESOURCE_STARVED_SERVER_RECOVERED` to `$HOME/res-outage-test/server_recovered.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
