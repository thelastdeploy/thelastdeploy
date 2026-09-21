# Remote System Inspection

System administrators frequently inspect remote server health, load metrics, memory utilization, and running processes over SSH.

## 1. Remote Metrics Gathering

Execute standard Linux monitoring tools over SSH:

```bash
# Check remote system load and uptime
ssh admin@web-server "uptime"

# Inspect remote memory usage
ssh admin@web-server "free -m"

# Audit root filesystem disk space
ssh admin@web-server "df -h /"

# View active systemd services
ssh admin@web-server "systemctl list-units --type=service --state=running"
```

## 2. Archiving Remote Audits Locally

Redirect remote command outputs directly into local report files:

```bash
ssh admin@web-server "uname -a; uptime; df -h" > ./audit_results.txt
```

---

## Lab Tasks

### Task 1: Inspect Remote Server Health and Generate Reports (`lnx-inspect-remote-server`)
1. Start the lab:
   ```bash
   tld start lnx-inspect-remote-server
   ```
2. Perform the required system administration task for `Inspect Remote Server Health and Generate Reports`.
3. Save the resulting verification output or file to the designated lab workspace directory.
4. Validate your solution:
   ```bash
   tld check
   ```
