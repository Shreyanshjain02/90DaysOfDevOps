
# Day 31 – Dockerfile: Build Your Own Images

## Challenge Tasks

### Task 1: Your First Dockerfile
1. Create a folder called `my-first-image`

2. Inside it, create a `Dockerfile` that:
   - Uses `ubuntu` as the base image
   - Installs `curl`
   - Sets a default command to print `"Hello from my custom image!"`
3. Build the image and tag it `my-ubuntu:v1`
4. Run a container from your image

**Verify:** The message prints on `docker run`

<img width="442" height="82" alt="image" src="https://github.com/user-attachments/assets/c5792fdf-00da-4e3e-a857-99d8034937ee" />

<img width="894" height="55" alt="image" src="https://github.com/user-attachments/assets/69e5c0e9-bd3f-45a1-be98-f5c28c8fdc71" />

<img width="925" height="265" alt="image" src="https://github.com/user-attachments/assets/ffd3d60c-7c53-40fe-b8a5-e08f17f238ab" />

---

### Task 2: Dockerfile Instructions
Create a new Dockerfile that uses **all** of these instructions:
- `FROM` — base image
- `RUN` — execute commands during build
- `COPY` — copy files from host to image
- `WORKDIR` — set working directory
- `EXPOSE` — document the port
- `CMD` — default command

Build and run it. Understand what each line does.

<img width="600" height="256" alt="image" src="https://github.com/user-attachments/assets/cfc10865-e212-4b3e-a970-9184f44473cf" />

<img width="499" height="101" alt="image" src="https://github.com/user-attachments/assets/c367e7eb-6d6b-402f-abd4-b3cae807b47b" />

<img width="697" height="128" alt="image" src="https://github.com/user-attachments/assets/23f583d0-65e8-402b-840c-5008608438d0" />

Above, shows all the file are copied as it in WORKDIR we create on container.

---

### Task 3: CMD vs ENTRYPOINT
1. Create an image with `CMD ["echo", "hello"]` — run it, then run it with a custom command. What happens?
2. Create an image with `ENTRYPOINT ["echo"]` — run it, then run it with additional arguments. What happens?
3. Write in your notes: When would you use CMD vs ENTRYPOINT?

1.1 
<img width="659" height="26" alt="image" src="https://github.com/user-attachments/assets/c077c086-7fde-4e4d-ab04-7ebd9caba9e8" />
<img width="424" height="75" alt="image" src="https://github.com/user-attachments/assets/f6b4c3a2-9b27-4f58-87dd-8b43d781bf73" />

1.2 
<img width="870" height="26" alt="image" src="https://github.com/user-attachments/assets/8b14753f-640b-4bd4-8278-dd80c70123f0" />
<img width="944" height="254" alt="image" src="https://github.com/user-attachments/assets/99f54729-f7f4-4639-951e-bb2a84b5b739" />

With CMD, custom command overwrites CMD command.

2.1 
<img width="493" height="76" alt="image" src="https://github.com/user-attachments/assets/cd3aeb91-4579-48f6-bfbb-ecb3935aa1b9" />
<img width="691" height="230" alt="image" src="https://github.com/user-attachments/assets/05f97f2d-557e-4cd0-9382-bf196f39d318" />
2.2
<img width="816" height="104" alt="image" src="https://github.com/user-attachments/assets/c949cb6d-3d19-4b3e-b577-484748e88bd4" />

With ENTRYPOINT, custom command appended with  ENTRYPOINT command.

---

### Task 4: Build a Simple Web App Image
1. Create a small static HTML file (`index.html`) with any content
2. Write a Dockerfile that:
   - Uses `nginx:alpine` as base
   - Copies your `index.html` to the Nginx web directory
3. Build and tag it `my-website:v1`
4. Run it with port mapping and access it in your browser

<img width="598" height="202" alt="image" src="https://github.com/user-attachments/assets/aacb67b8-4d54-4d5a-9846-e2d7a937ede2" />

keep index.html file with Dockerfile, when image is build it will copied-replace main nginx index.html file

<img width="353" height="70" alt="image" src="https://github.com/user-attachments/assets/05331bf8-252b-41c0-8554-0d74a8e2978c" />


<img width="849" height="295" alt="image" src="https://github.com/user-attachments/assets/2b399d36-75b1-409b-8edf-3b040a4bda62" />


<img width="956" height="175" alt="image" src="https://github.com/user-attachments/assets/1089366d-6d59-4bc4-b363-47b12df35283" />


---

### Task 5: .dockerignore
1. Create a `.dockerignore` file in one of your project folders
2. Add entries for: `node_modules`, `.git`, `*.md`, `.env`
3. Build the image — verify that ignored files are not included

created multiple files:

<img width="437" height="112" alt="image" src="https://github.com/user-attachments/assets/b4305023-9206-4c92-9dd9-6565bc5cfd4b" />

added filed in .dockerignore

<img width="355" height="90" alt="image" src="https://github.com/user-attachments/assets/998cf50b-fb0e-4744-9ec0-5074cb6a8d00" />

build image as usual and run container

### voila!!

ignore files are not copied

<img width="577" height="130" alt="image" src="https://github.com/user-attachments/assets/8dd4c064-7208-49fa-89da-1c2c09d23d4e" />


---

### Task 6: Build Optimization
1. Build an image, then change one line and rebuild — notice how Docker uses **cache**

   Yes, first build is slower compared to other builds from same dockerfile.

2. Reorder your Dockerfile so that frequently changing lines come **last**

   Reordering, does impact build speed it is similar to first build.

3. Write in your notes: Why does layer order matter for build speed?
   
   Docker's layer caching mechanism is a core feature that accelerates image builds by reusing unchanged, read-only layers from previous builds instead of rebuilding them from scratch. Each instruction in a Dockerfile (like FROM, RUN, COPY, or ADD) creates a new, immutable layer.

   Layering/order is very important if it is disturbed or changed than build time will be similar to first build from same dockerfile.as we confused system the order of execution and it will re-cache new order.

---

## Hints
- Build: `docker build -t name:tag .`
- The `.` at the end is the build context
- `COPY . .` copies everything from host to container
- Nginx serves files from `/usr/share/nginx/html/`

---
