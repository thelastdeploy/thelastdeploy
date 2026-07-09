## WebSocket Support

WebSockets allow persistent, bi-directional, full-duplex TCP connections between the client browser and the backend server. By default, standard HTTP proxies close connections quickly or drop connection upgrade requests. To reverse proxy WebSockets, Nginx must be configured to pass special upgrade headers.

---

## 1. Upgrading Connections

WebSockets begin with an HTTP request containing two headers:
- `Upgrade: websocket`
- `Connection: Upgrade`

If Nginx does not pass these, the backend will treat it as a standard HTTP request and fail the handshake.

---

## 2. Configuring WebSocket proxying

We explicitly forward the upgrade headers using `proxy_set_header`:

```nginx
location /ws/ {
    proxy_pass http://127.0.0.1:9000;
    
    # Enable HTTP/1.1 (required for keepalive and upgrade connection)
    proxy_http_version 1.1;

    # Map WebSocket connection upgrade headers
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
}
```

- **`proxy_http_version 1.1;`**: By default, Nginx proxies use HTTP/1.0. WebSockets require HTTP/1.1 to support connection upgrades.
- **`proxy_set_header Upgrade $http_upgrade;`**: Evaluates the client's incoming `Upgrade` header and forwards it.
- **`proxy_set_header Connection "upgrade";`**: Overrides the connection header to specify upgrade mapping.

---

## Lab Tasks

### Task 1: Enable WebSocket proxying
1. Start the lab:
   ```bash
   tld start nginx-enable-websocket-proxy
   ```
2. Configure a location block `/ws` inside `/etc/nginx/sites-available/default` to proxy requests to `http://127.0.0.1:9000`.
3. Add the WebSocket upgrade header rules (`Upgrade` header using `$http_upgrade`, `Connection` header using `"upgrade"`, and HTTP version set to `1.1`).
4. Reload Nginx.
5. Verify the task:
   ```bash
   tld check
   ```
