# CPU Saturation & Workload Tracing

CPU performance degradation occurs due to **CPU Saturation** (more threads demanding CPU execution than available CPU cores) or **CPU Contention** (excessive context switching or kernel lock wait times).

---

## 1. Load Average vs CPU Utilization

- **Load Average** (`uptime`): Represents the average number of threads in an R (running) or D (uninterruptible sleep) state over 1, 5, and 15 minutes.
- **CPU Utilization** (`mpstat`): Measures percentage of time CPU cores spent executing user code (`%usr`), kernel code (`%sys`), waiting for I/O (`%iowait`), or idle (`%idle`).

```bash
# View per-CPU breakdown
mpstat -P ALL 1 3

# View run-queue length (column 'r') and context switches (column 'cs')
vmstat 1 5
```

---

## 2. Tracing Offending CPU Workloads

Once CPU saturation is identified, locate the specific process PIDs consuming CPU execution time:

```bash
# Sort processes by CPU utilization
ps aux --sort=-%cpu | head -n 10

# Monitor per-process CPU statistics in real-time
pidstat -u 1 5
```

---

## Summary

High `vmstat r` run-queue numbers indicate CPU saturation, while `pidstat -u` pinpoints the responsible processes.

---

## Lab Tasks

### Task 1: Analyze CPU Saturation and Run Queue (`lnx-analyze-cpu-saturation`)
1. Start the lab:
   ```bash
   tld start lnx-analyze-cpu-saturation
   ```
2. Create directory `$HOME/cpu-perf-test`.
3. Analyze CPU run-queue length (`vmstat 1`) and per-core CPU breakdown (`mpstat -P ALL`).
4. Write output line `CPU_SATURATION_ANALYZED` to `$HOME/cpu-perf-test/cpu_analysis.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Trace CPU-Intensive Workload Process (`lnx-trace-cpu-intensive-workload`)
1. Start the lab:
   ```bash
   tld start lnx-trace-cpu-intensive-workload
   ```
2. Create directory `$HOME/cpu-perf-test`.
3. Identify process consuming CPU time using `ps aux --sort=-%cpu` or `pidstat -u`.
4. Write output line `OFFENDING_CPU_PROCESS_IDENTIFIED` into `$HOME/cpu-perf-test/offending_pid.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
