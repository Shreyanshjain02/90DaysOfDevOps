# Day 02 – Linux Architecture, Processes, and systemd

## Task
Today’s goal is to **understand how Linux works under the hood**.

You will create a short note that explains:
- The core components of Linux (kernel, user space, init/systemd)
- How processes are created and managed
- What systemd does and why it matters

This is the foundation for all troubleshooting you will do as a DevOps engineer.


**Linux Fundamental**:-

  1. We started linux with its architecture.understand it with example of grocery store.
     **A**pplication , **S**hell, **K**ernel
     <img width="742" height="343" alt="Linux Architecture" src="https://github.com/user-attachments/assets/9a0d890a-03e2-41af-b85f-85f981a9f33e" />
  
  2. Shell Command:- It is interactive way to talk to kernel(store manager).
  
  3. Learn File system hierarchy -> To learn shell command in depth and remember it for longer period of time.
  
  4. Everything in linux is either file or directory.
  
  5. Many flavour of linux available in market:-
       Ubuntu - (We are using for practice)
       Fedora
       CentOS
       RHEL(Redhat).

  6. Root (/) is important in linux:-
     
     <img width="371" height="128" alt="image" src="https://github.com/user-attachments/assets/02c1d1d6-8978-422f-bc1f-5714d2023d62" />

  7. What systemd does and why it matters:-
     Systemd is a comprehensive suite of software designed to manage system services, processes, and configurations for Linux operating systems. It acts as the primary initialization system (init system) — starting as PID 1 (Process ID 1) during boot and managing the user space environment until the system shuts down.
     
     <img width="464" height="352" alt="image" src="https://github.com/user-attachments/assets/c5f95745-253e-4960-88c9-27b71caad4c8" />

     Everything start with a Process.And each process has unique ID (PID). And systemd is always PID1 
       <img width="433" height="56" alt="image" src="https://github.com/user-attachments/assets/746570a9-9b40-4027-81d3-e24e2b41f47a" />

  8. ps aux gives list of all process and its state. columne label explanation:-
     USER: The name of the user who owns and is running the process.
     PID: The Process ID, a unique numerical identifier assigned by the Linux kernel to each process.
     %CPU: The percentage of CPU time used by the process since it started.
     %MEM: The percentage of physical RAM (Resident Set Size) currently being used by the process.
     VSZ: Virtual Memory Size (in KiB). The total amount of virtual memory the process has access to, including swapped-out             memory and shared libraries.
     RSS: Resident Set Size (in KiB). The actual physical RAM the process is currently occupying.
     TTY: The terminal associated with the process. A ? indicates it is a background process or system daemon not attached to           any terminal.
     STAT: The current Process State code (e.g., R for running, S for sleeping, Z for zombie).
     START: The time or date when the process was originally started.
     TIME: The total cumulative CPU time used by the process since its creation (displayed in minutes and seconds).
     COMMAND: The full command line (including arguments and flags) used to start the process.

  9. Common State of process in linux:-
      R = Running
      S = Interruptible Sleep
      D = Uninterruptible Sleep
      I =  Idle
      T = Stopped/Traced
      Z =  Zombie
     Also there are other type of state in combination format, Please clear understand any PID state before using KILL command.
    command:-  Kill -9 (to kill process running on PID 9)
  
  10. Mostly used command for daily work:-
      pwd - path of working directory
      cd - change directory
      ps - show running process (one-time checks, or when you need to search for a specific process by name using)
      top -  show top running process (when you want to see which process is currently "eating" your CPU or memory right now) 
      man -  open linux manual to understand usage of any command.
      ls- list all files
      systemctl - To start,stop,status any application (The Manager)
      journalctl- to get logs of any running application (The log reader)

      systemd command you found useful:-
      1. systemd-analyze blame
      2. systemd-run


# 🐧 Linux Fundamentals: Under the Hood

## 🏗️ 1. Linux Architecture (The Grocery Store Analogy)
To understand how Linux works, imagine a **Grocery Store**:

*   **User Space (The Customer):** The applications (Browsers, IDEs, etc.) where we perform tasks.
*   **Shell (The Clerk):** The interactive layer. You tell the clerk what you need; they translate it for the manager.
*   **Kernel (The Store Manager):** The core that manages resources (CPU, Memory, Disk). It’s the only one that can actually talk to the hardware (The Warehouse).
*   **Hardware (The Warehouse):** The physical components where the "goods" (data) are stored.

---

## 📂 2. File System & Hierarchy
In Linux, **"Everything is a file or a directory."**
The hierarchy starts at the **Root (`/`)**. Understanding this tree is crucial for knowing where configurations, logs, and binaries live.


| Directory | Purpose |
| :--- | :--- |
| `/bin` | Essential command binaries (ls, cp). |
| `/etc` | System-wide configuration files. |
| `/var` | Variable data (Logs, Spools). |
| `/home` | Personal directories for users. |
| `/root` | Home directory for the Root user. |

---

## ⚙️ 3. Systemd: The Manager (PID 1)
**systemd** is the first process that starts when Linux boots up. It is assigned **PID 1**.

*   **What it does:** It initializes the user space and manages all system services (daemons).
*   **Why it matters:** It handles dependencies (e.g., "don't start the App until the Database is ready"), manages logs via `journalctl`, and monitors service health.

### Essential `systemctl` Commands:
*   `systemctl start <service>` – Start a service.
*   `systemctl stop <service>` – Stop a service.
*   `systemctl status <service>` – Check the health/logs of a service.
*   `systemd-analyze blame` – See which services are slowing down boot time.
*   `systemd-run` – Run a transient command in a scope/service unit.

---

## 🔄 4. Process Management
Every task in Linux runs as a **Process** with a unique **PID**.

### Monitoring Processes:
*   `ps aux`: A static snapshot of all running processes.
*   `top`: A real-time, dynamic view of CPU/Memory consumption.

### Process States (`STAT` column):

| Code | Meaning | SRE Note |
| :--- | :--- | :--- |
| **R** | Running | Actively using CPU. |
| **S** | Interruptible Sleep | Waiting for an event/input. |
| **D** | Uninterruptible Sleep | Usually waiting for Disk I/O (cannot be killed easily). |
| **Z** | Zombie | Finished but still in the process table. |
| **T** | Stopped | Suspended or being traced. |

> ⚠️ **Pro Tip:** Before using `kill -9 <PID>`, check the state. Killing a **'D'** state process might not work, and **'Z'** processes are already dead—you must kill their parent!

---

## 🛠️ 5. The DevOps Survival Toolkit (Commands)

| Command | Usage |
| :--- | :--- |
| `pwd` | Where am I? (Path of Working Directory). |
| `cd` | Move between directories. |
| `ls -la` | List files, including hidden ones and permissions. |
| `man <cmd>` | The "Manual"—use this to learn any command's flags. |
| `journalctl -u <svc>` | Read the logs for a specific systemd unit. |
| `kill -9 <PID>` | Forcefully terminate a process. |

---
*Note: This document serves as the foundation for troubleshooting and performance tuning in an SRE career.*
