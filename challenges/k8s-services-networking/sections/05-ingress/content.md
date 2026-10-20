# Routing Traffic with Ingress

While `NodePort` exposes services externally, it has major limitations:
- You must manage custom non-standard ports (`30000-32767`).
- Each service requires its own NodePort.
- There is no support for hostname-based routing (e.g. `app.example.com` vs `api.example.com`) or SSL/TLS termination on standard HTTP/HTTPS ports (80/443).

**Ingress** solves these problems.

---

## What is Ingress?

An **Ingress** is an API object that manages external access to the services in a cluster, typically HTTP. It can provide load balancing, SSL termination, and name-based virtual hosting.

To make Ingress resources work, the cluster must have an **Ingress Controller** running. Unlike other controllers (like the replicaset controller), which run as part of the `kube-controller-manager` binary, Ingress Controllers are not started automatically with a cluster and must be installed separately.

Popular ingress controllers include:
- `ingress-nginx` (community-maintained Nginx-based)
- Traefik
- HAProxy
- Kong

---

## Defining an Ingress Resource

An Ingress resource defines the routing rules:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: minimal-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: app.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: backend-service
            port:
              number: 80
```

- **`ingressClassName`**: Tells the cluster which Ingress Controller should handle this Ingress resource (usually `nginx`).
- **`host`**: The domain name to map.
- **`backend.service`**: The destination Service and Port.

---

## Lab Tasks

### Task 1: Create an Ingress Resource
1. Start the lab in your terminal:
   ```bash
   tld start k8s-create-ingress
   ```
2. Navigate to your working directory:
   ```bash
   cd ~/k8s-services-networking
   ```
3. Create an Ingress resource manifest `app-ingress.yaml` named `app-ingress` with `ingressClassName: nginx` that routes requests for host `app.local` with prefix path `/` to `backend-service` on port `80`:
   ```bash
   cat <<EOF > ~/k8s-services-networking/app-ingress.yaml
   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata:
     name: app-ingress
   spec:
     ingressClassName: nginx
     rules:
     - host: app.local
       http:
         paths:
         - path: /
           pathType: Prefix
           backend:
             service:
               name: backend-service
               port:
                 number: 80
   EOF
   kubectl apply -f ~/k8s-services-networking/app-ingress.yaml
   ```
4. Verify the Ingress configuration:
   ```bash
   kubectl get ingress app-ingress
   ```
5. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Install an Ingress Controller
1. Start the lab in your terminal:
   ```bash
   tld start k8s-install-ingress
   ```
2. Navigate to your working directory:
   ```bash
   cd ~/k8s-services-networking
   ```
3. Deploy the Ingress Controller by applying the provided manifest `ingress-controller.yaml`:
   ```bash
   kubectl apply -f ~/k8s-services-networking/ingress-controller.yaml
   ```
4. Wait for the Ingress Controller deployment to complete its rollout and become ready:
   ```bash
   kubectl rollout status deployment/ingress-nginx-controller -n ingress-nginx
   ```
5. Verify the task:
   ```bash
   tld check
   ```
