## Security Headers

You can improve your website's security posture by returning HTTP security headers in responses. These headers instruct the browser to enable security features like restricting script sources or blocking clickjacking attempts.

To add headers in Nginx, use the `add_header` directive.

---

## 1. Strict-Transport-Security (HSTS)

Forces browsers to only communicate with the server over secure HTTPS connections:

```nginx
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
```

- **`always`**: Ensures the header is returned for both successful and error responses.

---

## 2. Content-Security-Policy (CSP)

Restricts the resources (like JavaScript, CSS, Images) that the browser is allowed to load:

```nginx
# Restrict scripts and resources to same-origin only
add_header Content-Security-Policy "default-src 'self';" always;
```

---

## 3. X-Frame-Options

Protects against clickjacking attacks by blocking the page from being embedded inside a `<frame>`, `<iframe>`, or `<object>` on another site:

```nginx
add_header X-Frame-Options "DENY" always;
```

---

## Lab Tasks

### Task 1: Enable HSTS
1. Start the lab:
   ```bash
   tld start nginx-enable-hsts
   ```
2. Configure the HSTS header in `/etc/nginx/sites-available/default` inside the main `server` context with a `max-age` of `31536000` seconds and the `always` flag.
3. Reload Nginx.
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Configure Content Security Policy
1. Start the lab:
   ```bash
   tld start nginx-content-security-policy
   ```
2. Configure a basic CSP header in `/etc/nginx/sites-available/default` restricting `default-src` to `'self'` (include the `always` flag).
3. Reload Nginx.
4. Verify the task:
   ```bash
   tld check
   ```

### Task 3: Prevent Clickjacking with X-Frame-Options
1. Start the lab:
   ```bash
   tld start nginx-x-frame-options
   ```
2. Configure the `X-Frame-Options` header to `DENY` globally inside `/etc/nginx/sites-available/default` (include the `always` flag).
3. Reload Nginx.
4. Verify the task:
   ```bash
   tld check
   ```
