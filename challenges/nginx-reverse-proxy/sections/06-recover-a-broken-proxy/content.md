## Recover a Broken Proxy

When configuring `proxy_pass` targets, a common syntax error is leaving off the URL protocol scheme (e.g. `http://` or `https://`). If Nginx reads a bare IP/Port inside `proxy_pass` (outside of variables or upstream tags), the configuration check will fail, blocking Nginx from starting.

---

## 1. The Typo

If Nginx reads:
```nginx
location /api {
    proxy_pass 127.0.0.1:8080;
}
```

Running `sudo nginx -t` will output:
```text
nginx: [emerg] invalid URL prefix in /etc/nginx/sites-enabled/default:53
```

---

## 2. Fixing the Prefix

To resolve this issue, you must ensure that all backend proxy references contain the valid protocol scheme:
```nginx
location /api {
    proxy_pass http://127.0.0.1:8080;
}
```

---

## Lab Tasks

### Task 1: Fix broken reverse proxy configuration
1. Start the lab:
   ```bash
   tld start nginx-fix-reverse-proxy
   ```
2. The seed script has introduced a broken `proxy_pass` directive inside `/etc/nginx/sites-available/default` that contains a malformed target endpoint (`127.0.0.1:8080` without `http://`), causing the configuration check to fail:
   ```bash
   sudo nginx -t
   ```
3. Locate the broken `location /api` block in `/etc/nginx/sites-available/default` and update `proxy_pass` to include the `http://` scheme:
   ```nginx
   location /api {
       proxy_pass http://127.0.0.1:8080;
   }
   ```
4. Validate configuration syntax and start Nginx:
   ```bash
   sudo nginx -t
   sudo systemctl start nginx
   ```
5. Verify your solution:
   ```bash
   tld check
   ```
