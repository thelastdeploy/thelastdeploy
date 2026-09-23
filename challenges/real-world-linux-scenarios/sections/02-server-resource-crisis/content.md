# Server Resource Crisis Scenarios

Troubleshoot servers experiencing severe CPU contention, memory exhaustion (OOM Killer), high load average driven by uninterruptible I/O wait (`D` state), and runaway processes.

Resource crises often manifest as system unresponsiveness. However, high load average does not always mean high CPU utilization; load average measures tasks in runnable state (`R`) plus tasks stuck in uninterruptible disk I/O (`D`).

### Resource Crisis Triaging
- **High CPU vs High Load**: `top`, `mpstat 1`, `pidstat 1`.
- **OOM Invocation**: Inspect `dmesg | grep -i oom` or `/var/log/messages` to trace process termination by kernel OOM killer.
- **Rogue Process Identification**: Correlate high CPU/memory consumption with process execution arguments (`/proc/[pid]/cmdline`).


---

## Lab Tasks

### Task 1: Recover Resource-Exhausted Server (`lnx-recover-resource-exhausted-server`)
1. Start the lab:
   ```bash
   tld start lnx-recover-resource-exhausted-server
   ```
2. Create directory `$HOME/resource-crisis`.
3. Identify memory-leaking processes from OOM logs and `/proc/meminfo`.
4. Apply memory cgroup limits and restore server stability.
5. Write `RESOURCE_EXHAUSTED_SERVER_RECOVERED` into `$HOME/resource-crisis/oom_recovery.log`.
6. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Investigate Unexplained High Load Average (`lnx-investigate-unexplained-load`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-unexplained-load
   ```
2. Analyze processes in `D` state (`ps aux | awk '$8 ~ /D/'`).
3. Identify block device I/O bottleneck using `iostat -xz 1`.
4. Resolve storage lockup and write `UNEXPLAINED_HIGH_LOAD_DIAGNOSED_AND_RESOLVED` into `$HOME/resource-crisis/high_load_analysis.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
