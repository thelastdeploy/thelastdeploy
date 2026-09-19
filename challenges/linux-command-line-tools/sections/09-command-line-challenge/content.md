## Command Line Investigation Challenge

### Outage Incident Scenario
An automated monitoring system has detected an application outage caused by a distributed rate-limit abuse attack. High volume POST requests targeting `/api/v1/auth` are crashing the login microservice.

Your task is to analyze multi-part log archives in `$HOME/cli-challenge/logs/`, construct a multi-stage CLI pipeline (`grep`, `awk`, `sort`, `uniq`, `head`), and identify the single rogue IP address responsible for the highest number of failed authentication requests.

---

## Lab Tasks

### Task 1: Solve CLI Investigation (`lnx-solve-cli-investigation`)
1. Start the lab:
   ```bash
   tld start lnx-solve-cli-investigation
   ```
2. Navigate to `$HOME/cli-challenge/logs`.
3. Process all `.log` files in the directory to find lines matching `/api/v1/auth`.
4. Extract the IP address (column 1), count request frequencies per IP, and determine the top offender IP address.
5. Save the top offender IP address (e.g. `203.0.113.199`) into `$HOME/cli-challenge/root_cause_ip.txt`.
6. Validate your solution:
   ```bash
   tld check
   ```
