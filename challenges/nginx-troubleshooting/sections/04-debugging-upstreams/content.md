## Debugging Upstreams

When Nginx routes requests to a group of backend servers defined inside an `upstream` block, additional layers of failure can occur.

---

## 1. Upstream Server Group

Consider the following configuration:

```nginx
upstream app_servers {
    server 127.0.0.1:8081;
    server 127.0.0.1:8082;
}

server {
    listen 80;
    location /app {
        proxy_pass http://app_servers;
    }
}
```

If one or both backend servers are offline, Nginx cannot connect and returns a `502 Bad Gateway` error. You can verify this by checking `/var/log/nginx/error.log`, which will contain connection refused lines:

```text
[error] 1234#1234: *1 connect() failed (111: Connection refused) while connecting to upstream, client: 127.0.0.1, server: localhost, request: "GET /app HTTP/1.1", upstream: "http://127.0.0.1:8081/app"
```

---

## 2. Troubleshooting Steps

1. **Verify ports**: Check if the backend application is listening on the expected ports (`8081` and `8082`) using:
   ```bash
   sudo ss -tulpn | grep -E "8081|8082"
   ```
2. **Verify services**: Ensure the backend services are running.
3. **Verify upstream definitions**: Look for typos in upstream configuration files (typically under `/etc/nginx/conf.d/`).

---

## Lab Tasks

### Task 1: Start an Offline Backend
1. Start the lab:
   ```bash
   tld start nginx-backend-offline
   ```
2. The location `/app` is configured to proxy to the upstream group `app_servers`, which has one server at `127.0.0.1:8081`. However, the backend server on port `8081` is currently offline.
3. A mock Python script is placed at `/tmp/start_backend.sh`. Run this script in the background to start the backend listener on port `8081`.
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Fix an Upstream Port Mismatch
1. Start the lab:
   ```bash
   tld start nginx-port-mismatch
   ```
2. The location `/app` is returning a `502 Bad Gateway`. A mock backend is running on port `8081`.
3. Check `/etc/nginx/conf.d/upstream.conf` and fix the port mismatch (the upstream block is currently configured to route to `127.0.0.1:8088`). Update it to `127.0.0.1:8081`.
4. Reload Nginx.
5. Verify the task:
   ```bash
   tld check
   ```
