# Day 09 – Linux User & Group Management Challenge

## Task
Today's goal is to **practice user and group management** by completing hands-on challenges.

Figure out how to:
- Create users and set passwords
- Create groups and assign users
- Set up shared directories with group permissions

Use what you learned from Days 1-7 to find the right commands!
## Challenge Tasks

### Task 1: Create Users (20 minutes)

Create three users with home directories and passwords:
- `tokyo`
- `berlin`
- `professor`

**Verify:** Check `/etc/passwd` and `/home/` directory

<img width="485" height="62" alt="image" src="https://github.com/user-attachments/assets/07d4f8ae-6975-4ede-9013-e36bf89afa2b" />

---

### Task 2: Create Groups (10 minutes)

Create two groups:
- `developers`
- `admins`

**Verify:** Check `/etc/group`

<img width="182" height="77" alt="image" src="https://github.com/user-attachments/assets/df434ecb-02de-4ae1-9e78-a361f1cfbaa0" />

---

### Task 3: Assign to Groups (15 minutes)

Assign users:
- `tokyo` → `developers`
- `berlin` → `developers` + `admins` (both groups)
- `professor` → `admins`

**Verify:** Use appropriate command to check group membership

<img width="262" height="79" alt="image" src="https://github.com/user-attachments/assets/5843998c-35d8-4ac3-90db-9a69184d5a6c" />

---

### Task 4: Shared Directory (20 minutes)

1. Create directory: `/opt/dev-project`
2. Set group owner to `developers`
3. Set permissions to `775` (rwxrwxr-x)
4. Test by creating files as `tokyo` and `berlin`

**Verify:** Check permissions and test file creation

<img width="557" height="383" alt="image" src="https://github.com/user-attachments/assets/21a263bf-9d17-47ab-876f-2b02141da863" />


---

### Task 5: Team Workspace (20 minutes)

1. Create user `nairobi` with home directory
2. Create group `project-team`
3. Add `nairobi` and `tokyo` to `project-team`
4. Create `/opt/team-workspace` directory
5. Set group to `project-team`, permissions to `775`
6. Test by creating file as `nairobi`


<img width="458" height="134" alt="image" src="https://github.com/user-attachments/assets/30fff798-62a2-4c89-8d45-f9766fe56f9b" />


---

## Hints

**Stuck? Try these commands:**
- User: `useradd`, `passwd`, `usermod`
- Group: `groupadd`, `groups`
- Permissions: `chgrp`, `chmod`
- Test: `sudo -u username command`

**Tip:** Use `-m` flag with useradd for home directory, `-aG` for adding to groups
 
---

## Documentation

## Users & Groups Created
- Users: tokyo, berlin, professor, nairobi
- Groups: developers, admins, project-team

## Group Assignments
[List who is in which groups]

<img width="401" height="104" alt="image" src="https://github.com/user-attachments/assets/d3a2787f-dbbd-4cf2-8b50-f8f3f3418cb7" />


## Directories Created
[List directories with permissions]

<img width="484" height="72" alt="image" src="https://github.com/user-attachments/assets/fdfb08d0-bbe2-4262-9a88-37c5967636a6" />


## Commands Used
[Your commands here]
sudo adduser "username"
"password"
sudo addgroup "group-name"
sudo usermod -aG "group-name" "username"
sudo chown "user":"group" <directory or file>
sudo chmod 775 <directory or file>


## What I Learned
[3 key points]

How to create user, group.
how to add users in group
how to change ownership of directory or file
how to change permission of directory or file

```

---


## Troubleshooting

**Permission denied?** Use `sudo`

**User can't access directory?**
- Check group: `groups username`
- Check permissions: `ls -ld /path`

---


