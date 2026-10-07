# Security Policy

## Reporting a Vulnerability

The Last Deploy team takes the security of our platform, CLI, and local execution environments seriously. If you discover a security vulnerability, we appreciate your help in disclosing it to us responsibly.

**Please DO NOT open public GitHub issues for security vulnerabilities.**

Instead, send an email to:

📧 **`security@thelastdeploy.com`**

### What to Include in Your Report

To help us evaluate and patch the issue quickly, please include:

1. **Description**: A clear summary of the vulnerability and its potential impact.
2. **Component**: Specify the affected component (e.g., CLI binary, container sandbox manager, backend REST API, authentication, web dashboard).
3. **Steps to Reproduce**: Detailed reproduction steps, sample configuration files, or a minimal proof of concept (PoC).
4. **Environment**: Operating System, Docker version, CLI version (`tld version`), and deployment method (local docker-compose vs. production).
5. **Mitigation**: Any potential mitigations or patches you have identified (optional).

---

## Response Timeline & SLA

When you submit a vulnerability report to `security@thelastdeploy.com`:

* **Acknowledgement**: We will acknowledge receipt of your report within **48 hours**.
* **Triage & Assessment**: We will assess the severity and impact within **5 business days** and keep you updated on progress.
* **Patch & Disclosure**: Once a fix is developed and verified, we will issue a patch release and coordinate public disclosure with you.

---

## Scope & Security Boundaries

### In-Scope Components
* **CLI Agent (`agent/`)**: Binary execution, local validator engine, API authentication token handling, cache storage.
* **Backend Platform API (`web/backend`)**: Authentication, user authorization, challenge seeder, leaderboard, API endpoints.
* **Web Frontend & Landing (`web/frontend`, `landing/`)**: Session security, XSS/CSRF protections, documentation platform.
* **Container Environment Isolation**: Host privilege escalation vulnerabilities in local lab containers or validator scripts.

### Out-of-Scope / Design Intent
* **Intentionally Broken Lab States**: Misconfigurations, broken permissions, or vulnerable applications *inside* lab container sandboxes are intentionally created for learning purposes.
* **Local Administrator Privileges**: Running `tld` commands requires local system access (e.g. Docker daemon access); standard local privilege boundaries apply.

---

## Disclosure Policy

We follow a coordinated disclosure model. We ask security researchers to:
* Allow us reasonable time to resolve vulnerabilities before public disclosure.
* Avoid accessing or modifying user data or interrupting live services during testing.
* Act in good faith to avoid privacy violations or destruction of data.

Thank you for helping keep **The Last Deploy** secure!
