# Memory Pressure & Swap Thrashing

Linux uses available RAM dynamically for page caching to accelerate storage access. Distinguishing between healthy page cache usage and active memory exhaustion prevents false alarms.

---

## 1. Differentiating Cache vs Application Memory

```bash
# View detailed memory allocation
free -m
```

- **total**: Total installed physical RAM.
- **used**: Memory allocated to processes plus active kernel structures.
- **buff/cache**: Memory used by OS for file page caching (reclaimable under memory pressure).
- **available**: Estimated RAM available for starting new applications without swapping.

---

## 2. Detecting Swap Thrashing (`vmstat`)

When physical RAM is exhausted, the Linux kernel moves idle memory pages to swap space. Active swap thrashing severely degrades performance:

```bash
# Monitor swap-in (si) and swap-out (so) rates per second
vmstat 1 5
```

- **`si` (Swap-In)**: Memory paged from swap disk back into RAM per second.
- **`so` (Swap-Out)**: Memory paged from RAM to swap disk per second.

Continuous non-zero `si` and `so` values indicate severe memory pressure and swap thrashing.

---

## Summary

`free -m` shows available memory, while non-zero `si`/`so` in `vmstat 1` signals active swap thrashing.

---

## Lab Tasks

### Task 1: Analyze Memory Pressure and Page Cache (`lnx-analyze-memory-pressure`)
1. Start the lab:
   ```bash
   tld start lnx-analyze-memory-pressure
   ```
2. Create directory `$HOME/mem-perf-test`.
3. Inspect available RAM and page cache allocations (`free -m` and `/proc/meminfo`).
4. Write summary line `MEMORY_PRESSURE_ANALYZED` to `$HOME/mem-perf-test/mem_report.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Investigate Swap Activity and Page Faults (`lnx-investigate-swap-activity`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-swap-activity
   ```
2. Create directory `$HOME/mem-perf-test`.
3. Inspect swap-in (`si`) and swap-out (`so`) statistics using `vmstat 1`.
4. Write output summary line `SWAP_ACTIVITY_INVESTIGATED` to `$HOME/mem-perf-test/swap_report.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
