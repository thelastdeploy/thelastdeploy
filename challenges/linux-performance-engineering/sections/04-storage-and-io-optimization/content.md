# Storage I/O Scheduler & Queue Depth Tuning

Block device performance depends heavily on matching the appropriate Linux multi-queue I/O scheduler (`none`, `mq-deadline`, `kyber`, `bfq`), block read-ahead size, and disk queue depths to the physical storage hardware (NVMe vs SSD vs HDD).

---

## 1. Multi-Queue Block I/O Schedulers (`blk-mq`)

Modern Linux kernels use multi-queue block layer architecture (`/sys/block/<dev>/queue/scheduler`):

- **`none`**: Bypasses I/O scheduler queues. Recommended for high-performance NVMe SSDs where hardware handles hardware queue scheduling.
- **`mq-deadline`**: Guarantees read/write latency bounds. Recommended for standard SATA/SAS SSDs and general database workloads.
- **`kyber`**: Latency-targeted scheduler for fast storage devices.
- **`bfq`**: Budget Fair Queueing. Recommended for slow mechanical HDDs and desktop workloads.

```bash
# View current scheduler for device sda
cat /sys/block/sda/queue/scheduler

# Set I/O scheduler to mq-deadline
echo "mq-deadline" > /sys/block/sda/queue/scheduler
```

---

## 2. Block Read-Ahead & Queue Depth Tuning

```bash
# Inspect and set block read-ahead sectors (4096 sectors = 2MB)
blockdev --setra 4096 /dev/sda

# View nr_requests queue depth
cat /sys/block/sda/queue/nr_requests
```

---

## Summary

Setting block scheduler to `none` (for NVMe) or `mq-deadline` (for SATA SSDs) optimizes block device I/O throughput.

---

## Lab Tasks

### Task 1: Analyze Storage I/O Workload Patterns (`lnx-analyze-io-workload`)
1. Start the lab:
   ```bash
   tld start lnx-analyze-io-workload
   ```
2. Create directory `$HOME/io-opt-test`.
3. Analyze storage I/O workload patterns (sequential vs random, block sizes, queue depth).
4. Write output summary line `STORAGE_IO_WORKLOAD_ANALYZED` to `$HOME/io-opt-test/io_profile.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Optimize Storage I/O Performance (`lnx-optimize-storage-performance`)
1. Start the lab:
   ```bash
   tld start lnx-optimize-storage-performance
   ```
2. Create directory `$HOME/io-opt-test`.
3. Configure block device I/O scheduler (`mq-deadline`/`none`) and read-ahead parameters.
4. Write output summary line `STORAGE_IO_PERFORMANCE_OPTIMIZED` to `$HOME/io-opt-test/io_tuning.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
