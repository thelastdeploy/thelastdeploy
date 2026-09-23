# Production Workload Optimization Capstone Challenge

In this 110 XP Expert capstone challenge, a high-throughput production workload suffers from non-obvious multi-subsystem bottlenecks (CPU thread context switching + unoptimized block I/O scheduler + conservative sysctl memory writeback).

There is no single "magic button" optimization. You must execute the full performance engineering loop: Workload Model -> Measure Baseline -> Find Multi-Subsystem Bottlenecks -> Apply Cross-Layer Tuning (CPU affinity, sysctl vm/net, blk-mq scheduler) -> Benchmark Changes -> Compare Pre/Post Metrics -> Validate SLA Attainment -> Author Validation Report.

---

## Performance Engineering Report Template

```text
=== PRODUCTION WORKLOAD PERFORMANCE ENGINEERING REPORT ===
Workload Profile: High-Throughput OLTP Application
SLA Target: p95 Latency < 5ms, IOPS > 30,000

Identified Subsystem Bottlenecks:
1. CPU: Excessive thread migration across NUMA nodes.
2. Memory: Aggressive page writeback causing application write stalls.
3. Storage: Sub-optimal default blk-mq queue scheduler on NVMe storage.

Optimizations Applied:
- CPU: Bound application threads to NUMA node 0 via taskset/numactl.
- Memory: Set vm.dirty_background_ratio=5 and vm.dirty_ratio=15.
- Storage: Set NVMe block device queue scheduler to 'none'.
- Network: Tuned net.core.somaxconn=65535 and TCP window buffers.

Validation Results:
- Baseline p95 Latency: 19.4ms  -->  Post-Tuning p95 Latency: 2.8ms (-85.5%)
- Baseline IOPS: 11,200        -->  Post-Tuning IOPS: 48,500 (+333%)
SLA Attainment: PASSED
Status: PRODUCTION_WORKLOAD_OPTIMIZED_AND_VALIDATED
```

---

## Summary

Executing the complete performance engineering feedback loop proves your ability to optimize complex production workloads across CPU, memory, storage, and network layers.

---

## Lab Tasks

### Task 1: Optimize Production Workload Capstone (`lnx-optimize-production-workload`)
1. Start the lab:
   ```bash
   tld start lnx-optimize-production-workload
   ```
2. Create directory `$HOME/perf-capstone`.
3. Execute the 7-step performance engineering loop (Model, Measure, Find Bottleneck, Apply Cross-Layer Tuning, Benchmark, Compare, Validate SLA).
4. Write master optimization report line `PRODUCTION_WORKLOAD_OPTIMIZED_AND_VALIDATED` into `$HOME/perf-capstone/optimization_validation.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
