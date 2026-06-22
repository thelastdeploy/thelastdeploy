## Resource Limits

By default, a container has no resource constraints and can consume as much CPU and memory as the host's kernel scheduler allows. To prevent a container from starving other services on the host, Docker lets you cap resource usage.

---

## 1. Memory Constraints (`-m` / `--memory` flag)

The most common resource restriction is limiting the memory of a container. You can enforce a limit using the `-m` or `--memory` flag with a unit suffix (e.g. `b` for bytes, `k` for kilobytes, `m` for megabytes, `g` for gigabytes):

```bash
docker run -d --name memory-limited-app -m 256m nginx
```

If the container process attempts to allocate more memory than this limit, the Linux kernel out-of-memory (OOM) killer will terminate it, stopping the container.

---

## Lab Tasks

### Task 1: Limit container memory
1. Start the lab in your terminal:
   ```bash
   tld start dkr-limit-container-memory
   ```
2. Your goal is to start a background (detached) container named `memory-capped` using the `alpine` image running `sleep 1000`.
3. Configure it to have a memory limit of exactly `128m` (128 Megabytes).
4. Verify the task:
   ```bash
   tld check
   ```
