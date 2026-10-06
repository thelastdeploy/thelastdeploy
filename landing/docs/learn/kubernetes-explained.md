---
title: "Kubernetes Explained"
description: "Core API objects, pod lifecycles, service routing, and control plane architecture."
section: "Learn"
---

## What Kubernetes Does

Kubernetes (k8s) is a container orchestration platform. While Docker manages individual containers on a single host machine, Kubernetes manages container clusters across multiple compute nodes, handling scheduling, self-healing, scaling, and load balancing.

---

## Core API Objects

### Pod
The smallest execution unit in Kubernetes. A Pod wraps one or more co-located containers that share network namespaces, IP addresses, and storage volumes.

### Deployment
A declarative spec managing Pod replicas. When you update a Deployment container image, Kubernetes performs a rolling update, spawning new Pods before terminating old ones.

### Service
A stable network abstraction (ClusterIP, NodePort, LoadBalancer) providing a static virtual IP and DNS name for dynamic sets of Pods matching a label selector.

---

## Control Plane & Node Components

```text
┌────────────────────────────────────────────────────────────────────────┐
│                             CONTROL PLANE                              │
│                                                                        │
│   ┌───────────────┐     ┌───────────────┐     ┌────────────────────┐   │
│   │ kube-apiserver│ <-> │     etcd      │ <-> │   kube-scheduler   │   │
│   └───────────────┘     └───────────────┘     └────────────────────┘   │
└──────────────────────────────────▲─────────────────────────────────────┘
                                   │
                                   ▼
┌────────────────────────────────────────────────────────────────────────┐
│                              WORKER NODE                               │
│                                                                        │
│   ┌───────────────┐     ┌───────────────┐     ┌────────────────────┐   │
│   │    kubelet    │ <-> │  containerd   │ <-> │     kube-proxy     │   │
│   └───────────────┘     └───────────────┘     └────────────────────┘   │
└────────────────────────────────────────────────────────────────────────┘
```

* **kube-apiserver:** REST API gateway exposing the cluster interface to `kubectl` and internal components.
* **etcd:** Distributed key-value store holding cluster state and configuration resources.
* **kubelet:** Worker node agent verifying that containers declared in PodSpecs are running and healthy.
* **kube-proxy:** Network proxy managing iptables or IPVS rules for Service IP routing.