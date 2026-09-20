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
