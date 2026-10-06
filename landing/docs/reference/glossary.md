---
title: "DevOps & TLD Terminology Glossary"
description: "Definitions of core technical terms used across TLD lab challenges and platform documentation."
section: "Reference"
---

## TLD Platform Terms

* **Track:** A top-level learning domain focused on a specific DevOps discipline (e.g., Linux Systems, Container Operations, Cloud Networking).
* **Module:** A collection of conceptual sections and ordered lab challenges within a track.
* **Lab:** A self-contained, disposable learning environment introduced with a specific misconfiguration or broken state.
* **Validator:** A shell or Python script (`validator.sh`) that programmatically inspects lab container state to verify whether solution criteria are met.
* **Device Flow:** An OAuth2 authentication protocol (RFC 8628) that connects terminal CLI sessions to web user accounts without requiring terminal password prompts.

---

## DevOps & System Concepts

* **Bridge Network:** A soft software switch created inside Linux host kernels by Docker (`docker0`) to enable container-to-container communication.
* **cgroups (Control Groups):** Linux kernel feature that limits, accounts for, and isolates resource usage (CPU, memory, disk I/O) of process groups.
* **cgroup namespaces:** Process isolation feature ensuring a container process cannot view or alter host system cgroup hierarchies.
* **Disposable Environment:** A temporary container or VM sandbox spun up for a single lab session and destroyed on teardown.
* **Systemd:** System and service manager in modern Linux distributions responsible for process supervision, socket activation, and logging via `journalctl`.
* **Unix Domain Socket:** An inter-process communication endpoint enabling bidirection process communication on the same host operating system file hierarchy (e.g., `/var/run/docker.sock`).