# Day 30 – Docker Images & Container Lifecycle

## Task
- Learn the relationship between images and containers
 Images are the source of truth. They contain the OS, your code, and dependencies. They never change.

 Containers are instances. You can start ten different containers from the same single image; they each get their own tiny "scratchpad" (writable layer) to store changes while they run.

- Understand image layers and caching

  Docker images are built like a stack of transparent pancakes. Every command in a Dockerfile (like RUN or COPY) creates a new Layer
  Layering: Only the differences between layers are stored. This is why if you have 10 images based on ubuntu, they all share the same base layers on your disk—saving massive amounts of space.
  Caching: When you rebuild an image, Docker checks if each layer has changed. If the command and the files it touches are identical, Docker skips the work and uses the "Cached" layer.
    Pro Tip: Always put your COPY package.json and npm install before COPY . (your source code). This ensures your dependencies stay cached even when you change your code. Read more on Docker Layer Caching.

- Master the full container lifecycle
  Created: The environment is prepped (docker create), but the process hasn't started.(Only container)
  Running: The main process (PID 1) is active (docker start or run).(Only container)
  Paused: The process is suspended in memory (docker pause).(only container)
  Exited/Stopped: The process finished or was killed (docker stop). The container still exists on disk, and you can see its logs.
  Removed: The container and its writable layer are deleted forever (docker rm (for container)), (docker rmi (for image))

## Challenge Tasks

### Task 1: Docker Images
1. Pull the `nginx`, `ubuntu`, and `alpine` images from Docker Hub
   - docker login -u shreyansh019 using PAT (personal access token)
   or password
   - docker pull image_name (to pull it from hub)
     
   <img width="579" height="211" alt="image" src="https://github.com/user-attachments/assets/c7103873-59dd-4726-ba59-1686030b1c12" />

2. List all images on your machine — note the sizes

   <img width="458" height="103" alt="image" src="https://github.com/user-attachments/assets/05be9a4e-f0c0-49d9-9b8d-5cf6237658cf" />



3. Compare `ubuntu` vs `alpine` — why is one much smaller?
   
Musl libc instead of glibc: Ubuntu uses the GNU C Library (glibc), which is feature-rich but large. Alpine uses musl libc, which is a fraction of the size and prioritizes simplicity over broad legacy support.
BusyBox: Instead of hundreds of individual utility files (like ls, grep, sed), Alpine uses BusyBox, a single small executable that provides all these core functions in one place.
Zero Bloat: Ubuntu includes many libraries and utilities by default to ensure "it just works". Alpine includes nothing extra; if you need a library, you must manually add it

Compare :- this functionality is part of Docker Scout, Docker's native security and analysis tool.

curl scout to install pluging using command:

curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh | sh -s --

docker scout compare image_1 --to image_2


4. Inspect an image — what information can you see?

   docker image inspect image_id
   it gives version and all layer information of image i.e.image’s configuration and structure.

   docker inspect container_id
   it gives every technical details and in the format huge json array.

   

6. Remove an image you no longer need
   
    docker rmi image_id
    docker image rm image_id
---

### Task 2: Image Layers
1. Run `docker image history nginx` — what do you see?


2. Each line is a **layer**. Note how some layers show sizes and some show 0B


3. Write in your notes: What are layers and why does Docker use them?

---

### Task 3: Container Lifecycle
Practice the full lifecycle on one container:
1. **Create** a container (without starting it)
2. **Start** the container
3. **Pause** it and check status
4. **Unpause** it
5. **Stop** it
6. **Restart** it
7. **Kill** it
8. **Remove** it

Check `docker ps -a` after each step — observe the state changes.

---

### Task 4: Working with Running Containers
1. Run an Nginx container in detached mode
2. View its **logs**
3. View **real-time logs** (follow mode)
4. **Exec** into the container and look around the filesystem
5. Run a single command inside the container without entering it
6. **Inspect** the container — find its IP address, port mappings, and mounts

---

### Task 5: Cleanup
1. Stop all running containers in one command
2. Remove all stopped containers in one command
3. Remove unused images
4. Check how much disk space Docker is using

