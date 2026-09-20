# One-Time Task Scheduling with At

While `cron` is designed for recurring schedules, the `at` command schedules tasks to execute exactly once at a specified future time.

## 1. Scheduling One-Time Jobs (`at`)

Specify a natural-language time format:

```bash
# Schedule a job for 2:00 AM tomorrow
at 02:00 AM tomorrow -f /usr/local/bin/sync.sh

# Or pipe commands into at
echo "/usr/local/bin/sync.sh" | at now + 2 hours
```

## 2. Managing the `at` Queue

- `atq`: Lists pending queued jobs along with their job IDs and execution times.
  ```bash
  atq
  # Output: 4  Mon Sep 21 02:00:00 2026 a admin
  ```
- `atrm <job_id>`: Cancels and removes a pending job from the queue.
  ```bash
  atrm 4
  ```
