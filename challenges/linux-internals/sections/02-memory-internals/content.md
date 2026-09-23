# Virtual Memory Architecture & Page Mappings

Linux processes operate inside isolated virtual address spaces managed by the kernel's Memory Management Unit (MMU). Virtual memory maps process address spaces to physical RAM pages or storage blocks using page tables.

---

## 1. Process Virtual Memory Layout

A standard process virtual address space is organized into memory segments:

```text
High Memory   +--------------------------+
              | Kernel Memory Space      | (Protected)
              +--------------------------+
              | Stack Segment            | Grows downward (local variables, call frames)
              |        |                 |
              |        v                 |
              |        ^                 |
              |        |                 |
              | Heap Segment             | Grows upward (malloc / dynamic allocations)
              +--------------------------+
              | BSS & Data Segments      | Global & static variables
              +--------------------------+
              | Text (Code) Segment      | Read-only executable machine instructions
Low Memory    +--------------------------+
```

---

## 2. Memory Mappings (`/proc/<pid>/maps` & `pmap`)

```bash
# View memory segment mappings of current shell process
cat /proc/self/maps

# Display process memory map summary
pmap -x $$
```

Mapping types:
- **File-backed mappings**: Executables (`.so` shared libraries) mapped directly from storage into RAM.
- **Anonymous mappings**: Memory allocated dynamically by `malloc()` / `mmap()` (heap, stack, buffers) not backed by a file path.

---

## Summary

`/proc/<pid>/maps` and `pmap` reveal how virtual memory segments (text, data, heap, stack) map to physical memory.

---

## Lab Tasks

### Task 1: Inspect Process Memory Layout (`lnx-inspect-process-memory`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-process-memory
   ```
2. Create directory `$HOME/mem-internals-test`.
3. Inspect process memory layout using `/proc/self/maps` or `pmap -x $$`.
4. Write output line `PROCESS_MEMORY_LAYOUT_INSPECTED` to `$HOME/mem-internals-test/memory_layout.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Investigate Shared Memory and Anonymous Mappings (`lnx-investigate-memory-mapping`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-memory-mapping
   ```
2. Create directory `$HOME/mem-internals-test`.
3. Inspect detailed memory mappings in `/proc/self/smaps`.
4. Write summary output `SMAPS_MAPPINGS_INVESTIGATED` to `$HOME/mem-internals-test/smaps_summary.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
