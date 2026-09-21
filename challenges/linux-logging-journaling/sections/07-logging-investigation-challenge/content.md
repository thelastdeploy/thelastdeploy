# Production Incident Logging Investigation Capstone

An un-documented production outage occurred during the night. The infrastructure team restored service, but no incident post-mortem report was created.

## Your Mission

Analyze system logs, journal logs, and application crash reports in `$HOME/incident-investigation/logs/` to reconstruct the timeline and determine the root cause.

## Required Output File

Create an incident post-mortem report file at `$HOME/incident-investigation/incident_report.txt` containing the following fields:

1. `INCIDENT_TIMESTAMP: <timestamp>` — Exact timestamp of the service failure event.
2. `FAILED_SERVICE: <service_name>` — Name of the systemd service unit that failed (e.g. `order-api.service`).
3. `ROOT_CAUSE: <cause>` — Evidence pointing to the root cause (e.g. `OUT_OF_MEMORY`).

---

## Lab Tasks

### Task 1: Trace Production Incident via Log Correlation (`lnx-trace-production-incident`)
1. Start the lab:
   ```bash
   tld start lnx-trace-production-incident
   ```
2. Complete the logging and investigation capstone challenge.
3. Correlate system events and write an incident report to `$HOME/incident-investigation/incident_report.txt` containing `FAILED_SERVICE: order-api.service` and `ROOT_CAUSE: OUT_OF_MEMORY`.
4. Validate your solution:
   ```bash
   tld check
   ```
