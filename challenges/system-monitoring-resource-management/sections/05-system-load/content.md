# Section 05 — System Load

System load average represents the average number of threads in a **runnable** (`R`) or **uninterruptible sleep** (`D`) state over 1, 5, and 15-minute intervals.

## Load Average vs CPU Utilization

- **Runnable Threads (`R`)**: Tasks actively executing on CPU or queued waiting for a CPU core.
- **Uninterruptible Sleep Threads (`D`)**: Tasks waiting for disk I/O, network sockets, or hardware locks.

A system with 4 CPU cores and a load average of 12.0 means 8 threads are queued waiting for system resources. High load can occur with low CPU percentage if processes are blocked in uninterruptible disk I/O (`D` state).
