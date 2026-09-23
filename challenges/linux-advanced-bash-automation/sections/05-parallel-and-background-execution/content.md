# Parallel Processing & Background Execution

Executing independent tasks in parallel reduces execution time for heavy batch operations. Bash provides job control primitives (`&`, `wait`, `jobs`) to orchestrate asynchronous tasks while regulating system resource consumption.

---

## 1. Asynchronous Background Execution (`&` and `wait`)

Appending `&` to a command executes it asynchronously in the background. `wait` halts execution until child background processes complete:

```bash
# Launch background jobs
task1.sh &
PID1=$!

task2.sh &
PID2=$!

# Wait for specific PIDs or all child processes
wait $PID1 $PID2
echo "Both background tasks finished."
```

---

## 2. Throttling Parallel Concurrency

To prevent system resource exhaustion, limit the number of concurrent processes using process counters or `xargs`:

```bash
MAX_JOBS=4
for file in *.data; do
    process_file "$file" &
    
    # Throttle if background job count reaches limit
    while [ $(jobs -r -p | wc -l) -ge $MAX_JOBS ]; do
        sleep 1
    done
done
wait
```

---

## Summary

Job control with `wait` and concurrency limits allows automation scripts to process bulk workloads safely and efficiently.

---

## Lab Tasks

### Task 1: Manage Background Tasks (`lnx-manage-background-tasks`)
1. Start the lab:
   ```bash
   tld start lnx-manage-background-tasks
   ```
2. Create directory `$HOME/bg-test`.
3. Write executable script `$HOME/bg-test/bg_runner.sh`.
4. Script requirements:
5. - Launch 3 background tasks writing `task1`, `task2`, `task3` into `$HOME/bg-test/t1.txt`, `t2.txt`, `t3.txt`.
6. - Call `wait` to block until all tasks complete.
7. - Write `ALL_JOBS_DONE` into `$HOME/bg-test/jobs_complete.txt` after `wait` returns.
8. Execute `$HOME/bg-test/bg_runner.sh`.
9. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Run Parallel Automation Tasks (`lnx-run-parallel-automation`)
1. Start the lab:
   ```bash
   tld start lnx-run-parallel-automation
   ```
2. Create `$HOME/parallel-test/data/` with 5 text files `f1.txt` ... `f5.txt` containing lowercase text `sample data X`.
3. Write `$HOME/parallel-test/batch_processor.sh` to process all files in `$HOME/parallel-test/data/` in parallel, converting text to uppercase and saving outputs in `$HOME/parallel-test/results/`.
4. Execute `$HOME/parallel-test/batch_processor.sh`.
5. Validate your solution:
   ```bash
   tld check
   ```
