# Day 07 – Linux File System Hierarchy & Scenario-Based Practice

## Task
Today's goal is to **understand where things live in Linux** and **practice troubleshooting like a DevOps engineer**.

You will create notes covering:
- Linux File System Hierarchy (the most important directories)
- Practice solving real-world scenarios step by step

This consolidates your Linux fundamentals and prepares you for real-world troubleshooting.
---
## Guidelines

### Part 1: Linux File System Hierarchy (30 minutes)

Document the purpose of these **essential** directories:

<img width="296" height="369" alt="image" src="https://github.com/user-attachments/assets/8c809789-32d9-4e00-8f45-1ba97d01e723" />


**Core Directories (Must Know):**
-** `/` (root)** - The starting point of everything

- Everything in linux is either file or directory and all of this file and directory are directly or indirectly connect to root just like small plant (multiple branches but single origin or root). 

- **`/home`** - User home directories

<img width="434" height="50" alt="image" src="https://github.com/user-attachments/assets/c0ad7801-33fd-4d24-8f46-7aad6e6a4218" />

- It is just like desktop in windows. Each user has it own home profile 

**- `/root`** - Root user's home directory

- This is dedicated directory to root user. which can only be accessed by root user or sudo. 
  
**- `/etc`** - Configuration files

- This directory has all configuration files
  
- `/var/log` - Log files (very important for DevOps!)
- `/tmp` - Temporary files

**Additional Directories (Good to Know):**
**- `/bin`** - Essential command binaries

- Bin is an directory which has all the essential tools by-default it has mkdir,chmod,cp,rm,vim,pwd etc. Also "essential" commands needed to boot the system or repair it 

**- `/usr/bin`** - User command binaries

- /usr/bin is similar to root bin but it has all the binaries related to user and program user installed or setups. Also "non-essential" user programs and distribution-managed applications that could wait until the system was fully booted

**- `/opt` **- Optional/third-party applications

directory is often where software you compile (that is, you build yourself from source code and do not install from your distribution repositories) sometimes lands. Applications will end up in the /opt/bin directory and libraries in the /opt/lib directory.

For each directory:
- Write 1-2 lines explaining what it contains
- Run `ls -l <directory>` and note 1-2 files/folders you see
- Write one sentence: "I would use this when..."

<img width="559" height="317" alt="image" src="https://github.com/user-attachments/assets/c5f98ace-e6d2-421a-afd6-c223953be294" />


**Hands-on task:**
```bash
# Find the largest log file in /var/log
du -sh /var/log/* 2>/dev/null | sort -h | tail -5



# Look at a config file in /etc
cat /etc/hostname

# Check your home directory
ls -la ~
```

<img width="838" height="88" alt="image" src="https://github.com/user-attachments/assets/aab6c130-7abe-4c9d-b784-02c939ee60bc" />

Gives you  

---

### Part 2: Scenario-Based Practice (40 minutes)

**Important:** Focus on understanding the **troubleshooting flow**, not memorizing commands. Use the hints!

---

#### SOLVED EXAMPLE: Understanding How to Approach Scenarios

**Example Scenario: Check if a service is running**
```
Question: How do you check if the 'nginx' service is running?
```

**My Solution (Step by step):**

**Step 1:** Check service status
```bash
systemctl status nginx
```
**Why this command?** It shows if the service is active, failed, or stopped

**Step 2:** If service is not found, list all services
```bash
systemctl list-units --type=service
```
**Why this command?** To see what services exist on the system

**Step 3:** Check if service is enabled on boot
```bash
systemctl is-enabled nginx
```
**Why this command?** To know if it will start automatically after reboot

**What I learned:** Always check status first, then investigate based on what you see.

---

Now try these scenarios yourself:

---

**Scenario 1: Service Not Starting** 
```
A web application service called 'myapp' failed to start after a server reboot.
What commands would you run to diagnose the issue?
Write at least 4 commands in order.
```

**Hint:**
- First check: Is the service running or failed?
- Then check: What do the logs say?
- Finally check: Is it enabled to start on boot?

**Commands to explore:** `systemctl status myapp`, `systemctl is-enabled myapp`, `journalctl -u myapp -n 50`

**Resource:** Review Day 04 (Process and Services practice)

**Template for your answer:**
```
Step 1: [command]
Why: [one line explanation]

Step 2: [command]
Why: [one line explanation]

...
```

---

**Scenario 2: High CPU Usage** 
```
Your manager reports that the application server is slow.
You SSH into the server. What commands would you run to identify
which process is using high CPU?
```

**Hint:**
- Use a command that shows **live** CPU usage
- Look for processes sorted by CPU percentage
- Note the PID (Process ID) of the top process

**Commands to explore:** `top` (press 'q' to quit), `htop`, `ps aux --sort=-%cpu | head -10`

**Resource:** Review Day 05 (Troubleshooting Drill - CPU & Memory section)

---

**Scenario 3: Finding Service Logs** 
```
A developer asks: "Where are the logs for the 'docker' service?"
The service is managed by systemd.
What commands would you use?
```

**Hint:**
- systemd services → logs are in journald
- Command pattern: `journalctl -u <service-name>`
- Use -n flag to limit number of lines
- Use -f flag to follow logs in real-time (like tail -f)

**Commands to explore:**
```bash
# Check service status first
systemctl status ssh

# View last 50 lines of logs
journalctl -u ssh -n 50

# Follow logs in real-time
journalctl -u ssh -f
```

**Resource:** Review Day 04 (Process and Services - Log checks section)

---

**Scenario 4: File Permissions Issue** 
```
A script at /home/user/backup.sh is not executing.
When you run it: ./backup.sh
You get: "Permission denied"

What commands would you use to fix this?
```

**Hint:**
- First: Check what permissions the file has
- Understand: Files need 'x' (execute) permission to run
- Fix: Add execute permission with chmod

**Step-by-step solution structure:**
```
Step 1: Check current permissions
Command: ls -l /home/user/backup.sh
Look for: -rw-r--r-- (notice no 'x' = not executable)

Step 2: Add execute permission
Command: chmod +x /home/user/backup.sh

Step 3: Verify it worked
Command: ls -l /home/user/backup.sh
Look for: -rwxr-xr-x (notice 'x' = executable)

Step 4: Try running it
Command: ./backup.sh
```

**Resource:** Review Day 02 (File Permissions and Users Management)

---

## Why This Matters for DevOps
Understanding the file system is critical for:
- Knowing where to find logs, configs, and binaries
- Troubleshooting deployment issues
- Writing automation scripts that work across systems

Scenario-based practice prepares you for:
- Real production incidents
- DevOps interviews
- On-call troubleshooting under pressure

These are questions you **will** face in interviews and during real incidents.

---

## Submission
1. Fork this `90DaysOfDevOps` repository
2. Navigate to the `2026/day-07/` folder
3. Add your `day-07-linux-fs-and-scenarios.md` file
4. Commit and push your changes to your fork

---

## Learn in Public
Share your Day 07 progress on LinkedIn:

- Post 2–3 lines on what you learned about Linux file system
- Share one scenario you found challenging and how you solved it
- Optional: screenshot of your notes

Use hashtags:
```
#90DaysOfDevOps
#DevOpsKaJosh
#TrainWithShubham
```

Happy Learning
**TrainWithShubham**
