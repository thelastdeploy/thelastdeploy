# Scheduled Task Fundamentals

Cron is the background service daemon (`crond`) in Linux responsible for executing commands or scripts on a pre-defined recurring time schedule.

## 1. The 5-Field Cron Syntax

A standard cron expression consists of 5 time fields followed by the command to execute:

```
.---------------- minute (0 - 59)
|  .------------- hour (0 - 23)
|  |  .---------- day of month (1 - 31)
|  |  |  .------- month (1 - 12)
|  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7)
|  |  |  |  |
*  *  *  *  * command to execute
```

## 2. Cron Time Operators

- `*`: Matches every value in the field (e.g. `*` in minute field means every minute).
- `,`: Specifies a list of values (e.g., `1,15,30` in minute field).
- `-`: Specifies a range of values (e.g., `1-5` in day of week field for Monday through Friday).
- `*/n`: Specifies step values (e.g., `*/10` in minute field for every 10 minutes).

## 3. Common Examples

- `30 2 * * *`: Run at 02:30 AM every day.
- `0 0 * * 0`: Run at midnight every Sunday.
- `*/15 * * * *`: Run every 15 minutes.
