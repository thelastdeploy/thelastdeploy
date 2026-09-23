# Storage I/O Bottlenecks & Disk Latency

Storage I/O bottlenecks occur when application read/write requests saturate block device queue depths, causing processes to block in uninterruptible kernel sleep (`D` state).

---

## 1. Measuring Storage I/O with `iostat`

`iostat` provides detailed block device throughput and latency metrics:

```bash
# Display extended I/O statistics every 1 second (omit idle devices)
iostat -xz 1 5
```

Key `iostat` metrics:
- **`r/s` & `w/s`**: Read and write requests completed per second (IOPS).
- **`rkB/s` & `wkB/s`**: Read and write throughput in KB/s.
- **`await`**: Average time (in milliseconds) for I/O requests issued to device to be served (queue wait + disk service time).
- **`%util`**: Percentage of CPU time during which I/O requests were issued to device (device saturation).

---

## 2. Isolating Offending I/O Processes (`pidstat -d`)

Once storage saturation is detected via `iostat`, isolate the responsible process PIDs:

```bash
# Monitor per-process disk read/write rates
pidstat -d 1 5
```

---

## Summary

High `await` and `%util` in `iostat -xz` identify disk saturation, while `pidstat -d` identifies offending I/O processes.

---

## Lab Tasks

### Task 1: Analyze Disk I/O Utilization and Latency (`lnx-analyze-disk-io`)
1. Start the lab:
   ```bash
   tld start lnx-analyze-disk-io
   ```
2. Create directory `$HOME/io-perf-test`.
3. Inspect storage device throughput (`IOPS`), latency (`await`), and utilization (`%util`) using `iostat -xz 1`.
4. Write output summary line `DISK_IO_ANALYZED` to `$HOME/io-perf-test/io_analysis.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Trace Process Storage I/O Bottleneck (`lnx-trace-storage-bottleneck`)
1. Start the lab:
   ```bash
   tld start lnx-trace-storage-bottleneck
   ```
2. Create directory `$HOME/io-perf-test`.
3. Trace process disk read/write throughput using `pidstat -d`.
4. Write output line `OFFENDING_IO_PROCESS_TRACED` to `$HOME/io-perf-test/io_pid.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
