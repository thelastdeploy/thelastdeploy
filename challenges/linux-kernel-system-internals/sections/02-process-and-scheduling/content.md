# Process and Scheduling Internals

Investigating process creation (`fork`/`exec`), state machine transitions, and CPU scheduler metrics.

In Linux, every task is represented internally by a `struct task_struct`. The Completely Fair Scheduler (CFS) or EEVDF (Earliest Eligible Virtual Deadline First) manages CPU execution time using virtual runtime (`vruntime`).

### Task States & Scheduling Metrics
- **States**: `TASK_RUNNING` (R), `TASK_INTERRUPTIBLE` (S), `TASK_UNINTERRUPTIBLE` (D), `TASK_STOPPED` (T), `TASK_ZOMBIE` (Z).
- **Scheduler files**: `/proc/[pid]/sched`, `/proc/sched_debug`, `/proc/schedstat`.

Observing context switches (`voluntary_ctxt_switches` vs `nonvoluntary_ctxt_switches`) and scheduling latency provides deep visibility into application execution under load.


---

## Lab Tasks

### Task 1: Investigate Process Scheduling (`lnx-investigate-process-scheduling`)
1. Start the lab:
   ```bash
   tld start lnx-investigate-process-scheduling
   ```
2. Create directory `$HOME/proc-sched`.
3. Inspect `/proc/self/sched` and `/proc/schedstat`.
4. Log `PROCESS_SCHEDULER_VRUNTIME_EXAMINED` into `$HOME/proc-sched/sched_investigation.log`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Trace Process State Changes (`lnx-trace-process-state-changes`)
1. Start the lab:
   ```bash
   tld start lnx-trace-process-state-changes
   ```
2. Observe process state changes in `/proc/[pid]/status` during process lifecycle events.
3. Analyze voluntary vs non-voluntary context switches.
4. Write `PROCESS_STATE_MACHINE_TRANSITIONS_TRACED` into `$HOME/proc-sched/state_trace.log`.
5. Validate your solution:
   ```bash
   tld check
   ```
