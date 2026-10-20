# Inspecting Pods

Once a Pod is running, you can inspect its IP address, query application logs, and execute commands inside its containers.

---

## 1. Finding Pod Details (IP & Node)

Using the `-o wide` flag, you can see the internal IP address assigned to the Pod and the worker node it has been scheduled to run on:
```bash
kubectl get pods -o wide
```

For more detailed low-level parameters, output the state in YAML:
```bash
kubectl get pod nginx-pod -o yaml
```

---

## 2. Querying Container Logs

If your application container outputs logs to standard output/error, you can retrieve them using:
```bash
kubectl logs nginx-pod
```

If the Pod runs multiple containers, you must specify the target container name using `-c`:
```bash
kubectl logs my-pod -c main-app
```

To stream the logs continuously:
```bash
kubectl logs -f nginx-pod
```

---

## 3. Executing Commands inside Containers

To troubleshoot an application or query local configs, you can run interactive bash sessions inside the container:
```bash
kubectl exec -it nginx-pod -- /bin/bash
```

Or execute a single command without opening an interactive shell:
```bash
kubectl exec nginx-pod -- ls -la /usr/share/nginx/html
```

---

## Lab Tasks

### Task 1: Exec Into Container
1. Start the lab in your terminal:
   ```bash
   tld start k8s-exec-into-pod
   ```
2. Execute a command inside the running `exec-pod` container to write its hostname into `/tmp/hostname.txt`:
   ```bash
   kubectl exec exec-pod -- sh -c 'hostname > /tmp/hostname.txt'
   ```
3. Confirm that `/tmp/hostname.txt` exists inside the container and contains `exec-pod`:
   ```bash
   kubectl exec exec-pod -- cat /tmp/hostname.txt
   ```
4. Check your solution:
   ```bash
   tld check
   ```

### Task 2: Inspect a Pod IP
1. Start the lab in your terminal:
   ```bash
   tld start k8s-inspect-pod
   ```
2. Query the IP address of `test-pod` using `kubectl get pod`:
   ```bash
   kubectl get pod test-pod -o wide
   ```
3. Extract solely the pod IP and save it to `~/k8s-pods/pod-ip.txt`:
   ```bash
   mkdir -p ~/k8s-pods
   kubectl get pod test-pod -o jsonpath='{.status.podIP}' > ~/k8s-pods/pod-ip.txt
   ```
4. Verify that `~/k8s-pods/pod-ip.txt` contains solely the IP address:
   ```bash
   cat ~/k8s-pods/pod-ip.txt
   ```
5. Check your solution:
   ```bash
   tld check
   ```

### Task 3: Inspect Pod Logs
1. Start the lab in your terminal:
   ```bash
   tld start k8s-view-pod-logs
   ```
2. View the logs output by `logging-pod`:
   ```bash
   kubectl logs logging-pod
   ```
3. Extract the flag message (starting with `FLAG_LOG_MESSAGE_`) and save it to `~/k8s-pods/flag.txt`:
   ```bash
   mkdir -p ~/k8s-pods
   kubectl logs logging-pod | grep -o 'FLAG_LOG_MESSAGE_[0-9]\+' > ~/k8s-pods/flag.txt
   ```
4. Confirm `~/k8s-pods/flag.txt` contains the flag:
   ```bash
   cat ~/k8s-pods/flag.txt
   ```
5. Check your solution:
   ```bash
   tld check
   ```
