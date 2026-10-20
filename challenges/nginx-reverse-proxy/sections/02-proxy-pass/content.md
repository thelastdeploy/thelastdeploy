## Proxying Requests with proxy_pass

The core directive for reverse proxying in Nginx is `proxy_pass`. It forwards incoming requests matching a location block to a specified backend destination.

---

## 1. The `proxy_pass` Directive

The destination in `proxy_pass` can be a protocol and IP address, domain, port, or unix domain socket:

```nginx
location /app/ {
    proxy_pass http://127.0.0.1:3000;
}
```

When a request for `/app/dashboard` is received:
- Nginx forwards it to `http://127.0.0.1:3000/app/dashboard`.

### The Trailing Slash Difference

The presence of a trailing slash in the `proxy_pass` destination changes how the request URI is modified:

- **No Trailing Slash**:
  ```nginx
  location /api/ {
      proxy_pass http://127.0.0.1:3000;
  }
  ```
  A request for `/api/users` is forwarded as `/api/users` (the matched location is preserved).
- **With Trailing Slash**:
  ```nginx
  location /api/ {
      proxy_pass http://127.0.0.1:3000/;
  }
  ```
  A request for `/api/users` is forwarded as `/users` (the matched location `/api/` is replaced by `/`).

---

## Lab Tasks

### Task 1: Proxy a Node.js Application
1. Start the lab:
   ```bash
   tld start nginx-proxy-node-app
   ```
2. Configure a location block `/node` inside `/etc/nginx/sites-available/default` to forward incoming requests to `http://127.0.0.1:3000`:
   ```nginx
   location /node {
       proxy_pass http://127.0.0.1:3000;
   }
   ```
3. Validate configuration syntax and reload Nginx:
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```
4. Verify your solution:
   ```bash
   tld check
   ```

### Task 2: Proxy a Python Application
1. Start the lab:
   ```bash
   tld start nginx-proxy-python-app
   ```
2. Configure a location block `/python` inside `/etc/nginx/sites-available/default` to forward incoming requests to `http://127.0.0.1:8000`:
   ```nginx
   location /python {
       proxy_pass http://127.0.0.1:8000;
   }
   ```
3. Validate configuration syntax and reload Nginx:
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```
4. Verify your solution:
   ```bash
   tld check
   ```
