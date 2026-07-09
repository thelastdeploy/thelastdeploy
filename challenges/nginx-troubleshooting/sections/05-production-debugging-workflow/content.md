## Production Debugging Workflow

When a production web server goes offline or begins throwing error codes, following a structured troubleshooting checklist helps locate the root cause quickly and minimizes downtime.

---

## 1. Step-by-Step Diagnostic Checklist

Follow this sequence of steps when diagnosing Nginx issues:

### Step 1: Check Nginx Configuration Syntax
Always run the syntax check first to catch basic typos, missing semicolons, or invalid directives:
```bash
sudo nginx -t
```

### Step 2: Check Nginx Service Status
Determine if the Nginx process is running, stopped, or failing to start:
```bash
sudo systemctl status nginx
```

### Step 3: Inspect the Error and Access Logs
Read the last few entries of the logs to identify request errors or startup failures:
```bash
# View last 50 lines of the error log
sudo tail -n 50 /var/log/nginx/error.log

# View last 50 lines of the access log
sudo tail -n 50 /var/log/nginx/access.log
```

### Step 4: Verify Backend Application Health
If Nginx is returning `502 Bad Gateway`, check if the backend application is listening on the expected ports:
```bash
sudo ss -tulpn
# or
sudo netstat -tulpn
```

---

## Complete the Section

Once you understand the debugging checklist, proceed to the final section to tackle a multi-error production outage scenario.
