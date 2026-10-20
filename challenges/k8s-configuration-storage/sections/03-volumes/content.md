# Volumes

On-disk files in a container are ephemeral, which presents some problems for non-trivial applications when running in containers:
1. When a container crashes, the kubelet restarts it, but files are lost (the container starts with a clean state).
2. Sharing files between containers running together in a Pod is difficult.

A Kubernetes **Volume** solves both of these problems.

---

## Transient Volumes (`emptyDir`)

An `emptyDir` volume is created when a Pod is assigned to a node, and exists as long as that Pod is running on that node.

As the name says, the volume is initially empty. All containers in the Pod can read and write the same files in the `emptyDir` volume, though that volume can be mounted at the same or different paths in each container. When a Pod is removed from a node for any reason, the data in the `emptyDir` is deleted permanently.

---

## Defining a Pod Volume Mount

To configure a volume in a Pod:
1. Define a volume under `spec.volumes` specifying name and storage provider type.
2. Define `volumeMounts` inside the container spec referencing that volume name and target path.

```yaml
spec:
  volumes:
  - name: cache-volume
    emptyDir: {}
  containers:
  - name: web
    image: nginx
    volumeMounts:
    - name: cache-volume
      mountPath: /cache
```
Here, directory `/cache` inside the container is backed by the transient volume named `cache-volume`.

---

## Lab Tasks

### Task 1: Create transient emptyDir Volume
1. Start the lab in your terminal:
   ```bash
   tld start k8s-emptydir-volume
   ```
2. Create a Pod named `temp-data-pod` with a container named `main` (using image `nginx`) mounting an `emptyDir` volume at `/tmp/data`:
   ```bash
   cat <<EOF | kubectl apply -f -
   apiVersion: v1
   kind: Pod
   metadata:
     name: temp-data-pod
   spec:
     volumes:
     - name: temp-storage
       emptyDir: {}
     containers:
     - name: main
       image: nginx
       volumeMounts:
       - name: temp-storage
         mountPath: /tmp/data
   EOF
   ```
3. Wait for the pod to become ready:
   ```bash
   kubectl wait --for=condition=Ready pod/temp-data-pod --timeout=60s
   ```
4. Verify the task:
   ```bash
   tld check
   ```

### Task 2: Create Shared Volume
1. Start the lab in your terminal:
   ```bash
   tld start k8s-shared-volume
   ```
2. Create a multi-container Pod named `sharing-pod` with containers `writer` and `reader`, both sharing an `emptyDir` volume mounted at `/shared`, with `writer` populating `/shared/message.txt`:
   ```bash
   cat <<EOF | kubectl apply -f -
   apiVersion: v1
   kind: Pod
   metadata:
     name: sharing-pod
   spec:
     volumes:
     - name: shared-storage
       emptyDir: {}
     containers:
     - name: writer
       image: busybox
       command: ["sh", "-c", "echo 'hello from shared volume' > /shared/message.txt && sleep 3600"]
       volumeMounts:
       - name: shared-storage
         mountPath: /shared
     - name: reader
       image: busybox
       command: ["sh", "-c", "sleep 3600"]
       volumeMounts:
       - name: shared-storage
         mountPath: /shared
   EOF
   ```
3. Wait for the pod to become ready and verify that the `reader` container can access `/shared/message.txt`:
   ```bash
   kubectl wait --for=condition=Ready pod/sharing-pod --timeout=60s
   kubectl exec sharing-pod -c reader -- cat /shared/message.txt
   ```
4. Verify the task:
   ```bash
   tld check
   ```
