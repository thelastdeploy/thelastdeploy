# Performance Mastery

Demonstrate mastery of CPU, memory, storage I/O, and kernel network stack tuning to achieve strict SLA performance targets.

Performance mastery tests your ability to model workloads, isolate multi-subsystem bottlenecks, tune sysctl kernel parameters, set CPU affinity, and validate gains using benchmarking tools (`fio`, `sysbench`).


---

## Lab Tasks

### Task 1: Optimize Linux Workload (`lnx-optimize-linux-workload`)
1. Start the lab:
   ```bash
   tld start lnx-optimize-linux-workload
   ```
2. Create directory `$HOME/mastery-perf`.
3. Apply cross-layer performance tuning (CPU affinity, sysctl vm/net parameters, block scheduler).
4. Write `LINUX_WORKLOAD_PERFORMANCE_MASTERED` into `$HOME/mastery-perf/perf_mastery.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
