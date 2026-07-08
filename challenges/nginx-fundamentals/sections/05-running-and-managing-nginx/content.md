## Running and Managing Nginx

Once Nginx is installed, you need to know how to start, stop, restart, reload, and verify the status of the Nginx service.

---

## 1. Controlling Nginx with Systemd

On modern Linux systems, Nginx is managed via `systemd`. You can control it using the `systemctl` command:

- **Start Nginx**:
  ```bash
  sudo systemctl start nginx
  ```
- **Stop Nginx**:
  ```bash
  sudo systemctl stop nginx
  ```
- **Restart Nginx**: (Tears down all processes and starts them again. Useful for major changes, but causes brief downtime.)
  ```bash
  sudo systemctl restart nginx
  ```
- **Reload Nginx**: (Re-reads configuration without dropping active connections. Zero-downtime, recommended for configuration updates.)
  ```bash
  sudo systemctl reload nginx
  ```
- **Check Status**:
  ```bash
  sudo systemctl status nginx
  ```

---

## 2. Using the `nginx` CLI Directly

You can also interact with the Nginx binary directly. Some of the most common commands include:

- **Test Configuration**: (Highly recommended before reloading or restarting, to catch syntax errors.)
  ```bash
  sudo nginx -t
  ```
- **Show Version Info**:
  ```bash
  nginx -v
  ```
- **Signal Control**:
  ```bash
  sudo nginx -s reload   # Reload configuration
  sudo nginx -s stop     # Fast shutdown
  sudo nginx -s quit     # Graceful shutdown (wait for workers to finish active requests)
  ```

---

## Lab Tasks

### Task 1: Start Nginx Service
1. Start the lab:
   ```bash
   tld start nginx-start-service
   ```
2. Make sure the Nginx service is running on your system.
3. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Stop Nginx Service
1. Start the lab:
   ```bash
   tld start nginx-stop-service
   ```
2. Stop the running Nginx service on your system.
3. Verify the task:
   ```bash
   tld check
   ```

### Task 3: Reload Nginx Service
1. Start the lab:
   ```bash
   tld start nginx-reload-service
   ```
2. Reload Nginx configuration cleanly.
3. Verify the task:
   ```bash
   tld check
   ```
