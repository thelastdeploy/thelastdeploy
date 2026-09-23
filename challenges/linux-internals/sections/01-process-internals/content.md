# Process Task Structures & /proc Abstraction

In the Linux kernel, every process is represented internally by a `task_struct` C data structure. The kernel exposes these process data structures to user space via the pseudo-filesystem `/proc`.

---

## 1. The `/proc/<pid>/` Architecture

The `/proc` directory is a virtual filesystem generated dynamically by the Linux kernel. Each running process has a corresponding numeric directory `/proc/<pid>/` containing detailed runtime state:

| Subpath | Purpose & Content |
| :--- | :--- |
| `/proc/<pid>/status` | Human-readable process state, UID/GID, thread count, and memory totals |
| `/proc/<pid>/cmdline` | Command line invocation arguments (null-byte separated) |
| `/proc/<pid>/environ` | Environment variables exported to the process |
| `/proc/<pid>/fd/` | Directory of open file descriptor symbolic links |
| `/proc/<pid>/cwd` | Symbolic link pointing to current working directory |
| `/proc/<pid>/exe` | Symbolic link pointing to executable binary |

---

## 2. Process Execution Lifecycle & States

Process state transitions inside `task_struct`:

```text
+--------------+     (fork/exec)     +--------------+     (sleep)     +--------------------------+
| TASK_RUNNING |  -----------------> | TASK_RUNNING | --------------> | TASK_INTERRUPTIBLE (S)   |
| (Ready)      | <------------------ | (Executing)  | <-------------- | TASK_UNINTERRUPTIBLE (D) |
+--------------+   (scheduler dispatch) +--------------+   (event wake) +--------------------------+
                                            |
                                            | (exit)
                                            v
                                  +-------------------+
                                  | EXIT_ZOMBIE (Z)   |
                                  | (Awaiting waitpid)|
                                  +-------------------+
```

- **`R` (TASK_RUNNING)**: Executing on CPU or waiting in scheduler run queue.
- **`S` (TASK_INTERRUPTIBLE)**: Sleeping, waiting for event/signal.
- **`D` (TASK_UNINTERRUPTIBLE)**: Sleeping, waiting for I/O (cannot be interrupted by signals).
- **`Z` (EXIT_ZOMBIE)**: Process terminated, entry retained in process table awaiting parent `waitpid()`.

---

## Summary

The `/proc` pseudo-filesystem exposes kernel `task_struct` data directly to userspace diagnostic tools.

---

## Lab Tasks

### Task 1: Inspect Process Task Internals in /proc (`lnx-inspect-process-internals`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-process-internals
   ```
2. Create directory `$HOME/proc-internals-test`.
3. Inspect process state and file descriptors in `/proc/self/` or `/proc/1/`.
4. Write output summary line `PROCESS_INTERNALS_INSPECTED` to `$HOME/proc-internals-test/proc_info.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Trace Process Execution Lifecycle (`lnx-trace-process-lifecycle`)
1. Start the lab:
   ```bash
   tld start lnx-trace-process-lifecycle
   ```
2. Create directory `$HOME/proc-internals-test`.
3. Trace process parent-child hierarchy and lifecycle states (`pstree` or `ps -ef`).
4. Write summary line `PROCESS_LIFECYCLE_TRACED` to `$HOME/proc-internals-test/lifecycle.txt`.
5. Validate your solution:
   ```bash
   tld check
   ```
