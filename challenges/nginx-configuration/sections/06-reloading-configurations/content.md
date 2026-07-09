## Reloading Configurations

One of the greatest features of Nginx is its ability to apply configuration changes without interrupting active client connections. This is called a **graceful reload**.

---

## 1. Reload vs Restart

- **Restart** (`systemctl restart nginx`): Stops the master and all worker processes, dropping all current connections, and starts them again. This causes brief downtime.
- **Reload** (`systemctl reload nginx` or `nginx -s reload`): 
  1. The Nginx master process validates the new configuration.
  2. If valid, the master process spawns new worker processes with the updated configuration.
  3. The master signals old worker processes to stop accepting new connections and gracefully shut down once they finish processing their current requests.
  4. This results in zero downtime and zero dropped connections.

---

## 2. Best Practice

Always test the configuration before triggering a reload:
```bash
sudo nginx -t && sudo systemctl reload nginx
```

---

## Lab Tasks

### Task 1: Perform a safe reload
1. Start the lab:
   ```bash
   tld start nginx-safe-reload
   ```
2. The seed script has modified the default site configuration file to listen on port `8085` instead of port `80`, but the service has not been reloaded to apply the changes yet.
3. Verify that Nginx is NOT yet listening on port 8085 (e.g. `curl http://localhost:8085/` fails).
4. Run the reload commands to safely apply the changes.
5. Verify the task passes when port 8085 is successfully responding.
6. Verify the task:
   ```bash
   tld check
   ```
