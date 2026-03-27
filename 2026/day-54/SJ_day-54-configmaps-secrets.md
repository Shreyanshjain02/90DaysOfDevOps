# Day 54 – Kubernetes ConfigMaps and Secrets

## Task
Your application needs configuration — database URLs, feature flags, API keys. Hardcoding these into container images means rebuilding every time a value changes. Kubernetes solves this with ConfigMaps for non-sensitive config and Secrets for sensitive data.

## Challenge Tasks

### Task 1: Create a ConfigMap from Literals
1. Use `kubectl create configmap` with `--from-literal` to create a ConfigMap called `app-config` with keys `APP_ENV=production`, `APP_DEBUG=false`, and `APP_PORT=8080`

command: kubectl create configmap app-config --from-literal APP_ENV=production --from-literal APP_DEBUG=false --from-literal APP_PORT=8080

2. Inspect it with `kubectl describe configmap app-config` and `kubectl get configmap app-config -o yaml`

<img width="701" height="341" alt="image" src="https://github.com/user-attachments/assets/72689c72-83a4-47be-889a-c0d0185a7a65" />

<img width="544" height="172" alt="image" src="https://github.com/user-attachments/assets/a1a093ce-fdaf-4920-bdfe-48ac5a8bca08" />

3. Notice the data is stored as plain text — no encoding, no encryption

All literal are stored as plain text no encoding or encryption

**Verify:** Can you see all three key-value pairs?

Yes

---

### Task 2: Create a ConfigMap from a File
1. Write a custom Nginx config file that adds a `/health` endpoint returning "healthy"

Created nginx.conf file with :-
    listen 80;
    server_name localhost;

    # Health check endpoint
    location /health {
        access_log off;
        add_header Content-Type text/plain;
        return 200 "healthy\n";
    }

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}

2. Create a ConfigMap from this file using `kubectl create configmap nginx-config --from-file=default.conf=<your-file>`

kubectl create configmap nginx-config --from-file=default.conf=nginx.conf

3. The key name (`default.conf`) becomes the filename when mounted into a Pod

**Verify:** Does `kubectl get configmap nginx-config -o yaml` show the file contents?

<img width="605" height="220" alt="image" src="https://github.com/user-attachments/assets/f810c949-2b07-4b4c-9da1-5146a4ddf52d" />

---

### Task 3: Use ConfigMaps in a Pod
1. Write a Pod manifest that uses `envFrom` with `configMapRef` to inject all keys from `app-config` as environment variables. Use a busybox container that prints the values.

<img width="385" height="237" alt="image" src="https://github.com/user-attachments/assets/b43dcb37-f12b-44e6-8a5f-b62ea0ffb163" />

2. Write a second Pod manifest that mounts `nginx-config` as a volume at `/etc/nginx/conf.d`. Use the nginx image.

<img width="630" height="313" alt="image" src="https://github.com/user-attachments/assets/4f1e5644-12ad-499c-89de-54fbeb79316a" />


3. Test that the mounted config works: `kubectl exec <pod> -- curl -s http://localhost/health`

<img width="641" height="29" alt="image" src="https://github.com/user-attachments/assets/8f2b4a4f-9d6c-4208-9e0d-b9f803df4d84" />

Use environment variables for simple key-value settings. Use volume mounts for full config files.

**Verify:** Does the `/health` endpoint respond?
yes
---

### Task 4: Create a Secret
1. Use `kubectl create secret generic db-credentials` with `--from-literal` to store `DB_USER=admin` and `DB_PASS=s3cureP@ssw0rd`

Command: kubectl create secret db-credentials --from-literal DB_USER=admin --from-literal DB_PASS=s3cureP@ssw0rd

2. Inspect with `kubectl get secret db-credentials -o yaml` — the values are base64-encoded

<img width="553" height="170" alt="image" src="https://github.com/user-attachments/assets/c71d579a-9622-4445-9ebd-aee00a97f723" />

3. Decode a value: `echo '<base64-value>' | base64 --decode`

