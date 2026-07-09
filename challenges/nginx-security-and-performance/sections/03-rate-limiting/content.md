## Rate Limiting

Rate limiting is used to mitigate brute-force attacks, scrape bots, and Distributed Denial of Service (DDoS) traffic by limiting the number of requests a user can make in a given timeframe.

Nginx implements rate limiting using a leaky bucket algorithm via the `ngx_http_limit_req_module`.

---

## 1. Defining a Rate Limit Zone

Rate limits are configured in two steps: first defining the tracking bucket (zone) in the `http` context, then applying it inside a `server` or `location` block.

### Step 1: Define Zone in `http {}`
```nginx
limit_req_zone $binary_remote_addr zone=mylimit:10m rate=5r/s;
```

- **`$binary_remote_addr`**: Uses the binary representation of the client's IP address (takes less memory, ~32 bytes per IP v4 address vs ~64 bytes for text representation).
- **`zone=mylimit:10m`**: Sets up a shared memory zone named `mylimit` with a size of `10 megabytes` (enough to store ~160,000 unique IP states).
- **`rate=5r/s`**: Sets the limit rate to `5 requests per second`.

---

## 2. Applying the Zone

### Step 2: Apply in `location {}`
```nginx
location /api/ {
    limit_req zone=mylimit burst=10 nodelay;
}
```

- **`zone=mylimit`**: References the memory zone defined in the `http` context.
- **`burst=10`**: Allows a burst queue capacity of up to `10` requests beyond the standard rate.
- **`nodelay`**: Incoming requests within the burst capacity limit are processed immediately without delay (otherwise, they are spaced out to conform to the rate). Requests exceeding the burst capacity return a `503 Service Temporarily Unavailable` status code.

---

## Lab Tasks

### Task 1: Protect the API with Rate Limiting
1. Start the lab:
   ```bash
   tld start nginx-limit-requests
   ```
2. Define a rate-limiting zone named `mylimit` in `/etc/nginx/nginx.conf` tracking client IP addresses (`$binary_remote_addr`) with a memory size of `10m` and a rate of `5r/s`.
3. Apply this zone inside location block `/api/` in the default server config `/etc/nginx/sites-available/default` with a `burst` capacity of `10` and `nodelay` active.
4. Reload Nginx.
5. Verify the task:
   ```bash
   tld check
   ```
