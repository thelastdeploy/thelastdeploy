# CPU Scheduler Tuning & Affinity Optimization

Maximizing CPU throughput for latency-sensitive workloads requires reducing thread context switching, pinning critical threads to specific CPU cores, and optimizing NUMA node memory access.

---

## 1. CPU Affinity & Core Pinning (`taskset`)

By default, the Linux CFS (Completely Fair Scheduler) migrates threads across available CPU cores, causing cache invalidation and L1/L2/L3 cache misses. Pinning processes to specific CPU cores eliminates thread migration overhead:

```bash
# Bind process PID to CPU cores 0 and 1
taskset -p -c 0,1 <PID>

# Launch new process pinned to CPU cores 2 and 3
taskset -c 2,3 /usr/bin/high_perf_app
```

---

## 2. NUMA Node Locality (`numactl` & `numastat`)

Non-Uniform Memory Access (NUMA) systems have physical RAM associated directly with specific CPU sockets. Accessing remote NUMA memory incurs significant latency penalties:

```bash
# View NUMA node memory allocation statistics
numastat -c

# Execute process with strict local NUMA memory allocation
numactl --cpunodebind=0 --membind=0 /usr/bin/db_engine
```

---

## Summary

`taskset` CPU pinning and `numactl` memory locality reduce CPU context switching and remote NUMA interconnect latency.

---

## Lab Tasks

### Task 1: Analyze CPU Scheduler Contention (`lnx-analyze-cpu-contention`)
1. Start the lab:
   ```bash
   tld start lnx-analyze-cpu-contention
   ```
2. Create directory `$HOME/cpu-opt-test`.
3. Inspect CPU thread contention, context switching rates, and NUMA node statistics (`numastat`, `mpstat`).
4. Write output summary line `CPU_CONTENTION_ANALYZED` to `$HOME/cpu-opt-test/contention_analysis.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Optimize CPU-Bound Workload Execution (`lnx-optimize-cpu-bound-workload`)
1. Start the lab:
   ```bash
   tld start lnx-optimize-cpu-bound-workload
   ```
2. Create directory `$HOME/cpu-opt-test`.
3. Apply CPU core affinity masking (`taskset -c`) and NUMA policy tuning (`numactl`).
4. Write optimization report line `CPU_WORKLOAD_OPTIMIZED` to `$HOME/cpu-opt-test/cpu_optimization.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
