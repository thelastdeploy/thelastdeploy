# Benchmarking & Performance Validation

System tuning must be empirically validated through synthetic benchmarking before and after configuration changes to prove measurable performance improvements and verify that SLA targets are met.

---

## 1. Synthetic Benchmarking Tools

- **`fio` (Flexible I/O Tester)**: Benchmark block storage IOPS, sequential/random read/write throughput, and latency.
- **`sysbench`**: Benchmark CPU execution, memory allocation speed, and OLTP database transactions.
- **`iperf3`**: Benchmark network bandwidth and packet throughput.

```bash
# Benchmark random read IOPS with fio
fio --name=random-read --ioengine=libaio --rw=randread --bs=4k --numjobs=4 --size=500M --runtime=10 --time_based --group_reporting

# Benchmark CPU execution with sysbench
sysbench cpu --cpu-max-prime=20000 run
```

---

## 2. Before vs After Comparison Matrix

| Metric | Pre-Tuning Baseline | Post-Tuning Result | Percentage Improvement | SLA Target Met? |
| :--- | :--- | :--- | :--- | :--- |
| Random Read IOPS | `12,500` | `45,200` | **+261%** | PASS |
| p95 Latency | `18.4 ms` | `3.2 ms` | **-82.6%** | PASS |
| Context Switches/sec | `85,000` | `12,000` | **-85.8%** | PASS |

---

## Summary

Executing pre-tuning baseline and post-tuning benchmark comparisons empirically proves performance gains.

---

## Lab Tasks

### Task 1: Benchmark and Validate System Tuning Changes (`lnx-benchmark-system-changes`)
1. Start the lab:
   ```bash
   tld start lnx-benchmark-system-changes
   ```
2. Create directory `$HOME/bench-test`.
3. Execute synthetic benchmark comparisons before and after system tuning changes (`fio` or `sysbench`).
4. Write output comparison report line `BENCHMARK_VALIDATION_COMPLETE: IMPROVEMENT_PROVED` into `$HOME/bench-test/benchmark_comparison.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
