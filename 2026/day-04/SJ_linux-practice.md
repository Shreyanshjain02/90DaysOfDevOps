# Day 04 – Linux Practice: Processes and Services

## Task
Today’s goal is to **practice Linux fundamentals with real commands**.

You will create a short practice note by actually running basic commands and capturing what you see:
- Check running processes
- Inspect one systemd service
- Capture a small troubleshooting flow
- Process checks
- Service checks
- Log checks
- Mini troubleshooting steps

This is hands-on. Keep it simple and focused on fundamentals.

---


**Process checks**:-

  **ps -aux|grep nginx**  - give all process and its ids with name nginx
  
  **pgrep -l nginx**  - It is also used to get all pids with name nginx
  
  **systemctl start nginx** - To start nginx
  
  **systemctl stop nginx** - To stop
  
  **systemctl status nginx** - to get current status of nginx
  
  **top** :- give non-interactive system utilization (boring task manager)
  
  **htop** :- Colorfull interactive
  
  **sytstemctl list-units** -  gives list of all active units

  **journalctl -u nginx** - gives you logs of nginx

  
  how to download file from linux server to window local:
    **scp** -i privatekey user@public_dns:file/path/you_want_to_download c:/download
  
Follow these rules while creating your practice note:

- Run and record output for **at least 6 commands**
- Include **2 process commands** (`ps`, `top`, `pgrep`, etc.)
- Include **2 service commands** (`systemctl status`, `systemctl list-units`, etc.)
- Include **2 log commands** (`journalctl -u <service>`, `tail -n 50`, etc.)
- Pick **one service on your system** (example: `ssh`, `cron`, `docker`) and inspect it
- Keep it **simple and actionable**

Suggested structure for `linux-practice.md`:
- Process checks
- Service checks
- Log checks
- Mini troubleshooting steps
