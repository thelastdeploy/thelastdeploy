# Section 03 — Memory

Linux memory management optimizes physical RAM utilization by using unallocated memory for file system caching (`buff/cache`).

## RAM & Swap Concepts

- **Available Memory**: The estimated memory available for starting new applications without swapping.
- **Buffers / Cache**: Memory reserved for disk I/O caching, which Linux automatically reclaims if applications require RAM.
- **Swap Space**: Secondary disk storage used when physical RAM fills up. Active swapping degrades I/O performance significantly.

## OOM Killer (Out Of Memory)

When available RAM and Swap are completely exhausted, the Linux kernel invokes the Out-Of-Memory (OOM) Killer daemon to terminate high-memory processes and prevent kernel panic crashes.
