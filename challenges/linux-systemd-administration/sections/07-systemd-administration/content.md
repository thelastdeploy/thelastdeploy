# Production Service Administration & Hardening

Integrating custom applications into production environments requires robust unit configurations that include environment file loading, automatic crash recovery, resource limits, and security sandboxing.

---

## Production Unit Hardening Directives

```ini
[Unit]
Description=Production API Gateway
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=appuser
Group=appgroup
WorkingDirectory=/opt/apigateway
EnvironmentFile=/etc/default/apigateway

ExecStart=/opt/apigateway/bin/gateway

# Auto-restart configuration
Restart=always
RestartSec=3s

# Resource Limits
LimitNOFILE=65536
LimitNPROC=4096

# Security Sandboxing
NoNewPrivileges=true
ProtectSystem=full
ProtectHome=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

---

## Summary

Production systemd configurations combine process supervision, restart policies, resource limits (`LimitNOFILE`), and security isolation directives.

---

## Lab Tasks

### Task 1: Configure Production systemd Service (`lnx-configure-production-service`)
1. Start the lab:
   ```bash
   tld start lnx-configure-production-service
   ```
2. Create directory `$HOME/prod-service-test`.
3. Create production unit file `$HOME/prod-service-test/prod-api.service` featuring:
4. - `EnvironmentFile=/etc/default/prod-api`
5. - `Restart=always`
6. - `LimitNOFILE=65536`
7. - `NoNewPrivileges=true`
8. - `WantedBy=multi-user.target`
9. Validate your solution:
   ```bash
   tld check
   ```
