# Exposing Apps with NodePort

While `ClusterIP` is ideal for internal cluster traffic, we often need to expose applications to external clients. The simplest way to achieve this without an external load balancer is using a **NodePort** Service.

---

## What is a NodePort Service?

A NodePort Service builds on top of the ClusterIP Service.
1. It allocates a cluster-internal IP (ClusterIP) just like a normal Service.
2. It reserves a specific port across all nodes in the cluster (typically in the range of **30000–32767**).
3. Any traffic sent to that port on **any node's IP** is routed to the Service's backend Pods.

---

## Defining a NodePort Service

Below is an example of a NodePort Service specification:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nodeport-service
spec:
  type: NodePort
  selector:
    app: my-app
  ports:
    - port: 80         # Port exposed internally in the cluster
      targetPort: 80   # Port on the container inside the Pod
      nodePort: 30080  # Port exposed on all Kubernetes Nodes
```

- If you don't specify `nodePort`, Kubernetes will automatically allocate a random port in the default `30000-32767` range.
- If you specify a static `nodePort`, you must make sure it is not already in use by another Service.

---

## Lab Tasks

### Task 1: Access NodePort Service
1. Start the lab in your terminal:
   ```bash
   tld start k8s-access-nodeport
   ```
2. Navigate to your working directory:
   ```bash
   cd ~/k8s-services-networking
   ```
3. Retrieve the internal IP of the Kubernetes node:
   ```bash
   NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
   ```
4. Send an HTTP request to the NodePort service on port `30080` and save the response to `~/k8s-services-networking/nodeport-response.html`:
   ```bash
   curl -s "http://${NODE_IP}:30080" > ~/k8s-services-networking/nodeport-response.html
   ```
5. Verify the file contents:
   ```bash
   cat ~/k8s-services-networking/nodeport-response.html
   ```
6. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Create a NodePort Service
1. Start the lab in your terminal:
   ```bash
   tld start k8s-create-nodeport
   ```
2. Navigate to your working directory:
   ```bash
   cd ~/k8s-services-networking
   ```
3. Create a YAML manifest named `nodeport-service.yaml` defining a `NodePort` Service named `nodeport-service` that exposes port `80` (target port `80`, static `nodePort: 30080`) selecting pods with `app: backend-app`:
   ```bash
   cat <<EOF > ~/k8s-services-networking/nodeport-service.yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: nodeport-service
   spec:
     type: NodePort
     selector:
       app: backend-app
     ports:
     - port: 80
       targetPort: 80
       nodePort: 30080
   EOF
   kubectl apply -f ~/k8s-services-networking/nodeport-service.yaml
   ```
4. Verify the Service configuration and its active endpoints:
   ```bash
   kubectl get svc nodeport-service
   kubectl get endpoints nodeport-service
   ```
5. Verify the task:
   ```bash
   tld check
   ```
