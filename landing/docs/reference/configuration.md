---
title: "Configuration Reference"
description: "Specification for CLI local config (~/.tld/config.json) and lab authoring YAML manifests."
section: "Reference"
---

## 1. CLI Local Configuration (`~/.tld/config.json`)

The TLD CLI reads and writes its state at `~/.tld/config.json`. The file is created automatically on first run with mode `0600`.

```json
{
  "api_url": "http://localhost:9001",
  "auth_token": "eyJhbGciOiJIUzI1Ni...",
  "user": {
    "id": "usr_9102",
    "username": "devops_engineer",
    "email": "devops@example.com"
  },
  "preferences": {
    "auto_update": false,
    "color_output": true
  }
}
```

### Fields

* `api_url` *(string)*: Target FastAPI backend URI. Can be overridden using `TLD_API_URL`.
* `auth_token` *(string)*: JWT access token saved after `tld login`.
* `preferences.auto_update` *(boolean)*: Toggles automatic update prompts.

---

## 2. Lab Manifest (`lab.yaml`)

Each lab scenario directory contains a `lab.yaml` file defining the container image, entrypoint, resource constraints, and validation script location.

```yaml
id: docker-bridge-networking
module_id: container-fundamentals
title: Debug Docker Bridge Networking
topic: networking
difficulty: intermediate
estimated_minutes: 20
xp: 75

environment:
  setup_type: docker
  image: "tld/lab-docker-bridge:v1.0"
  container_name: "tld-target-app"
  ports:
    - "8080:80"

resource_limits:
  cpu_cores: 1.0
  memory_mb: 512

validation:
  script: "scripts/validator.sh"
  timeout_seconds: 30
```

### Fields

* `id` *(string)*: Unique slug identifier for the lab (used with `tld lab start <id>`).
* `environment.image` *(string)*: OCI/Docker container image pulled or executed locally.
* `environment.ports` *(list of string)*: Port mappings formatted as `host_port:container_port`.
* `resource_limits.memory_mb` *(integer)*: Hard RAM limit enforced via Docker cgroups.
* `validation.script` *(string)*: Relative path to bash validation script inside lab workspace.