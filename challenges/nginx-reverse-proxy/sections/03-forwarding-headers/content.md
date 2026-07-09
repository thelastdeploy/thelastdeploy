## Forwarding Headers

By default, Nginx overrides or drops certain headers when proxying a request to a backend application. For instance, the backend app will see the Nginx server's IP address as the client's IP, and it won't receive the original host header requested by the browser.

To retain this critical request info, we modify HTTP headers before forwarding using the `proxy_set_header` directive.

---

## 1. The `proxy_set_header` Directive

You can define custom headers or modify standard ones inside any context where `proxy_pass` is active:

```nginx
location /app/ {
    proxy_pass http://127.0.0.1:3000;

    # Set host header to original request Host
    proxy_set_header Host $host;

    # Forward client IP address
    proxy_set_header X-Real-IP $remote_addr;

    # Forward list of proxies traversed
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    # Forward request schema (http vs https)
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

---

## Lab Tasks

### Task 1: Forward Host Header
1. Start the lab:
   ```bash
   tld start nginx-forward-host-header
   ```
2. Modify the default server block `/etc/nginx/sites-available/default` inside location `/node` to forward the original Host header using the Nginx variable `$host`.
3. Reload Nginx.
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Forward Client IP Address
1. Start the lab:
   ```bash
   tld start nginx-forward-client-ip
   ```
2. Modify location `/node` inside `/etc/nginx/sites-available/default` to forward:
   - Client IP under header `X-Real-IP` using `$remote_addr`.
   - Traversed proxy IP list under header `X-Forwarded-For` using `$proxy_add_x_forwarded_for`.
3. Reload Nginx.
4. Verify the task:
   ```bash
   tld check
   ```
