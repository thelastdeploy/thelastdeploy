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
1. Start the lab in your terminal:
   ```bash
   tld start nginx-safe-reload
   ```
   The configuration `/etc/nginx/sites-available/default` has been updated to listen on port `8085`, but the running daemon has not yet reloaded.
2. Verify that Nginx is not yet serving traffic on port `8085`:
   ```bash
   curl -I http://localhost:8085/ || echo "Port 8085 not active yet"
   ```
3. Test configuration syntax before reloading:
   ```bash
   sudo nginx -t
   ```
4. Reload the Nginx service gracefully without dropping connections:
   ```bash
   sudo systemctl reload nginx
   ```
5. Confirm that port `8085` is now actively responding:
   ```bash
   curl -I http://localhost:8085/
   ```
6. Verify the task:
   ```bash
   tld check
   ```
