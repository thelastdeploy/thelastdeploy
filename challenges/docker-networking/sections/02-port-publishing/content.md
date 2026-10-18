## Port Publishing

To route incoming traffic from outside the Docker host into your isolated containers, you must **publish** the container's ports using the `-p` (or `--publish`) flag.

---

## 1. Exposing Ports (`-p hostPort:containerPort`)

The general syntax for publishing a port is:
```bash
docker run -p <host-port>:<container-port> <image-name>
```

For example, if you run Nginx (which listens on port 80 inside the container) and map it to host port 8080:
```bash
docker run -d --name web -p 8080:80 nginx:alpine
```
Traffic hitting the host's network interfaces on port 8080 will automatically be forwarded to port 80 inside the `web` container.

---

## 2. Binding to Specific Interfaces (`-p ip:hostPort:containerPort`)

By default, Docker publishes ports on all host interfaces (`0.0.0.0`), making the port accessible to anyone who can connect to your host machine's IP address.

For local-only services (like local databases or internal proxies), you should bind to `127.0.0.1` (localhost) so only processes on the host itself can connect:
```bash
docker run -d --name db -p 127.0.0.1:5432:5432 postgres
```

---

## Lab Tasks

### Task 1: Expose web service (`dkr-expose-web-service`)
1. Start the lab session:
   ```bash
   tld start dkr-expose-web-service
   ```
2. Start a background container named `web-service` using the `nginx:alpine` image mapping host port `8088` to container port `80`:
   ```bash
   docker run -d --name web-service -p 8088:80 nginx:alpine
   ```
3. Verify that the web service is accessible:
   ```bash
   curl -s http://localhost:8088
   ```
4. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Publish a port on localhost (`dkr-publish-port`)
1. Start the lab session:
   ```bash
   tld start dkr-publish-port
   ```
2. Start a background container named `static-web` using the `nginx:alpine` image mapping container port `80` to host port `8089` bound strictly to loopback IP `127.0.0.1`:
   ```bash
   docker run -d --name static-web -p 127.0.0.1:8089:80 nginx:alpine
   ```
3. Verify that the port is accessible on localhost:
   ```bash
   curl -s http://127.0.0.1:8089
   ```
4. Validate your solution:
   ```bash
   tld check
   ```
