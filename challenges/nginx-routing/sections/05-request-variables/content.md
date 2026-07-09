## Request Variables

Nginx provides a set of pre-defined variables that capture details about the client's connection and HTTP request. These variables can be evaluated dynamically inside configurations to write flexible routing rules, control logs, and inject header flags.

---

## 1. Common Nginx Variables

- **`$request_uri`**: The full original request URI including arguments (e.g. `/index.html?id=5`).
- **`$uri`**: The current normalized URI in Nginx (without arguments, and may change during internal rewrites).
- **`$args`**: The query parameters (e.g. `id=5`).
- **`$host`**: The hostname requested in the `Host` header.
- **`$remote_addr`**: The client's IP address.
- **`$http_user_agent`**: The client's User-Agent string (any HTTP header can be accessed via `$http_<header_name_in_lowercase_with_underscores>`).

---

## 2. Using Variables in Responses

You can return text responses that reference these variables directly:

```nginx
location /my-ip {
    default_type text/plain;
    return 200 "Your IP is: $remote_addr";
}
```

---

## Lab Tasks

### Task 1: Serve client User-Agent information
1. Start the lab:
   ```bash
   tld start nginx-request-variables
   ```
2. Configure a location block `/info` inside `/etc/nginx/sites-available/default`.
3. Set the response Content-Type to `text/plain` using `default_type text/plain;`.
4. Configure it to return HTTP status `200` with the response body exactly matching: `Agent: <client_user_agent>` (use `$http_user_agent`).
5. Reload Nginx.
6. Verify the task:
   ```bash
   tld check
   ```
