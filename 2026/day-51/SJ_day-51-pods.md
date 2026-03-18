# Day 51 – Kubernetes Manifests and Your First Pods

## The Anatomy of a Kubernetes Manifest

Every Kubernetes resource is defined using a YAML manifest with four required top-level fields:

```yaml
apiVersion: v1          # Which API version to use
kind: Pod               # What type of resource
metadata:               # Name, labels, namespace
  name: my-pod
  labels:
    app: my-app
spec:                   # The actual specification (what you want)
  containers:
  - name: my-container
    image: nginx:latest
    ports:
    - containerPort: 80
```

- `apiVersion` — tells Kubernetes which API group to use. For Pods, it is `v1`.
- `kind` — the resource type. Today it is `Pod`. Later you will use `Deployment`, `Service`, etc.
- `metadata` — the identity of your resource. `name` is required. `labels` are key-value pairs used for organization and selection.
- `spec` — the desired state. For a Pod, this means which containers to run, which images, which ports, etc.

---

## Challenge Tasks

### Task 1: Create Your First Pod (Nginx)
Create a file called `nginx-pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```

Apply it:
```bash
kubectl apply -f nginx-pod.yaml
```
Done!

Verify:
```bash
kubectl get pods
kubectl get pods -o wide

<img width="638" height="38" alt="image" src="https://github.com/user-attachments/assets/5b438ee3-ea46-4e84-8fc3-6f7a7a574808" />

```

Wait until the STATUS shows `Running`. Then explore:
```bash
# Detailed info about the pod
kubectl describe pod nginx-pod

<img width="538" height="284" alt="image" src="https://github.com/user-attachments/assets/441a2e06-5630-4571-beab-587f728f8f68" />


# Read the logs
kubectl logs nginx-pod

Show details logs of pod as:
docker enterpoint.sh configuration which start pod setup
Notice: image started,version os,status

<img width="595" height="364" alt="image" src="https://github.com/user-attachments/assets/84f258fb-e1cc-44e0-b68d-d01035e0ad81" />



# Get a shell inside the container
kubectl exec -it nginx-pod -- /bin/bash

# Inside the container, run:
curl localhost:80
exit
```

**Verify:** Can you see the Nginx welcome page when you curl from inside the pod?

<img width="482" height="315" alt="image" src="https://github.com/user-attachments/assets/ed3fd40f-4478-42f1-b5c0-dd4656fe3425" />

use method:-
**Long** method:-
kubectl get pods-o wide (get to know on which worker node pod is created)
docker exec -it node.name bash
curl 10.244.2.2:80 (ip of pod and port)
**Short** method:-
kubectl exec -it nginx-pod -- bash
curl http://localhost:80 

---

### Task 2: Create a Custom Pod (BusyBox)
Write a new manifest `busybox-pod.yaml` from scratch (do not copy-paste the nginx one):

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox-pod
  labels:
    app: busybox
    environment: dev
spec:
  containers:
  - name: busybox
    image: busybox:latest
    command: ["sh", "-c", "echo Hello from BusyBox && sleep 3600"]
```

Apply and verify:
```bash
kubectl apply -f busybox-pod.yaml
kubectl get pods
kubectl logs busybox-pod
```

Notice the `command` field — BusyBox does not run a long-lived server like Nginx. Without a command that keeps it running, the container would exit immediately and the pod would go into `CrashLoopBackOff`.

**Verify:** Can you see "Hello from BusyBox" in the logs?

Yes
<img width="680" height="107" alt="image" src="https://github.com/user-attachments/assets/4080a082-2f1b-48ba-8d29-46e9a3b3a2fa" />


---

### Task 3: Imperative vs Declarative
You have been using the declarative approach (writing YAML, then `kubectl apply`). Kubernetes also supports imperative commands:

```bash
# Create a pod without a YAML file
kubectl run redis-pod --image=redis:latest

