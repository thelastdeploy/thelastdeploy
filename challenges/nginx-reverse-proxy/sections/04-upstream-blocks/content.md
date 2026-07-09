## Load Balancing with Upstream Blocks

When you need to distribute requests across multiple backend application servers to handle high traffic and ensure high availability, Nginx uses **upstream** blocks.

---

## 1. Defining an Upstream Group

An `upstream` block groups multiple backend endpoints under a single alias. It resides inside the `http` context:

```nginx
upstream my_app_pool {
    server 127.0.0.1:8001;
    server 127.0.0.1:8002;
    server 127.0.0.1:8003 backup;
}
```

- **`backup`**: The server is marked as a backup and will only receive traffic if the primary servers are down.

---

## 2. Using Upstreams in proxy_pass

Once defined, pass the upstream alias name directly as the protocol address target of `proxy_pass`:

```nginx
server {
    listen 80;
    location / {
        proxy_pass http://my_app_pool;
    }
}
```

---

## 3. Load Balancing Algorithms

Nginx supports several load balancing algorithms, configured inside the upstream block:
- **Round Robin** (Default): Requests are distributed sequentially.
- **Least Connections** (`least_conn;`): Directs requests to the server with the fewest active connections.
- **IP Hash** (`ip_hash;`): Uses the client's IP address to determine which server receives the request, ensuring session persistence (the client always lands on the same backend).

---

## Lab Tasks

### Task 1: Create an Upstream group
1. Start the lab:
   ```bash
   tld start nginx-create-upstream
   ```
2. Create an upstream block named `backend_servers` in the `http` block of `/etc/nginx/nginx.conf` (or inside `/etc/nginx/conf.d/upstream.conf`).
3. Add two backend servers: `127.0.0.1:8001` and `127.0.0.1:8002`.
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Load balance requests
1. Start the lab:
   ```bash
   tld start nginx-load-balance-two-backends
   ```
2. Configure a location block `/app` in `/etc/nginx/sites-available/default` that load balances requests to the `backend_servers` upstream pool.
3. Reload Nginx.
4. Verify the task:
   ```bash
   tld check
   ```
