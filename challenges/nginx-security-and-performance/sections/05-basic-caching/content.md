## Proxy Caching

Nginx can cache responses from backend servers (like Node or Python apps) locally, allowing it to respond directly to repeated requests without hitting the application backend, drastically reducing CPU usage and response times.

---

## 1. Defining a Cache Path

To enable proxy caching, you define a cache path and keys zone globally in the `http` context:

```nginx
http {
    # Define cache path, zone name, size, and inactive timeout
    proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=my_cache:10m inactive=60m max_size=1g;
}
```

- **`/var/cache/nginx`**: Local folder path where cached files are written.
- **`levels=1:2`**: Defines a two-level directory hierarchy under `/var/cache/nginx` (prevents filesystem lag when storing thousands of files in a single directory).
- **`keys_zone=my_cache:10m`**: Sets up a shared memory zone named `my_cache` with a size of `10MB` to store cache keys and metadata.
- **`inactive=60m`**: Cached items that are not accessed for `60 minutes` are removed.

---

## 2. Using the Cache in a Location

```nginx
location / {
    proxy_pass http://backend_servers;

    # Enable cache zone
    proxy_cache my_cache;

    # Set cache validity rules (cache 200 OK responses for 10 minutes)
    proxy_cache_valid 200 302 10m;
    proxy_cache_valid 404 1m;
}
```

---

## Lab Tasks

### Task 1: Enable Proxy Caching
1. Start the lab:
   ```bash
   tld start nginx-enable-cache
   ```
2. Define a cache path at `/var/cache/nginx` with a `keys_zone` named `my_cache` and key size of `10m`, and `inactive` timeout of `60m` inside the `http` block of `/etc/nginx/nginx.conf`.
3. Enable this cache inside location block `/app` in `/etc/nginx/sites-available/default` (which proxies to `http://127.0.0.1:8080`).
4. Configure cache validity so that responses with status code `200` are cached for `10m`.
5. Reload Nginx.
6. Verify the task:
   ```bash
   tld check
   ```