# Check it
kubectl get pods
```
<img width="693" height="68" alt="image" src="https://github.com/user-attachments/assets/2104559d-c4bf-4cbf-b4ef-6d7dbbed62f3" />


Now extract the YAML that Kubernetes generated:
```bash
kubectl get pod redis-pod -o yaml
```
compare this output with your hand-written manifests. Notice how much extra metadata Kubernetes adds automatically (status, timestamps, uid, resource version).

Yes, it is huge and informative yml.

You can also use dry-run to generate YAML without creating anything:
```bash
kubectl run test-pod --image=nginx --dry-run=client -o yaml

apiVersion: v1
kind: Pod
metadata:
  labels:
    run: temp-pod
  name: temp-pod
spec:
  containers:
  - image: nginx:latest
    name: temp-pod
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```


This is a powerful trick — use it to quickly scaffold a manifest, then customize it.

**Verify:** Save the dry-run output to a file and compare its structure with your nginx-pod.yaml. What fields are the same? What is different?

yes, It is having some fields are common like apiVersion,Kind,meta,spec but it also has extra fields like dnspolicy, restartpolicy , status

---

### Task 4: Validate Before Applying
Before applying a manifest, you can validate it:

```bash
# Check if the YAML is valid without actually creating the resource
kubectl apply -f nginx-pod.yaml --dry-run=client


# Validate against the cluster's API (server-side validation)
kubectl apply -f nginx-pod.yaml --dry-run=server
```

Now intentionally break your YAML (remove the `image` field or add an invalid field) and run dry-run again. See what error you get.

For --dry-run=server, we receive error:kubectl apply -f pod.yml --dry-run=server
_The Pod "nginx-pod" is invalid: spec.containers[0].image: Required value_

but kubectl apply -f pod.yml --dry-run=client
pod/nginx-pod configured (dry run)

**Verify:** What error does Kubernetes give when the image field is missing?

---

### Task 5: Pod Labels and Filtering
Labels are how Kubernetes organizes and selects resources. You added labels in your manifests — now use them:

```bash
# List all pods with their labels
kubectl get pods --show-labels

<img width="497" height="68" alt="image" src="https://github.com/user-attachments/assets/580410f1-a8b7-40e0-b2a2-1d2008716348" />


# Filter pods by label
kubectl get pods -l app=nginx
kubectl get pods -l environment=dev

<img width="654" height="134" alt="image" src="https://github.com/user-attachments/assets/2e35fa0d-96ce-42ef-9b2f-d741a56fbc17" />


# Add a label to an existing pod
kubectl label pod nginx-pod environment=production

<img width="650" height="141" alt="image" src="https://github.com/user-attachments/assets/c543a19a-a7f3-412e-945d-42df3bdbf9ea" />


# Verify
kubectl get pods --show-labels

# Remove a label
kubectl label pod nginx-pod environment-
```
<img width="554" height="113" alt="image" src="https://github.com/user-attachments/assets/b48a9e6a-1ead-4dd7-b291-d14d6bc8e033" />

Write a manifest for a third pod with at least 3 labels (app, environment, team). Apply it and practice filtering.

---

### Task 6: Clean Up
Delete all the pods you created:

```bash
# Delete by name
kubectl delete pod nginx-pod
kubectl delete pod busybox-pod
kubectl delete pod redis-pod

done,

# Or delete using the manifest file
kubectl delete -f nginx-pod.yaml

# Verify everything is gone
kubectl get pods
```

Notice that when you delete a standalone Pod, it is gone forever. There is no controller to recreate it. This is why in production you use Deployments (coming on Day 52) instead of bare Pods.

---

## Hints
- `kubectl apply -f` creates or updates a resource from a file
- `kubectl get pods -o wide` shows the node and IP address
- `kubectl describe pod <name>` shows events — very useful for debugging
- `kubectl logs <name>` shows container stdout/stderr
- `kubectl exec -it <name> -- /bin/sh` gives you a shell (use `/bin/sh` if `/bin/bash` is not available)
- Labels are just key-value pairs — they have no meaning to Kubernetes itself, only to selectors
- `--dry-run=client -o yaml` is your best friend for generating manifest templates


