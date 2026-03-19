# Day 53 – Kubernetes Services

## Why Services?

Every Pod gets its own IP address. But there are two problems:
1. Pod IPs are **not stable** — when a Pod restarts or gets replaced, it gets a new IP
2. A Deployment runs **multiple Pods** — which IP do you connect to?

A Service solves both problems. It provides:
- A **stable IP and DNS name** that never changes
- **Load balancing** across all Pods that match its selector

```
[Client] --> [Service (stable IP)] --> [Pod 1]
                                   --> [Pod 2]
                                   --> [Pod 3]
```

---

## Challenge Tasks

### Task 1: Deploy the Application
First, create a Deployment that you will expose with Services. Create `app-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  labels:
    app: web-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
```

```bash
kubectl apply -f app-deployment.yaml
kubectl get pods -o wide
```

Note the individual Pod IPs. These will change if pods restart — that is the problem Services fix.

**Verify:** Are all 3 pods running? Note down their IP addresses.

<img width="775" height="78" alt="image" src="https://github.com/user-attachments/assets/91a45cdb-89da-4799-a0a0-7a9e3a4af9df" />


---

### Task 2: ClusterIP Service (Internal Access)
ClusterIP is the default Service type. It gives your Pods a stable internal IP that is only reachable from within the cluster.

Create `clusterip-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app-clusterip
spec:
  type: ClusterIP
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
```

Key fields:
- `selector.app: web-app` — this Service routes traffic to all Pods with the label `app: web-app`
- `port: 80` — the port the Service listens on
- `targetPort: 80` — the port on the Pod to forward traffic to

```bash
kubectl apply -f clusterip-service.yaml
kubectl get services
```
<img width="437" height="80" alt="image" src="https://github.com/user-attachments/assets/ce99da38-8115-483c-8cc7-0a3e5132c547" />

You should see `web-app-clusterip` with a CLUSTER-IP address. This IP is stable — it will not change even if Pods restart.

Now test it from inside the cluster:
```bash
# Run a temporary pod to test connectivity
kubectl run test-client --image=busybox:latest --rm -it --restart=Never -- sh

# Inside the test pod, run:
wget -qO- http://web-app-clusterip
exit
```

<img width="653" height="377" alt="image" src="https://github.com/user-attachments/assets/70225228-ce79-4138-b5d7-2673bdad730c" />

You should see the Nginx welcome page. The Service load-balanced your request to one of the 3 Pods.

**Verify:** Does the Service respond? Try running the wget command multiple times — the Service distributes traffic across all healthy Pods.
Yes, when we tried it multiple times, it was fast and received proper response.

---

### Task 3: Discover Services with DNS
Kubernetes has a built-in DNS server. Every Service gets a DNS entry automatically:

```
<service-name>.<namespace>.svc.cluster.local
```

Test this:
```bash
kubectl run dns-test --image=busybox:latest --rm -it --restart=Never -- sh

# Inside the pod:
# Short name (works within the same namespace)
wget -qO- http://web-app-clusterip

# Full DNS name
wget -qO- http://web-app-clusterip.default.svc.cluster.local

<img width="427" height="312" alt="image" src="https://github.com/user-attachments/assets/bb4c90f9-a552-46c0-820d-86e5f9fce5c9" />


# Look up the DNS entry
nslookup web-app-clusterip
exit
```

Both the short name and the full DNS name resolve to the same ClusterIP. In practice, you use the short name when communicating within the same namespace and the full name when reaching across namespaces.


**Verify:** What IP does `nslookup` return? Does it match the CLUSTER-IP from `kubectl get services`?

<img width="454" height="228" alt="image" src="https://github.com/user-attachments/assets/bb41de57-b49f-41ed-abd6-fe8eb02f7425" />

Yes, it matches with ip in kubectl get services


---

### Task 4: NodePort Service (External Access via Node)
A NodePort Service exposes your application on a port on every node in the cluster. This lets you access the Service from outside the cluster.

Create `nodeport-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app-nodeport
spec:
  type: NodePort
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
```

- `nodePort: 30080` — the port opened on every node (must be in range 30000-32767)
- Traffic flow: `<NodeIP>:30080` -> Service -> Pod:80

```bash
kubectl apply -f nodeport-service.yaml
kubectl get services
```

Access the service:
```bash
# If using Minikube
minikube service web-app-nodeport --url

# If using Kind, get the node IP first
kubectl get nodes -o wide
# Then curl <node-internal-ip>:30080

# If using Docker Desktop
curl http://localhost:30080
```

**Verify:** Can you see the Nginx welcome page from your browser or terminal using the NodePort?

No it is not working from browser or terminal using node-internalip:30092 thought is working from temp pod inside node.
I guess, docker in kind has internal networking which is not exposed to external world via above node-port process.

