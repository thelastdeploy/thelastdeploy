## Reading Error Logs

When Nginx fails to start, reload, or serve a request properly, it writes the diagnostic details to the **error log**, usually located at `/var/log/nginx/error.log`.

---

## 1. Log Severity Levels

Nginx supports several log levels, ordered from most severe to least severe:
1. **`emerg`**: Emergency; system is unstable/unusable.
2. **`alert`**: Alert; action must be taken immediately.
3. **`crit`**: Critical conditions.
4. **`error`**: Error conditions (e.g. failed to open a static file).
5. **`warn`**: Warning conditions.
6. **`notice`**: Normal but significant situations.
7. **`info`**: Informational messages.
8. **`debug`**: Debug-level messages (requires compiling Nginx with `--with-debug`).

---

## 2. Common Startup Errors: Port Bind Failure

If another service (or a lingering Nginx master process) is already listening on the same port Nginx is configured to use, Nginx will fail to start:

```text
2026/07/10 22:15:30 [emerg] 1234#1234: bind() to 0.0.0.0:9999 failed (98: Address already in use)
```

In this case, you must identify what is running on that port:
- Check active listening ports:
  ```bash
  sudo netstat -tulpn | grep 9999
  # or
  sudo ss -tulpn | grep 9999
  ```

---

## Lab Tasks

### Task 1: Identify Port Bind Failure
1. Start the lab:
   ```bash
   tld start nginx-identify-startup-error
   ```
2. Search the Nginx error log file `/var/log/nginx/error.log` to find the recent startup failure where Nginx couldn't bind to a socket address.
3. Find the port number that was already in use and write just the port number (e.g. `9999`) to `/tmp/failed_port.txt`.
4. Verify the task:
   ```bash
   tld check
   ```
