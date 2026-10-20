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
2. Observe that requesting `/app` returns `502 Bad Gateway` because the upstream server on `127.0.0.1:8081` is offline.
3. Launch the provided backend startup script in the background:
   ```bash
   /tmp/start_backend.sh &
   ```
4. Verify that the backend is responding through Nginx:
   ```bash
   curl http://localhost/app
   ```
5. Check your solution:
   ```bash
   tld check
   ```

### Task 2: Fix an Upstream Port Mismatch
1. Start the lab:
   ```bash
   tld start nginx-port-mismatch
   ```
2. Notice that the location `/app` returns `502 Bad Gateway`. A mock backend is actively running on port `8081`.
3. Open `/etc/nginx/conf.d/upstream.conf` and update the upstream server definition from port `8088` to `8081` (`server 127.0.0.1:8081;`).
4. Test configuration syntax and reload Nginx:
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```
5. Verify that `/app` returns `UPSTREAM OK`:
   ```bash
   curl http://localhost/app
   ```
6. Check your solution:
   ```bash
   tld check
   ```