In window, I used command:- 
 [Text.Encoding]::Utf8.GetString([Convert]::FromBase64String('czNjdXJlUEBzc3cwcmQ=')) 
 
<img width="775" height="31" alt="image" src="https://github.com/user-attachments/assets/0746a182-4810-4ddf-9e7d-5821b923e1ea" />


**base64 is encoding, not encryption.** Anyone with cluster access can decode Secrets. The real advantages are RBAC separation, tmpfs storage on nodes, and optional encryption at rest.

**Verify:** Can you decode the password back to plaintext?

Yes,

---

### Task 5: Use Secrets in a Pod
1. Write a Pod manifest that injects `DB_USER` as an environment variable using `secretKeyRef`

<img width="395" height="389" alt="image" src="https://github.com/user-attachments/assets/315f602b-3fd3-44e2-8dc2-26b05f526c70" />

2. In the same Pod, mount the entire `db-credentials` Secret as a volume at `/etc/db-credentials` with `readOnly: true`

kubectl describe pod secret-pod

<img width="572" height="227" alt="image" src="https://github.com/user-attachments/assets/3d21e2a9-8dfe-454f-8f79-8310934f810d" />

3. Verify: each Secret key becomes a file, and the content is the decoded plaintext value

yes, each key became file in location of pod

**Verify:** Are the mounted file values plaintext or base64?

It is in plain text.

<img width="622" height="162" alt="image" src="https://github.com/user-attachments/assets/44a5fdad-3db0-4c6a-b06a-b6a7c582d64d" />

---

### Task 6: Update a ConfigMap and Observe Propagation
1. Create a ConfigMap `live-config` with a key `message=hello`

<img width="647" height="226" alt="image" src="https://github.com/user-attachments/assets/2d47196c-407b-4f83-82a7-174a280020eb" />


2. Write a Pod that mounts this ConfigMap as a volume and reads the file in a loop every 5 seconds

<img width="620" height="265" alt="image" src="https://github.com/user-attachments/assets/f4710a29-7ce2-4aa6-bb28-81ef77c3aa62" />


<img width="459" height="172" alt="image" src="https://github.com/user-attachments/assets/92e1e228-17f7-477f-bb3a-ac01d9dbe67f" />


3. Update the ConfigMap: `kubectl patch configmap live-config --type merge -p '{"data":{"message":"world"}}'`

Used (In windows):- kubectl patch configmap live-config --type merge -p '{\"data\":{\"message\":\"world\"}}'

5. Wait 30-60 seconds — the volume-mounted value updates automatically

<img width="107" height="113" alt="image" src="https://github.com/user-attachments/assets/f4ba0eac-fb66-4c83-a817-35ff4434838a" />

<img width="547" height="180" alt="image" src="https://github.com/user-attachments/assets/07ffcb58-90b1-49d9-8206-17e86bab7004" />

6. Environment variables from earlier tasks do NOT update — they are set at pod startup only

**Verify:** Did the volume-mounted value change without a pod restart?
Yes, Values is updated without restart or re-creation of pod

---

<img width="555" height="256" alt="image" src="https://github.com/user-attachments/assets/d1908589-cca1-4ac1-b819-a4170453a719" />


### Task 7: Clean Up
Delete all pods, ConfigMaps, and Secrets you created.

Done

---

## Hints
- `--from-literal=KEY=VALUE` for command-line values, `--from-file=key=filename` for file contents
- `envFrom` injects all keys; `env` with `valueFrom` injects individual keys
- `echo -n 'value' | base64` — always use `-n` to avoid encoding a trailing newline
- Volume-mounted ConfigMaps/Secrets auto-update; environment variables do not
- `kubectl get secret <name> -o jsonpath='{.data.KEY}' | base64 --decode` extracts and decodes a value

---

## Documentation
Create `day-54-configmaps-secrets.md` with:
- What ConfigMaps and Secrets are and when to use each
- The difference between environment variables and volume mounts
- Why base64 is encoding, not encryption
- How ConfigMap updates propagate to volumes but not env vars

---
