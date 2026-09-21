# Section 04 — Storage & I/O

Disk throughput and read/write operations per second (IOPS) dictate system responsiveness under database or log-heavy workloads.

## Storage Performance Diagnostics

- `iostat -xz 1 5`: Display extended I/O statistics per device including read/write rates (`kB_read/s`, `kB_wrtn/s`), average request wait time (`await`), and disk utilization percentage (`%util`).
- `iotop -o`: Real-time I/O monitor filtering only processes actively performing disk reads/writes.
- `pidstat -d 1 5`: Display per-process disk read/write bytes per second.

## Key Performance Indicators

- **`await`**: Average time in milliseconds for I/O requests to be serviced. High `await` (>20ms) signals storage bottlenecks.
- **`%util`**: Percentage of CPU time during which I/O requests were issued to the device. High `%util` approaching 100% indicates saturation.
