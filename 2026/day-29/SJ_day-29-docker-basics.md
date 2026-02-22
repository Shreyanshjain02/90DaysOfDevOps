# Day 29 – Introduction to Docker

What is Virtualization and docker?
- The fundamental difference is that virtual machines (VMs) virtualize the hardware, running a complete guest operating system (OS) on top of a hypervisor, while Docker containers virtualize the OS, sharing the host system's kernel.
- Example:- Row houses vs Apartment.
In row house, Each row house has its own amenities(Pool,Parking,Gym,24x7 electricity etc) and and owner have to manage all of those.but in apartment you share it society whenever you need to use it.
Similarly,in virtualization we need to replicate local environment on client to avoid OS mismatch ,dependencies etc.To handle this smoothly we use hypervisor engine which runs any OS on existing VM.Now there are two types of hypervisor (Type 1 (bare-metal)and type2 (virtual box).

Explanation:-
- Virtual Machine (VM):
What it is: An emulation of a physical computer.
Purpose: Runs guest operating systems (e.g., Linux inside Windows) independently.
Key Aspect: Provides isolation, portability, and resource optimization.
- Hypervisor:
Type 1 (Bare-Metal): Installs directly on the hardware. High performance, used in servers (e.g., Microsoft Hyper-V).
Type 2 (Hosted): Installs as software on an OS. Easier to use, lower performance (e.g., VirtualBox).
- VirtualBox:
Strengths: Free, open-source, user-friendly, and runs on Windows, macOS, and Linux.
Best for: Developers, testers, and personal use needing to run multiple operating systems on one desktop.
Weakness: Lower performance compared to Type 1 due to host OS overhead

As virtualization uses lots of resources from main environment. It has drawback:
  1. Costly
  2. slow (performance issue)
  3. overloading and utilization of resources
  4. single point of failure.
  5. Security
which over-comed by concept of containerization(docker...)
## Challenge Tasks

### Task 1: What is Docker?
Research and write short notes on:
- What is a container and why do we need them? (Answered above)
- Containers vs Virtual Machines — what's the real difference?(Answered above)
- What is the Docker architecture? (daemon, client, images, containers, registry)
The main components of Docker are:
- Docker Engine: The core technology that creates and manages containers. It is a client-server application with three parts:
   - Docker Daemon (dockerd): A persistent background process that runs on the host machine and manages Docker objects like images, containers, networks, and volumes. It listens for requests from the Docker client via a REST API.
   - Docker Client (docker CLI): The primary command-line interface (CLI) that users interact with. It sends commands (like docker build or docker run) to the Docker Daemon.
   - REST API: An interface that specifies how the client and daemon communicate, typically over a UNIX socket or a network interface.
- Docker Images: Read-only templates with instructions for creating a Docker container. An image contains the application code, runtime, libraries, and dependencies needed to run the application. They are built from a plain text file called a Dockerfile.
- Docker Containers: A runnable instance of a Docker image. It is an isolated environment that shares the host operating system's kernel but has its own filesystem, network stack, and process space.
- Docker Registries: Centralized repositories for storing and distributing Docker images. The most well-known public registry is Docker Hub, which contains a vast collection of official and user-contributed images.
- Docker Compose: A tool that simplifies the management of multi-container applications. It uses a single YAML file to define and run an entire application stack with a single command (e.g., docker-compose up).
- Docker Networking & Storage (Volumes): Docker provides networking capabilities to allow containers to communicate with each other and the host, and uses volumes to persist data outside the container's lifecycle, ensuring data is not lost when a container is stopped or removed.
- Docker Swarm (Orchestration): Docker's native tool for clustering and orchestrating Docker hosts, managing many containers across multiple machines. For large-scale enterprise deployments, it has largely been superseded by Kubernetes, an industry-standard open-source platform.

Draw or describe the Docker architecture in your own words.

<img width="308" height="332" alt="image" src="https://github.com/user-attachments/assets/0e657c51-3c76-484c-b9bd-0f06694f924f" />

---

### Task 2: Install Docker
1. Install Docker on your machine (or use a cloud instance)
   
   - linux:-
     sudo apt-get update (to update apt)
     sudo apt-get upgrade (to install all updates)
     sudo apt-get install docker.io (to start installing docker engine)
   - Windows:-
     Go to browser https://www.docker.com/products/docker-desktop/ download and
     Install...
     
2. Verify the installation
   
   docker --version (Check version installed)
   docker ps (gives you list of running container)
   
3. Run the `hello-world` container
   docker run -it hello-world (It will pull image from dockerhub and install hello-world container )
   Note:- the hello-world image contains only a single static binary that prints text and then finishes its process. Since there is no long-running process (like a shell or a service), the container stops as soon as it completes that task
   
4. Read the output carefully — it explains what just happened
  To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal
---

### Task 3: Run Real Containers
1. Run an **Nginx** container and access it in your browser

   docker run -itd -p 80:80 nginx
   
2. Run an **Ubuntu** container in interactive mode — explore it like a mini Linux machine

   docker run -itd ubuntu ( Install ubuntu conatainer)
   docker start containerid
   docker exec -it containerid bash (go into ubuntu bash)
   
3. List all running containers

   docker ps

4. List all containers (including stopped ones)

   docker ps -a
   
5. Stop and remove a container

   docker stop containerid
   docker rm containerid

---

### Task 4: Explore
1. Run a container in **detached mode** — what's different?
   with flag -d (we starting any service/container in background without disturbing current terminal session)
   without flag -d (we start service/container on current terminal session ).

2. Give a container a custom **name**

   docker run -itd --name
   example:- docker run -itd --name my_ubuntu_container ubuntu

3. Map a **port** from the container to your host

   docker run -it -p 80:80 nginx

4. Check **logs** of a running container

   docker logs containerid

5. Run a command **inside** a running container

    docker exec -it containerid bash

---
