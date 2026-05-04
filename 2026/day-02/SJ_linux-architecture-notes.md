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
