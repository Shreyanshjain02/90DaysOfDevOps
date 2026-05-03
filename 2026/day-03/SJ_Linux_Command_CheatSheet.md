# 🛠️ Day 03: Linux Command Cheat Sheet

>These commands are your primary tools for diagnosing system health, managing resources, and troubleshooting connectivity.

---

## 📂 1. File & Directory Operations
*Fundamental for navigating servers and managing configurations.*


| Command | Description | SRE Use Case |
| :--- | :--- | :--- |
| `pwd` | Print Working Directory. | Confirming location before running scripts. |
| `ls -ltr` | List files by time (**oldest first**). | Finding which log files were generated first. |
| `ls -lt` | List files by time (**newest first**). | Quickly seeing the most recent deployments. |
| `cd ..` | Go back one directory. | Navigating the `/etc` or `/var` paths. |
| `mkdir -p` | Create nested directories. | Setting up application folder structures. |
| `cp -r` | Copy recursively. | Backing up a config folder before editing. |
| `mv` | Move or **Rename** files. | Rotating local logs manually. |
| `rsync -a` | Archive/Sync directories. | More reliable than `cp` for large data transfers. |
| `rm -rf` | Force recursive delete. | **CAUTION:** Cleaning up old build artifacts. |

---

## 🚀 2. Process & Resource Management
*Crucial for identifying "noisy neighbors" and performance bottlenecks.*

### Monitoring
*   **`top`**: The standard real-time resource monitor.
*   **`htop`**: An interactive, color-coded version of `top` (easier to read).
*   **`ps -aux`**: A complete snapshot of every process running on the system.

### Process Control
*   **`kill -9 <PID>`**: Force-kill a stuck process (use as a last resort).
*   **`pkill <name>`**: Kill all processes by name (e.g., `pkill nginx`).
*   **`nice -n <val>`**: Start a process with a specific priority (-20 to 19).
*   **`renice <val> -p <PID>`**: Change the priority of an **already running** process.
    *   *Lower value (-20) = Higher Priority.*

---

## 🌐 3. Networking & Connectivity
*Essential for debugging "Why can't my App talk to the Database?"*


| Command | Usage | Result |
| :--- | :--- | :--- |
| `ip a` | Interface management. | Find your **Private IP** address. |
| `curl ifconfig.me` | Web data transfer. | Find your **Public IP** address. |
| `ping <host>` | ICMP Echo Request. | Check if a server is reachable. |
| `dig <domain>` | DNS lookup. | Check if DNS records (A, CNAME) are correct. |
| `ss -tulpn` | Socket statistics. | See which ports are listening (replaces `netstat`). |
| `wget <url>` | Download files. | Fetching binaries or installers. |

---

## 💡 SRE Pro-Tips for Day 03
1.  **Search History:** Use `Ctrl + R` to search through your command history.
2.  **The "Force" Myth:** Don't always use `kill -9`. Try `kill -15` (SIGTERM) first to allow the app to shut down gracefully and save data.
3.  **Permissions:** If a command fails, check if you need `sudo` (SuperUser Do).

---
*Last Updated: May 2026*
