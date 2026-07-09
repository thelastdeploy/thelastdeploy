## Production Tuning & Optimization

For a high-traffic production web server, you must optimize CPU cores usage, active socket limits, and client connection lifetimes. Sub-optimal configuration settings can cause connection timeouts and restrict Nginx from scaling.

---

## 1. Worker Processes & Core Scaling

By default, Nginx handles connections inside worker processes. In production, you should run exactly **one worker process per CPU core**:

```nginx
# Auto-scales worker processes to match available CPU cores
worker_processes auto;
```

---

## 2. Worker Connections

The `worker_connections` directive sets the maximum number of simultaneous connections that a worker process can open:

```nginx
events {
    # Allows each worker process to handle up to 1024 simultaneous connections
    worker_connections 1024;
}
```

The maximum concurrent connections capacity is calculated as:
$$\text{Max Clients} = \text{worker\_processes} \times \text{worker\_connections}$$

---

## 3. Keepalive Timeout

The `keepalive_timeout` directive controls how long a keepalive connection with the client stays open on the server side:

```nginx
# Closes keep-alive connections after 65 seconds of inactivity
keepalive_timeout 65;
```

If set too long (e.g. `300s`), idle connections remain open, locking up resources and blocking new clients.

---

## Lab Tasks

### Task 1: Tune production configuration
1. Start the lab:
   ```bash
   tld start nginx-optimize-production-config
   ```
2. The seed script has modified `/etc/nginx/nginx.conf` to use a sub-optimal setup:
   - `worker_processes 1;` (limits CPU core usage to one core).
   - `keepalive_timeout 300;` (locks up sockets on idle connections).
3. Modify `/etc/nginx/nginx.conf` to optimize these parameters:
   - Configure `worker_processes` to scale automatically (`auto`).
   - Reduce the `keepalive_timeout` to `65` seconds.
4. Reload Nginx.
5. Verify the task:
   ```bash
   tld check
   ```
