# Day 12 – Breather & Revision (Days 01–11)

## Goal
Take a **one-day pause** to consolidate everything from Days 01–11 so you don’t forget the fundamentals you just built.

## What to Review (pick at least one per section)
- **Mindset & plan:** revisit your Day 01 learning plan—are your goals still right? any tweaks?
> Yes, They are very right on track and no tweaks required only discipline and consistency.

- **Processes & services:** rerun 2 commands from Day 04/05 (e.g., `ps`, `systemctl status`, `journalctl -u <service>`); jot what you observed today.
> ps gives all running process on current terminal  (currently only bash and ps).

> Systemctl status is active and start time is 18min ago, as i started AWS EC2 instance few minutes back.

> Journalctl -u docker -  gives recent logs of docker unit running.
- **File skills:** practice 3 quick ops from Days 06–11 (e.g., `echo >>`, `chmod`, `chown`, `ls -l`, `cp`, `mkdir`).
> Revisited  mkdir, mv, echo , chmod, ls -l, cp and chown

> <img width="506" height="291" alt="image" src="https://github.com/user-attachments/assets/7335f46b-44e5-40b3-9411-ca62f9814d40" />

- **Cheat sheet refresh:** skim your Day 03 commands—highlight 5 you’d reach for first in an incident.
> 
- **User/group sanity:** recreate one small scenario from Day 09 or Day 11 (create a user or change ownership) and verify with `id`/`ls -l`.

## Mini Self-Check (write short answers in `day-12-revision.md`)
1) Which 3 commands save you the most time right now, and why?  
2) How do you check if a service is healthy? List the exact 2–3 commands you’d run first.  
3) How do you safely change ownership and permissions without breaking access? Give one example command.  
4) What will you focus on improving in the next 3 days?

## Suggested Flow (30–45 minutes)
- 10 min: skim notes from each day, update Day 01 plan if needed.  
- 15–20 min: rerun a tiny hands-on set (process check, service check, file permission change).  
- 5–10 min: write the self-check answers and key takeaways.

## Tips
- Keep it light—this is about retention, not new concepts.  
- If something felt shaky this week (e.g., `chmod` numbers, `journalctl` flags), practice that specifically.  
- Small wins: one screenshot of a command rerun + 5 bullet notes is enough.

## Submission
1. Navigate to `2026/day-12/`  
2. Add `day-12-revision.md` with your bullets and answers  
3. Commit and push to your fork
