# Memory Allocator & Kernel Page Cache Tuning

Optimizing kernel virtual memory (`vm.*`) parameters balances page cache retention against background dirty page writeback, preventing sudden storage I/O stalls during heavy write workloads.

---

## 1. Key Kernel Virtual Memory (`vm.*`) Parameters

| sysctl Parameter | Default / Typical | Purpose & Optimization Strategy |
| :--- | :--- | :--- |
| `vm.swappiness` | `60` | Tendency to reclaim swap vs page cache. Lower to `10` or `1` for databases to prevent swapping. |
| `vm.dirty_background_ratio` | `10` | Percentage of memory where pdflush/flush threads begin background dirty page writeback. |
| `vm.dirty_ratio` | `20` | Percentage of memory where processes issuing writes block while flushing dirty pages to storage. |
| `vm.vfs_cache_pressure` | `100` | Tendency to reclaim directory entry (dentry) and inode caches. Lower to `50` to retain file metadata. |

---

## 2. Tuning Dirty Page Writeback for Write-Heavy Workloads

```bash
# Apply smooth dirty page writeback settings in /etc/sysctl.d/99-memory-tuning.conf
vm.swappiness = 10
vm.dirty_background_ratio = 5
vm.dirty_ratio = 15
vm.vfs_cache_pressure = 50

# Apply changes without rebooting
sysctl -p /etc/sysctl.d/99-memory-tuning.conf
```

---

## Summary

Tuning `vm.swappiness` and dirty page ratios (`vm.dirty_background_ratio`/`vm.dirty_ratio`) prevents application write stalls.

---

## Lab Tasks

### Task 1: Analyze Kernel Memory Allocator Behavior (`lnx-analyze-memory-behavior`)
1. Start the lab:
   ```bash
   tld start lnx-analyze-memory-behavior
   ```
2. Create directory `$HOME/mem-opt-test`.
3. Inspect dirty page writeback ratios, swap tendency, and VFS cache pressure (`/proc/sys/vm/`).
4. Write output summary line `MEMORY_BEHAVIOR_ANALYZED` to `$HOME/mem-opt-test/mem_behavior.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Optimize Memory Subsystem Tuneables (`lnx-optimize-memory-pressure`)
1. Start the lab:
   ```bash
   tld start lnx-optimize-memory-pressure
   ```
2. Create directory `$HOME/mem-opt-test`.
3. Tune kernel memory sysctl parameters (`vm.swappiness`, `vm.dirty_background_ratio`, `vm.dirty_ratio`).
4. Write output line `MEMORY_SUBSYSTEM_OPTIMIZED` to `$HOME/mem-opt-test/mem_tuning.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
