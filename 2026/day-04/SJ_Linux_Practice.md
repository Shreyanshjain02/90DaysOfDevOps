# 🐧 Day 04: Linux Practice — Processes & Services

> [!TIP]
> Master the art of managing system health, controlling service lifecycles, and digging through logs to solve infrastructure puzzles.

---

## 🚀 1. Process Management
*Identify "noisy neighbors" and manage resource distribution across the system.*


| Command | Action | SRE Use Case |
| :--- | :--- | :--- |
| `ps -aux \| grep nginx` | List all processes by name. | Finding specific PIDs and owner details. |
| `pgrep -l nginx` | List PIDs with process names. | Quick verification if a daemon is running. |
| `top` | Non-interactive monitor. | Snapshot of system utilization. |
| `htop` | Interactive resource monitor. | Visualizing CPU/RAM usage with color coding. |

---

## ⚙️ 2. Service Control (`systemctl`)
*The standard interface for managing systemd units and background services.*

*   **`systemctl status nginx`**: Check if the service is active, dead, or failing.
*   **`systemctl start nginx`**: Spin up a stopped service.
*   **`systemctl stop nginx`**: Gracefully shut down a service.
*   **`systemctl list-units --type=service`**: See every active service currently managed by the OS.

---

## 📜 3. Log Inspection & Troubleshooting
*Where the answers live. Use these when a service refuses to start.*


| Command | Description | Troubleshooting Value |
| :--- | :--- | :--- |
| `journalctl -u nginx` | View service-specific logs. | Seeing exactly why a service crashed. |
| `tail -f /var/log/syslog` | Stream system logs in real-time. | Watching events happen as you trigger them. |
| `journalctl -xe` | View the end of the journal. | Finding the most recent system errors. |

---

## 📂 4. Remote Data Transfer
*Moving logs or configuration backups from the server to your local environment.*

**Secure Copy (SCP) Syntax:**
```bash
# Download from Linux Server to Windows Local
scp -i privatekey user@public_dns:/path/to/file C:/Downloads/
```

---

## ✅ Day 04 Practice Checklist
- ✅ **Inspect:** Pick one service (`ssh`, `docker`, or `cron`) and check its status.
- ✅ **Monitor:** Open `htop` and identify the process consuming the most memory.
- ✅ **Debug:** Intentionally stop a service and find the "Stopped" entry in `journalctl`.
- ✅ **Transfer:** Use `scp` to move a small text file from your server to your local machine.
