## Task
You will pick a running process/service on your system and:

# Day 05 – Linux Troubleshooting Drill: 

To pick a running service used:-

systemctl list-units --type=service --state=running

**OR**

ps aux

**OR**

top   (To get top cpu or memory consuming process or service)

<img width="956" height="175" alt="image" src="https://github.com/user-attachments/assets/15ceab3b-8cbd-49f0-a3ab-35b61b8916dc" />

**OR**

pidstat

---
  
**CPU**

<img width="940" height="321" alt="image" src="https://github.com/user-attachments/assets/75d51228-76ac-4da4-af3f-4eeda257b06f" />

**MEM**

<img width="655" height="44" alt="image" src="https://github.com/user-attachments/assets/c2152b1f-d94b-4896-b437-ed2fcb486b28" />

**DISK**

<img width="632" height="119" alt="image" src="https://github.com/user-attachments/assets/538d37c3-cd01-4850-b87f-db4277184135" />

**Network**

watch -n 1 "ip -s link"

**Traces**

journalctl -u containerd

Write a **mini runbook** describing what you did and what you’d do next if things were worse

This turns yesterday’s practice into a repeatable troubleshooting routine.

### What’s a runbook?
A **runbook** is a short, repeatable checklist you follow during an incident: the exact commands you run, what you observed, and the next actions if the issue persists. Keep it concise so you can reuse it under pressure.

Below is the runbook for senior SRE to debug an linux machine during incident.

**cat /proc/cpuinfo** (Confirm "Hardware Reality." Check processor count and flags (like aes or avx). If you have 2 cores but are running a 32-thread app, you've found your bottleneck.)

**uptime** (Check the Load Average. If the 1-min load is significantly higher than the 15-min load, the incident is active and escalating.m)

**Top** (Identify the "Villain" process. Press 1 to see per-CPU usage. Look at wa (I/O Wait); if it's high, the CPU is bored but the Disk is dying.)

**vmstat** 1 (Monitor Context Switching (cs) and Interrupts (in). If these are in the millions, your CPU is spending more time "swapping tasks" than actually doing work.)

**iostat** -xz 1 (Check %util for your disks. If a disk is at 100% utility but only moving 10MB/s, you have a failing drive or a slow EBS volume.)

**pidstate** -dl 1 (Link specific PIDs to Disk/CPU spikes. This tells you exactly which Docker container or Service is slamming the hardware.)


**nstat -z** ( Look for TcpExtListenOverflows. If > 0, your application's "waiting room" is full and it's dropping new customers.)

**ip -s link** (Check dropped and overrun. If dropped is climbing on eth0, the Kernel is overwhelmed and throwing packets away.)

**Sudo ss -ntp** (Inspect socket health)
  - watch -n 2 "sudo ss -ntp | awk '\$2 > 0 || \$3>0'" (This filters for "Stuck" connections. It only shows lines where Recv-Q (App is slow) or Send-Q (Network is slow) is greater than zero.)

**dmesg -T | tail -n 50** (Check for the OOM Killer (Out of Memory) or Hardware/Filesystem errors. If the kernel killed your app, top won't show it, but dmesg will.)

**journalctl -u [service_name] -f** (Follow the application logs in real-time. Hardware metrics tell you where it hurts; logs tell you why.)

---



## Guidelines
Follow these rules while creating your runbook:

- Run and record output for **at least 8 commands** (save snippets in your runbook)  
  - **Environment basics (2):** `uname -a`, `lsb_release -a` (or `cat /etc/os-release`)  
  - **Filesystem sanity (2):** create a throwaway folder and file, e.g., `mkdir /tmp/runbook-demo`, `cp /etc/hosts /tmp/runbook-demo/hosts-copy && ls -l /tmp/runbook-demo`  
  - **CPU / Memory (2):** `top`/`htop`/`ps -o pid,pcpu,pmem,comm -p <pid>`, `free -h`, `vm_stat` (mac)  
  - **Disk / IO (2):** `df -h`, `du -sh /var/log`, `iostat`/`vmstat`/`dstat`  
  - **Network (2):** `ss -tulpn`/`netstat -tulpn`, `curl -I <service-endpoint>`/`ping`  
  - **Logs (2):** `journalctl -u <service> -n 50`, `tail -n 50 /var/log/<file>.log`
- Choose **one target service/process** (e.g., `ssh`, `cron`, `docker`, your web app) and stick to it for the drill.
- For each command, add a 1–2 line note on what you observed (e.g., “CPU spikes to 80% when restarting”, “No recent errors in last 50 lines”).
- End with a **“If this worsens”** section listing 3 next steps you would take (ex: restart strategy, increase log verbosity, collect `strace`).
- Keep it concise and actionable (aim for ~1 page).

Suggested structure for `linux-troubleshooting-runbook.md`:
- Target service / process
- Snapshot: CPU & Memory
- Snapshot: Disk & IO
- Snapshot: Network
- Logs reviewed
- Quick findings
- If this worsens (next steps)



## Why This Matters for DevOps
Incidents rarely come with perfect clues. A fast, repeatable checklist saves minutes when services misbehave.

This drill builds:
- Habit of capturing evidence before acting
- Confidence reading resource signals (CPU, memory, disk, network)
- Log-first mindset before restarts or escalations

These habits reduce downtime and prevent guesswork in production.

---

