# Memory Management Internals

Deep dive into virtual memory allocation, page table structures, memory mappings, page faults, and slab memory allocation.

Linux memory management decouples application virtual address space from actual physical RAM pages through multi-level page tables and MMU hardware.

### Memory Concepts
- **VMA (Virtual Memory Areas)**: Represented in `/proc/[pid]/maps` and `/proc/[pid]/smaps`.
- **Page Faults**: Minor page faults (allocated page mapped in RAM without disk I/O) vs Major page faults (page fetched from disk storage/swap).
- **Kernel Slab Allocator**: `/proc/slabinfo` exposes kernel object pools (dentry, inode_cache, kmalloc-*).


---

## Lab Tasks

### Task 1: Investigate Virtual Memory Mappings (`lnx-investigate-virtual-memory`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-virtual-memory
   ```
2. Create directory `$HOME/mem-internals`.
3. Inspect `/proc/self/maps` and `/proc/self/smaps`.
4. Write `VIRTUAL_MEMORY_ADDRESS_MAPPINGS_ANALYZED` into `$HOME/mem-internals/vma_analysis.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Trace Memory Management & Page Faults (`lnx-trace-memory-management`)
1. Start the lab:
   ```bash
   tld start lnx-trace-memory-management
   ```
2. Inspect `/proc/vmstat` and `/proc/slabinfo`.
3. Observe page fault counter increments during memory allocation.
4. Write `PAGE_FAULTS_AND_SLAB_ALLOCATOR_TRACED` into `$HOME/mem-internals/page_fault_slab.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
