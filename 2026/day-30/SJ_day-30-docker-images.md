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
   it gives version information of image i.e.image’s configuration and structure.

   docker inspect container_id
   it gives every technical details and in the format huge json array.

   

6. Remove an image you no longer need
   
    docker rmi image_id
    docker image rm image_id
---

### Task 2: Image Layers
1. Run `docker image history nginx` — what do you see?

  docker history shows a concise line-by-line build history of an image and its layers

2. Each line is a **layer**. Note how some layers show sizes and some show 0B

  Yes, some layer in docker image history has 0B size and some has greater than 0B size.
  Layer with greater than 0B size:-
    These represent actual filesystem changes, such as adding, modifying, or deleting files.
      RUN, COPY, ADD
  Layer with 0B size:-
    These layers are still part of the image's history and structure, but they do not add any actual disk space because they only involve configuration changes or the definition of metadata, rather than filesystem changes

    CMD,ENTRYPOINT, LABEL, EXPOSE, VOLUME,USER, ENV etc
 
3. Write in your notes: What are layers and why does Docker use them?

   Layers in docker image is like recipe instruction each layer and its order is important.
   Understand with cake recipe:-
    1. you take pateela
    2. add ingredients
    3. mix it well
    4. put in cake bowl
    5. bake it
    6. place all piece in correct order (cake base > cream >topings>candles)
    
    You place your recipe in Dockerfile to build an image from it.later used in container.

   <img width="765" height="405" alt="image" src="https://github.com/user-attachments/assets/9827ee09-251a-418a-a324-cd5832e8323e" />

<img width="899" height="211" alt="image" src="https://github.com/user-attachments/assets/18a72dac-528e-43ec-b130-a7b1148e6824" />

<img width="358" height="139" alt="image" src="https://github.com/user-attachments/assets/1f3f7f7d-8688-408c-bcfd-4c6672f64222" />


---

### Task 3: Container Lifecycle
Practice the full lifecycle on one container:
1. **Create** a container (without starting it)

<img width="910" height="73" alt="image" src="https://github.com/user-attachments/assets/3ae338df-dc08-41e5-b54a-c9cda6699a5e" />

2. **Start** the container

<img width="956" height="263" alt="image" src="https://github.com/user-attachments/assets/588c9f43-6da7-4e44-8b42-15e4370e5c66" />


3. **Pause** it and check status

<img width="956" height="176" alt="image" src="https://github.com/user-attachments/assets/5affeecb-7014-44a6-a54d-b0ccdb7a9490" />

4. **Unpause** it

<img width="959" height="181" alt="image" src="https://github.com/user-attachments/assets/09c9cff1-f63b-4d44-bf30-218ef797c1c8" />

5. **Stop** it

docker stop container_id

6. **Restart** it

docker restart container_id

7. **Kill** it
   
docker kill container_id

8. **Remove** it

docker rm container_id

Check `docker ps -a` after each step — observe the state changes.

---

### Task 4: Working with Running Containers
1. Run an Nginx container in detached mode

docker run -itd --name nginx_container -p 80:80 nginx

2. View its **logs**

docker logs nginx_container

3. View **real-time logs** (follow mode)

docker logs -f nginx_container

<img width="711" height="276" alt="image" src="https://github.com/user-attachments/assets/5e080a56-d382-4e3e-94a2-b50adf1c88fe" />


4. **Exec** into the container and look around the filesystem

<img width="762" height="282" alt="image" src="https://github.com/user-attachments/assets/0ac69443-0c9f-4d26-97c4-64994270328b" />


5. Run a single command inside the container without entering it

<img width="491" height="338" alt="image" src="https://github.com/user-attachments/assets/2950529a-071b-498d-a88e-d4d9f7c9757a" />


6. **Inspect** the container — find its IP address, port mappings, and mounts

docker inspect nginx_container

"State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 4863,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2026-02-23T18:01:05.549962563Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        
"Ports": {
                "80/tcp": [
                    {
                        "HostIp": "0.0.0.0",
                        "HostPort": "80"
                    },
                    {
                        "HostIp": "::",
                        "HostPort": "80"
                    }
                ]
            },
"Mounts": [],
"Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "MacAddress": "d2:2e:a0:b0:40:80",
                    "DriverOpts": null,
                    "GwPriority": 0,
                    "NetworkID": "f3f9e900f71820a4789c34908604ded941200e72c479bf477bf9b3d32abba148",
                    "EndpointID": "edf7932cf81b96bce8d0e568ffce410fb7004d8ca1b70024b2321a83cab0a4d9",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.3",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DNSNames": null
                }


---

### Task 5: Cleanup
1. Stop all running containers in one command

docker stop $(docker ps -aq) 

2. Remove all stopped containers in one command

<img width="533" height="156" alt="image" src="https://github.com/user-attachments/assets/ca1c0ba5-0afb-49d7-9390-135f36c2b49d" />


3. Remove unused images

docker images prune

<img width="691" height="255" alt="image" src="https://github.com/user-attachments/assets/48694bba-074a-43cb-8538-fe2be8429a0a" />


4. Check how much disk space Docker is using

   <img width="468" height="98" alt="image" src="https://github.com/user-attachments/assets/90025d84-e424-4887-905e-7f953314890c" />



 
