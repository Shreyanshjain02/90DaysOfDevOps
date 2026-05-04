# 🛠️ Day 05: Linux Troubleshooting Drill

> [!IMPORTANT]
> **Scenario:** An incident is active. This runbook is a repeatable checklist designed to capture evidence before acting and identify "process villains" under pressure.

---

## 🎯 Target Service: `containerd.service`
*Core container runtime responsible for pod lifecycles.*

---

## 📂 1. Environment & Filesystem Sanity
*Confirming hardware reality and ensuring the disk is writable.*


| Command | Purpose | Observation |
| :--- | :--- | :--- |
| `uname -a` | Hardware Reality | Kernel version & architecture confirmed. |
| `lsb_release -a` | OS Context | Verified distribution (e.g., Ubuntu 22.04). |
| `df -h` | Capacity Check | `/` and `/var/lib/containerd` are under 80%. |
| `mkdir /tmp/drill && ls -l` | Writable Check | Filesystem is NOT read-only; scratch folder created. |

---

## ⚡ 2. CPU & Memory Snapshot
*Identifying bottlenecks and CPU "task-swapping" overhead.*

*   **`uptime`**: Check Load Average. If 1-min load > CPU cores, the incident is escalating.
*   **`top -b -n 1 -p $(pgrep containerd)`**: Snapshot of specific service resource usage.
*   **`vmstat 1 5`**: Monitor **cs** (Context Switches). *Observed: Stable switching; no CPU thrashing.*
*   **`free -h`**: Check available RAM. *Observed: Sufficient "Available" memory; no swap pressure.*

---

## 💾 3. Disk & I/O Utilization
*Checking for failing drives or slow volumes causing I/O Wait.*

*   **`iostat -xz 1`**: Check `%util`. If 100% with low throughput, the disk is saturated.
*   **`pidstat -dl 1`**: Linking specific PIDs to Disk spikes.
*   **`du -sh /var/log/pods`**: Checking for log-rotate failures bloating the disk.

---

## 🌐 4. Network & Socket Health
*Diagnosing "App-to-Database" connectivity and socket overflows.*


| Command | Action | Findings |
| :--- | :--- | :--- |
| `nstat -z` | Check Overflows | `TcpExtListenOverflows` is 0 (Queue healthy). |
| `ip -s link` | Interface Health | No dropped packets or overruns on `eth0`. |
| `sudo ss -ntp` | Socket Inspection | No stuck `Recv-Q` or `Send-Q` detected. |
| `ping -c 3 8.8.8.8` | Connectivity | External network is reachable. |

---

## 📜 5. Logs & Kernel Traces
*Hardware metrics tell you where it hurts; logs tell you why.*

*   **`dmesg -T | tail -n 50`**: Checking for **OOM Killer** or filesystem I/O errors.
*   **`journalctl -u containerd -n 50 --no-pager`**: Reviewing service-specific logs for crash loops.
*   **`tail -f /var/log/syslog`**: Streaming real-time system events.

---

## 🔍 Quick Findings Summary
- **Health:** Service is active; Load average is normal (0.15, 0.10, 0.05).
- **Bottlenecks:** No I/O wait detected; Memory usage is stable at 400MB.
- **Errors:** No OOM events found in `dmesg`.

---

## 🚨 If This Worsens (Next Steps)
1. **Increase Log Verbosity:** Change `containerd` log level to `debug` in `/etc/containerd/config.toml`.
2. **Deep Trace:** Use `strace -p <PID> -c` to identify slow system calls.
3. **Cluster Isolation:** Cordon the node and migrate pods to verify if hardware is the root cause.

---
**Why This Matters:** Incidents rarely provide perfect clues. This fast, repeatable checklist reduces downtime and prevents guesswork in production.
