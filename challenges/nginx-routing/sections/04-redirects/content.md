## HTTP Redirects

Unlike internal rewrites, an HTTP redirect returns a response with redirection status codes (such as `301` or `302`) and a `Location` header to the client. This forces the browser to make a new request to the new URL, updating the address bar.

---

## 1. Redirect Types

- **`301 Moved Permanently`**: Used for permanent changes. Browsers and search engines cache this redirect, meaning search engines will pass SEO authority (link juice) to the new URL.
- **`302 Found`** (or `302 Moved Temporarily`): Used for temporary changes. Browsers do not cache this redirect.

---

## 2. Setting Up Redirects

In Nginx, redirections are typically set up using the `return` directive (which is faster and more efficient than using `rewrite` flags):

```nginx
# Permanent Redirect from /old-path to /new-path
location /old-page {
    return 301 /new-page;
}

# Redirect all port 80 traffic to external site
location /google {
    return 302 https://www.google.com;
}
```

---

## Lab Tasks

### Task 1: Configure general HTTP redirect
1. Start the lab:
   ```bash
   tld start nginx-http-redirect
   ```
2. Configure a location block `/google` in the default site config that redirects clients to `https://www.google.com` using a temporary redirect (`302`).
3. Reload Nginx.
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Configure permanent redirect (301)
1. Start the lab:
   ```bash
   tld start nginx-permanent-redirect
   ```
2. Configure Nginx to permanently redirect `/old-page` to `/new-page` returning a `301` status code.
3. Reload Nginx.
4. Verify the task:
   ```bash
   tld check
   ```

### Task 3: Configure temporary redirect (302)
1. Start the lab:
   ```bash
   tld start nginx-temporary-redirect
   ```
2. Configure Nginx to temporarily redirect `/promo` to `/landing-page` returning a `302` status code.
3. Reload Nginx.
4. Verify the task:
   ```bash
   tld check
   ```
