# Production Service Architecture

Designing robust systemd multi-service dependency stacks, custom unit files, restart policies, and resource limits.

In enterprise Linux administration, applications run as managed systemd service topologies. Correct service management requires explicitly defining dependency order (`Requires=`, `Wants=`, `After=`), sandbox isolation (`ProtectSystem=full`, `PrivateTmp=true`), and automatic restart strategies (`Restart=on-failure`).

### Systemd Stack Architecture
- **Dependency Control**: `Wants=db.service`, `After=db.service network.target`.
- **Resource Limits**: `MemoryMax=2G`, `CPUWeight=100`, `TasksMax=500`.
- **Process Supervision**: `Type=notify` or `Type=exec` with health notifications.


---

## Lab Tasks

### Task 1: Design Service Dependencies (`lnx-design-service-dependencies`)
1. Start the lab:
   ```bash
   tld start lnx-design-service-dependencies
   ```
2. Create directory `$HOME/service-stack`.
3. Configure systemd unit file dependency directives (`Requires=`, `Wants=`, `After=`).
4. Write `SYSTEMD_SERVICE_DEPENDENCIES_CONFIGURED` into `$HOME/service-stack/service_dependencies.log`.
5. Validate your solution:
   ```bash
   tld check
   ```

### Task 2: Manage Production Service Stack (`lnx-manage-production-service-stack`)
1. Start the lab:
   ```bash
   tld start lnx-manage-production-service-stack
   ```
2. Create a custom systemd target unit file to manage a web and database service stack.
3. Enforce automatic restart policies and security sandboxing.
4. Write `PRODUCTION_SERVICE_STACK_OPERATIONAL` into `$HOME/service-stack/production_stack.status`.
5. Validate your solution:
   ```bash
   tld check
   ```
