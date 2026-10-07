---
title: "Docker Concepts & Architecture"
description: "Kernel namespaces, cgroups, images, container execution models, and networking."
section: "Learn"
---

## What a Container Actually Is

A Docker container is not a lightweight virtual machine. A container is a standard Linux process executing on the host kernel, restricted by two primary kernel primitives:

1. **Namespaces:** Isolate what the process can see (`pid`, `net`, `mnt`, `ipc`, `uts`, `user`).
2. **Control Groups (cgroups):** Enforce limits on what resource quantities the process can consume (CPU quotas, RAM limits, block I/O bandwidth).

Because containers share the host kernel, they start in milliseconds without requiring hypervisor guest OS boot overhead.

---

## Images vs Containers

* **Docker Image:** An immutable, layered tarball containing system binaries, application code, and metadata (environment variables, default entrypoint). Built from instructions in a `Dockerfile`.
* **Container:** An active runtime instance of an image. Docker mounts a writeable copy-on-write (CoW) layer on top of the image's read-only layers.

```mermaid
graph TD
    subgraph Docker Host
        DAEMON["Docker Daemon<br/><i>(dockerd)</i>"]
        CACHE[("Local Image Cache<br/><i>(alpine, nginx, postgres)</i>")]
        DAEMON <--> CACHE

        subgraph Kernel Namespaces
            CA["Container A"]
            CB["Container B"]
            CC["Container C"]
        end

        DAEMON -- Manages via runc / containerd --> Kernel Namespaces
    end
```

---

## Essential Commands & Diagnostics

### Build an Image
```bash
docker build -t custom-api:v1.0 .
```
Reads `Dockerfile`, builds image layers, and labels the result in local storage.

### Run a Container
```bash
docker run -d --name api-server -p 8080:80 -e PORT=80 custom-api:v1.0
```
Instantiates container in detached mode (`-d`), binding host port `8080` to container port `80`.

### Inspect Running Processes
```bash
docker top api-server
```
Displays processes running inside the container namespace from the host perspective.

### Inspect Logs
```bash
docker logs --tail 50 -f api-server
```
Streams stdout and stderr from process `PID 1` inside the container.