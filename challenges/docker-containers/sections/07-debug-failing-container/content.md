## Debug failing container

In a DevOps workflow, containers will occasionally fail to start, crash immediately, or exhibit unexpected behaviors. Troubleshooting these requires inspecting the container states, checking the execution command logs, and fixing configurations.

---

## 1. Troubleshooting Crashed Containers

When a container immediately exits or fails to boot:

1. **Check Status**: Run `docker ps -a` to verify if the container exists and what exit code it returned (e.g. `Exited (127)` or `Exited (1)`).
2. **Inspect Command**: Run `docker inspect --format '{{.Path}} {{.Args}}' <container>` to verify what command was executed.
3. **Read Logs**: Use `docker logs <container>` to check stdout/stderr outputs immediately before the crash (e.g. `sh: sleepy: command not found`).

---

## Lab Tasks

### Task 1: Recover crashing container
1. Start the lab in your terminal:
   ```bash
   tld start dkr-recover-crashing-container
   ```
2. A stopped container named `crashing-service` has been created on your host but it fails to start because it was created with an invalid startup command.
3. Investigate the failure. Read the logs or inspect the container to identify the issue.
4. Stop/remove the broken container and run a new working container in detached mode named `crashing-service` using the `alpine` image with the correct startup command: `sleep 1000`.
5. Verify the task:
   ```bash
   tld check
   ```