**Works** This an alternative I followed and worked:
- Create cluster with control plan portmapping like
```bash
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: nginx-cluster

nodes:
  - role: control-plane
    image: kindest/node:v1.35.1
    extraPortMappings:
      - containerPort: 30080  # This must match your Service's nodePort
        hostPort: 30080       # This is the port you will use on Windows
        listenAddress: "0.0.0.0"
        protocol: TCP
  - role: worker
    image: kindest/node:v1.35.1
  - role: worker
    image: kindest/node:v1.35.1
```
- Create app deployment like:
```bash
kind: Deployment
apiVersion: apps/v1
metadata:
    name: web-app-deployment
    labels:
        apps: web-apps
        environment: production
        team: web-apps
spec:
    replicas: 3
    selector:
        matchLabels:
            apps: web-apps
    template:
        metadata:
            labels:
                apps: web-apps            
        spec:    
            containers:
              - name: web-app-container
                image: nginx:1.25.0
                ports:
                  - containerPort: 80
```
- Create node-port service like:
```bash
apiVersion: v1
kind: Service
metadata:
  name: web-app-nodeport
spec:
  type: NodePort
  selector:
    apps: web-apps
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
```
**verify**
- terminal: curl http://localhost:30080
- browser: http://localhost:30080

---

### Task 5: LoadBalancer Service (Cloud External Access)
In a cloud environment (AWS, GCP, Azure), a LoadBalancer Service provisions a real external load balancer that routes traffic to your nodes.

Create `loadbalancer-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app-loadbalancer
spec:
  type: LoadBalancer
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
```

```bash
kubectl apply -f loadbalancer-service.yaml
kubectl get services
```

On a local cluster (Minikube, Kind, Docker Desktop), the EXTERNAL-IP will show `<pending>` because there is no cloud provider to create a real load balancer. This is expected.

If you are using Minikube:
```bash
# Minikube can simulate a LoadBalancer
minikube tunnel
# In another terminal, check again:
kubectl get services
```

In a real cloud cluster, the EXTERNAL-IP would be a public IP address or hostname provisioned by the cloud provider.

**Verify:** What does the EXTERNAL-IP column show? Why is it `<pending>` on a local cluster?
<img width="496" height="65" alt="image" src="https://github.com/user-attachments/assets/43b780fb-01a3-4d02-b842-12a5d456cf71" />
- Yes, external ip is in pending on my local running cluster and service.
- 
---

### Task 6: Understand the Service Types Side by Side
Check all three services:

```bash
kubectl get services -o wide
```
<img width="577" height="79" alt="image" src="https://github.com/user-attachments/assets/ebbf0286-748f-45fa-b5f6-26cf18367017" />

Compare them:

| Type | Accessible From | Use Case |
|------|----------------|----------|
| ClusterIP | Inside the cluster only | Internal communication between services |
| NodePort | Outside via `<NodeIP>:<NodePort>` | Development, testing, direct node access |
| LoadBalancer | Outside via cloud load balancer | Production traffic in cloud environments |

Each type builds on the previous one:
- LoadBalancer creates a NodePort, which creates a ClusterIP
- So a LoadBalancer service also has a ClusterIP and a NodePort

Verify this:
```bash
kubectl describe service web-app-loadbalancer
```
<img width="496" height="248" alt="image" src="https://github.com/user-attachments/assets/9950d441-288d-4fe4-a4fa-e2281325d172" />


You should see all three: a ClusterIP, a NodePort, and the LoadBalancer configuration.

**Verify:** Does the LoadBalancer service also have a ClusterIP and NodePort assigned?
- Yes, it has both clusterip and nodeport assigned.
  
---

### Task 7: Clean Up
```bash
kubectl delete -f app-deployment.yaml
kubectl delete -f clusterip-service.yaml
kubectl delete -f nodeport-service.yaml
kubectl delete -f loadbalancer-service.yaml

kubectl get pods
kubectl get services
kubectl get all
```

Only the built-in `kubernetes` service in the default namespace should remain.

**Verify:** Is everything cleaned up?
<img width="394" height="25" alt="image" src="https://github.com/user-attachments/assets/3874aa69-04ac-434e-aa81-ecf7da51aec5" />

---

## Hints
- `selector` in a Service must match `labels` on the Pods — if they do not match, the Service routes traffic to nothing
- `kubectl get endpoints <service-name>` shows which Pod IPs a Service is currently routing to
- `port` is what the Service listens on; `targetPort` is what the Pod listens on — they do not have to be the same number
- NodePort range is 30000-32767; if you do not specify `nodePort`, Kubernetes picks one automatically
- Use `kubectl describe service <name>` to see the full configuration including Endpoints
- `kubectl get services -o wide` shows the selector each service uses
- To test ClusterIP services, you must test from inside the cluster (use a temporary pod)

---

