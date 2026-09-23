# Performance Baselining & Bottleneck Identification

Performance analysis begins with methodical measurement rather than random tuning. System administrators must establish a known good performance baseline under normal operational loads before attempting to diagnose performance degradation.

---

## 1. The Methodical Performance Analysis Flow

```text
+-------------------+     +-------------------------+     +--------------------------+
| 1. Measure System | --> | 2. Identify Subsystem   | --> | 3. Find Offending        |
|    Metrics        |     |    Bottleneck           |     |    Process / Workload    |
+-------------------+     +-------------------------+     +--------------------------+
                                                                       |
                                                                       v
+-------------------+     +-------------------------+     +--------------------------+
| 5. Remediate &    | <-- | 4. Prove & Correlate    | <-- | 4. Trace System Calls /  |
|    Verify         |     |    Root Cause           |     |    Resource Contention   |
+-------------------+     +-------------------------+     +--------------------------+
```

---

## 2. The Four Primary Subsystems

System performance degradation is driven by saturation or contention in four core subsystems:

1. **CPU**: High run-queue length (`vmstat r`), high user (`%usr`) or system (`%sys`) usage.
2. **Memory**: Active RAM exhaustion, high page scan rates, or active swap-in/out (`vmstat si/so`).
3. **Storage I/O**: High device utilization (`iostat %util`), long request wait time (`await`), or disk queue depth.
4. **Network**: High socket backlog drops, packet retransmissions, or bandwidth saturation.

---

## 3. High-Level Metrics Inspection

```bash
# View system load average (1m, 5m, 15m)
uptime

# Inspect memory utilization summary
free -h

# Check block device disk space and mounts
df -h
```

---

## Summary

Baselining establishes normal performance boundaries so anomalies can be isolated quickly during incidents.

---

## Lab Tasks

### Task 1: Establish System Performance Baseline (`lnx-establish-performance-baseline`)
1. Start the lab:
   ```bash
   tld start lnx-establish-performance-baseline
   ```
2. Create directory `$HOME/perf-test`.
3. Measure baseline CPU, memory, and disk metrics (`uptime`, `free -h`, `df -h`).
4. Write baseline output summary line `PERFORMANCE_BASELINE_ESTABLISHED` to `$HOME/perf-test/baseline.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Identify System Resource Bottlenecks (`lnx-identify-system-bottleneck`)
1. Start the lab:
   ```bash
   tld start lnx-identify-system-bottleneck
   ```
2. Create directory `$HOME/perf-test`.
3. Analyze system load average and resource utilization metrics to identify primary constrained subsystem.
4. Write output line `BOTTLENECK_IDENTIFIED: CPU` to `$HOME/perf-test/bottleneck.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
