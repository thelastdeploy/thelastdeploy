# Kernel Observability & Tracing

Utilizing kernel tracing frameworks from userspace: tracefs (`/sys/kernel/tracing`), ftrace function graph tracer, tracepoints, and perf events.

Kernel observability tools enable continuous inspection of kernel function execution without modifying source code or stopping runtime workloads.

### Tracing Frameworks
- **ftrace**: Embedded kernel tracer accessible via `/sys/kernel/tracing/` (`available_tracers`, `trace`, `current_tracer`).
- **Tracepoints**: Static instrumentation points compiled into key kernel routines (`sched_switch`, `kmem_alloc`, `sys_enter_*`).
- **kprobes**: Dynamic probes attached to arbitrary kernel instructions.


---

## Lab Tasks

### Task 1: Trace Kernel System Behavior (`lnx-trace-kernel-system-behavior`)
1. Start the lab:
   ```bash
   tld start lnx-trace-kernel-system-behavior
   ```
2. Create directory `$HOME/kernel-tracing`.
3. Inspect `/sys/kernel/tracing/available_tracers` and `/sys/kernel/tracing/events/`.
4. Write `KERNEL_TRACEFS_AND_FTRACE_EVENTS_EXAMINED` into `$HOME/kernel-tracing/trace_analysis.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
