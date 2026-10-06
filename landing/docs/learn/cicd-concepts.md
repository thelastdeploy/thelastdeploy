---
title: "CI/CD Concepts & Pipelines"
description: "Pipeline architecture, automated testing stages, artifact management, and delivery strategies."
section: "Learn"
---

## CI vs CD: Definitions

* **Continuous Integration (CI):** Developers merge code changes into shared repositories frequently. Every commit triggers automated build scripts, unit tests, and code style linters to verify integration stability.
* **Continuous Delivery (CD):** Automated deployment pipeline that ensures code changes pass integration testing and are automatically staged for production release.
* **Continuous Deployment (CD):** Automatic deployment of verified commits directly to production without manual gatekeeping.

---

## Pipeline Execution Lifecycle

```text
 ┌────────────────────────────────────────────────────────────────────────┐
 │                      TYPICAL CI/CD PIPELINE STAGES                     │
 │                                                                        │
 │   [ Source ] ──> [ Build ] ──> [ Test ] ──> [ Security ] ──> [ Deploy ]│
 │    git push       docker       pytest        trivy / snyk      k8s /   │
 │                   build        go test       linting           ssh     │
 └────────────────────────────────────────────────────────────────────────┘
```

### Stage Breakdown

1. **Source / Trigger:** Webhook fires on `git push` or pull request creation.
2. **Build:** Compiles binary artifacts or builds OCI Docker images (`docker build`).
3. **Test:** Executes unit test suites, integration tests, and database migrations in disposable test containers.
4. **Security & Linting:** Scans container image layers for known CVEs (`trivy image`), checks code style (`golangci-lint`, `ruff`).
5. **Publish & Deploy:** Pushes container image to remote registry (`docker push`) and updates target cluster deployment.

---

## Key Pipeline Strategies

* **Fail-Fast:** Place fast-executing linters and unit tests at the start of the pipeline so invalid commits fail in seconds.
* **Hermetic Build Environments:** Build and test artifacts inside isolated Docker containers rather than relying on shared runner host dependencies.
* **Immutable Artifacts:** Build a container image once during the build stage and promote that exact image digest through testing, staging, and production environments.