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
2. Create directory `$HOME/bg-test`:
   ```bash
   mkdir -p ~/bg-test
   ```
3. Create the script `$HOME/bg-test/bg_runner.sh`:
   ```bash
   cat << 'EOF' > ~/bg-test/bg_runner.sh
   #!/bin/bash
   set -euo pipefail

   echo "task1" > ~/bg-test/t1.txt &
   echo "task2" > ~/bg-test/t2.txt &
   echo "task3" > ~/bg-test/t3.txt &

   wait

   echo "ALL_JOBS_DONE" > ~/bg-test/jobs_complete.txt
   EOF
   chmod +x ~/bg-test/bg_runner.sh
   ```
4. Execute the script:
   ```bash
   ~/bg-test/bg_runner.sh
   cat ~/bg-test/jobs_complete.txt
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Run Parallel Automation Tasks (`lnx-run-parallel-automation`)
1. Start the lab:
   ```bash
   tld start lnx-run-parallel-automation
   ```
2. Create directories and seed sample data:
   ```bash
   mkdir -p ~/parallel-test/data ~/parallel-test/results
   for i in {1..5}; do
       echo "sample data $i" > ~/parallel-test/data/f$i.txt
   done
   ```
3. Create `$HOME/parallel-test/batch_processor.sh` to process files in parallel:
   ```bash
   cat << 'EOF' > ~/parallel-test/batch_processor.sh
   #!/bin/bash
   set -euo pipefail

   for file in ~/parallel-test/data/*.txt; do
       filename=$(basename "$file")
       tr '[:lower:]' '[:upper:]' < "$file" > ~/parallel-test/results/"$filename" &
   done

   wait
   EOF
   chmod +x ~/parallel-test/batch_processor.sh
   ```
4. Execute the batch processor:
   ```bash
   ~/parallel-test/batch_processor.sh
   cat ~/parallel-test/results/f1.txt
   ```
5. Validate your solution:
   ```bash
   tld check
   ```

