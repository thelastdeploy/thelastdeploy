# Workload Performance Modeling & SLA Targets

Performance engineering focuses on proactively designing, tuning, and benchmarking system parameters to optimize workload throughput and latency, rather than merely diagnosing reactive failures.

---

## 1. The Performance Engineering Feedback Loop

```text
+---------------------+     +-----------------------+     +--------------------------+
| 1. Model Workload   | --> | 2. Measure & Find     | --> | 3. Tune System           |
|    & SLA Targets    |     |    Subsystem Limits   |     |    Parameters            |
+---------------------+     +-----------------------+     +--------------------------+
                                                                       |
                                                                       v
+---------------------+     +-----------------------+     +--------------------------+
| 6. Validate & Prove | <-- | 5. Compare Latency &  | <-- | 4. Benchmark Changes     |
|    SLA Attainment   |     |    Throughput Gain    |     |    (sysbench, fio)       |
+---------------------+     +-----------------------+     +--------------------------+
```

---

## 2. Workload Classification & SLA Metrics

Workloads fall into distinct operational profiles:

- **CPU-Bound**: High mathematical execution, low I/O wait (e.g., encryption, video encoding, machine learning inference).
- **I/O-Bound**: High disk read/write or network socket operations (e.g., databases, web proxies, object storage).
- **Memory-Bound**: Large memory working set size exceeding L3 cache or physical RAM (e.g., in-memory caches, analytics engines).

Key SLA Metrics:
- **Throughput**: Transactions or requests processed per second (RPS / IOPS / MB/s).
- **Latency Percentiles**: Service response times measured at **p50**, **p95**, and **p99** to capture tail latency.

---

## Summary

Workload modeling establishes explicit SLA latency percentiles (p95/p99) and throughput targets before system tuning begins.

---

## Lab Tasks

### Task 1: Model System Workload Profile (`lnx-model-system-workload`)
1. Start the lab:
   ```bash
   tld start lnx-model-system-workload
   ```
2. Create directory `$HOME/perf-eng-test`.
3. Model system workload classification (CPU-bound vs I/O-bound vs memory-bound).
4. Write output summary line `WORKLOAD_MODEL_ESTABLISHED` to `$HOME/perf-eng-test/workload_model.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Establish SLA and Performance Targets (`lnx-establish-performance-targets`)
1. Start the lab:
   ```bash
   tld start lnx-establish-performance-targets
   ```
2. Create directory `$HOME/perf-eng-test`.
3. Define SLA target latency (p95 / p99) and throughput benchmark targets.
4. Write target document output line `PERFORMANCE_SLA_TARGETS_DEFINED` to `$HOME/perf-eng-test/sla_targets.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
