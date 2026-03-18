# Day 50 – Kubernetes Architecture and Cluster Setup

## Challenge Tasks

### Task 1: Recall the Kubernetes Story
Before touching a terminal, write down from memory:

1. Why was Kubernetes created? What problem does it solve that Docker alone cannot?

kubernetes was created to solve manual scaling and healing problem at google. 

2. Who created Kubernetes and what was it inspired by?

Initially,Google engineers developed borg. later it was donated to open source i.e cloud native computing foundation which renamed it to kubernetes.
so kubernetes is inspired by borg.

3. What does the name "Kubernetes" mean?

kubernetes is derived from greek word which means pilot of big ship which has containers.


---
### Task 2: Draw the Kubernetes Architecture
From memory, draw or describe the Kubernetes architecture. Your diagram should include:

<img width="835" height="322" alt="image" src="https://github.com/user-attachments/assets/a7bc5142-c287-48b0-a11d-3450644064d0" />


**Control Plane (Master Node):**
- API Server — the front door to the cluster, every command goes through it
- etcd — the database that stores all cluster state
- Scheduler — decides which node a new pod should run on
- Controller Manager — watches the cluster and makes sure the desired state matches reality

**Worker Node:**
- kubelet — the agent on each node that talks to the API server and manages pods
- kube-proxy — handles networking rules so pods can communicate
- Container Runtime — the engine that actually runs containers (containerd, CRI-O)

After drawing, verify your understanding:
- What happens when you run `kubectl apply -f pod.yaml`? Trace the request through each component.

 A pod is created with file reference pod.yml
 
<img width="670" height="83" alt="image" src="https://github.com/user-attachments/assets/9185e235-f19d-4803-b997-8c007c16bb6d" />

- What happens if the API server goes down?
Connection between control-plane(master node) will be broken with worker node. which can be a chaos and disturb the motive of kubernetes i.e auto scaling and healing.
Yes. While Kubernetes is built for High Availability (HA), the API server is the "Single Point of Truth." Without it, the cluster loses its "intelligence"—it can't scale, it can't heal, and it can't take orders.
Pro-tip: This is why in production, we run multiple API servers behind a Load Balancer so that if one fails, the others keep the cluster "thinking."

- What happens if a worker node goes down?
If worker node goes down, end user experience will be disturbed if it is single worker node in cluster then end-user will not see application hosted on this worker node or pods within this node. if it is multi-worker cluster then latency will be impacted.but here is the catch:
As kubernetes has built-in auto scaling and healing power.so if worker node goes down:
Detection phase: kubelet(heatbeat of node) will stop sending heatbeat to api server(control plane) after 40 sec api server will mark that node's status as unkown or notready.
Eviction Phase: Control plane will not immediatly remove or move pod if workernode is restarting. It will wait for 5 min conviction period.
 Healing phase: Once the 5-minute timeout expires, the Control Plane marks the Pods on the failed node for deletion.And scheduler initiate replacement pods on healthy node.if it is single node then it will be complete outrage till manually healed/recovered/replaced.

---

### Task 3: Install kubectl
`kubectl` is the CLI tool you will use to talk to your Kubernetes cluster.

Install it:
```bash
# macOS
brew install kubectl

# Linux (amd64)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Windows (with chocolatey)
choco install kubernetes-cli
```

Verify:
```bash
kubectl version --client
```
<img width="277" height="27" alt="image" src="https://github.com/user-attachments/assets/cd79691f-05c1-4cc1-8664-a5471fea046c" />

<img width="302" height="41" alt="image" src="https://github.com/user-attachments/assets/56b7e701-87e0-42ed-b02b-be35215e5d78" />


---

### Task 4: Set Up Your Local Cluster
Choose **one** of the following. Both give you a fully functional Kubernetes cluster on your machine.

**Option A: kind (Kubernetes in Docker)**
```bash
# Install kind
# macOS
brew install kind

# Linux
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Create a cluster
kind create cluster --name devops-cluster

# Verify
kubectl cluster-info

This gives you only details like ip and node name for recently created cluster 

kubectl get nodes

This gives you recently created nodes of cluster.
```
<img width="267" height="32" alt="image" src="https://github.com/user-attachments/assets/821124f7-c8a3-425b-abce-3ed80f370c96" />

<img width="529" height="288" alt="image" src="https://github.com/user-attachments/assets/7a607c93-a91b-4eae-861e-ff36521bb7b7" />


Write down: Which one did you choose and why?

KIND, As I already have basic knowledge and understanding of docker.

---

### Task 5: Explore Your Cluster
Now that your cluster is running, explore it:

```bash
# See cluster info
kubectl cluster-info
This gives you only details like ip and node name for recently created cluster 


# List all nodes
kubectl get nodes

This gives you node details like name,status,role,version for recently created cluster. not all past cluster and nodes.

# Get detailed info about your node
kubectl describe node <node-name>

This is very powerfull command which gives you all system related details of node

# List all namespaces
kubectl get namespaces

This gives you list of all namespaces and their status.

# See ALL pods running in the cluster (across all namespaces)
kubectl get pods -A
```
This gives you list of pods from recently created cluster from all namespaces

Look at the pods running in the `kube-system` namespace:
All the pods in kube-system namespace are default key pods like kube-proxy,etcd,scheduler,control manager, api server.

```bash
kubectl get pods -n kube-system
```

Yes, we see pods like `etcd`, `kube-apiserver`, `kube-scheduler`, `kube-controller-manager`, `coredns`, and `kube-proxy`. These are the architecture components you drew in Task 2 — running as pods inside the cluster.

**Verify:** Can you match each running pod in `kube-system` to a component in your architecture diagram?

But kubelet is missing.as it does not run as pod it is an systemd (daemon service)

---

### Task 6: Practice Cluster Lifecycle
Build muscle memory with cluster operations:

```bash
# Delete your cluster
kind delete cluster --name devops-cluster
# (or: minikube delete)

Done!

# Recreate it
kind create cluster --name devops-cluster
# (or: minikube start)

Done!

# Verify it is back
kubectl get nodes

<img width="430" height="73" alt="image" src="https://github.com/user-attachments/assets/b8cc8941-55f1-41a0-93c8-f35aa38b3bcf" />

Done!
```

Try these useful commands:
```bash
# Check which cluster kubectl is connected to
kubectl config current-context

Recently created cluster

# List all available contexts (clusters)
kubectl config get-contexts

This is good and helpfull command which gives all cluster not only recently created

# See the full kubeconfig
kubectl config view

A kubeconfig file is a YAML-formatted configuration file used by kubectl and other clients to authenticate and connect to Kubernetes clusters. It stores API server addresses, security credentials, and cluster-specific settings

<img width="316" height="244" alt="image" src="https://github.com/user-attachments/assets/70e457d0-12c1-4f75-b426-1826e226c3a9" />


```

Write down: What is a kubeconfig? Where is it stored on your machine?

A kubeconfig file is a YAML-formatted configuration file used by kubectl and other clients to authenticate and connect to Kubernetes clusters. It stores API server addresses, security credentials, and cluster-specific settings

On windows it is located on C:\Users\sjn46\.kube.

---

## Hints
- kind requires Docker to be running (it creates clusters using containers)
- minikube can use Docker, VirtualBox, or other drivers
- The default kubeconfig file is at `~/.kube/config`
- `kubectl get pods -A` is short for `kubectl get pods --all-namespaces`
- If `kubectl` cannot connect, check if your cluster is running: `kind get clusters` or `minikube status`
- `-o wide` flag gives extra details: `kubectl get nodes -o wide`

---


