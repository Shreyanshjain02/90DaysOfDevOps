# 👥 Day 09: Linux User & Group Management Challenge

> [!TIP]
> Identity and Access Management (IAM) starts at the OS level. Mastering users, groups, and shared directory permissions is critical for securing multi-tenant servers and CI/CD runners.

---

## 🚀 1. User & Group Administration
*Creating the foundation for secure system access and role-based permissions.*


| Command | Action | SRE Use Case |
| :--- | :--- | :--- |
| `useradd -m <user>` | Create user with home directory. | Provisioning access for a new developer. |
| `groupadd <group>` | Create a new security group. | Defining roles like `devs` or `admins`. |
| `usermod -aG <grp> <usr>`| Add user to a group (Append). | Granting a user specific team permissions. |
| `passwd <user>` | Set or change user password. | Managing credential rotations. |

---

## 📂 2. Shared Workspace & Permissions
*Setting up collaborative environments with strict access controls.*


| Command | Description | Troubleshooting Value |
| :--- | :--- | :--- |
| `chgrp <group> <dir>` | Change group ownership. | Ensuring a team can access a project folder. |
| `chmod 775 <dir>` | Set `rwxrwxr-x` permissions. | Allowing group writes while keeping public read-only. |
| `sudo -u <user> <cmd>` | Execute command as another user. | Testing permission boundaries without logging out. |
| `ls -ld <dir>` | View directory-specific metadata. | Verifying sticky bits and group ownership. |

---

## 🛠️ Challenge Execution Flow

### Task 1: Identity Provisioning
```bash
# Create Users
sudo useradd -m tokyo
sudo useradd -m berlin
sudo useradd -m professor

# Verify creation
grep -E "tokyo|berlin|professor" /etc/passwd
ls /home/
```

### Task 2 & 3: Group RBAC (Role-Based Access Control)
```bash
# Create Groups
sudo groupadd developers
sudo groupadd admins

# Assign Memberships
sudo usermod -aG developers tokyo
sudo usermod -aG developers berlin
sudo usermod -aG admins berlin
sudo usermod -aG admins professor

# Verify Memberships
groups tokyo
id berlin
```

### Task 4 & 5: Shared Team Workspaces
```bash
# Setup Dev Project
sudo mkdir -p /opt/dev-project
sudo chgrp developers /opt/dev-project
sudo chmod 775 /opt/dev-project

# Setup Team Workspace
sudo useradd -m nairobi
sudo groupadd project-team
sudo usermod -aG project-team nairobi
sudo usermod -aG project-team tokyo
sudo mkdir -p /opt/team-workspace
sudo chgrp project-team /opt/team-workspace
sudo chmod 775 /opt/team-workspace
```

---

## 🔍 Key Findings & Logic
*   **Permissions Logic:** Used `775` to allow the Owner and Group to `Read/Write/Execute`, while others can only `Read/Execute`.
*   **Secondary Groups:** Used `-aG` with `usermod` to ensure users like `berlin` stayed in `developers` while being added to `admins`.
*   **Verification:** Used `ls -ld` to confirm that directory group ownership shifted from `root` to the target team group.

---

## ✅ Day 09 Completion Checklist
- [ ] **User Management:** Created 4 users (`tokyo`, `berlin`, `professor`, `nairobi`).
- [ ] **Group Logic:** Successfully mapped users to multiple functional groups.
- [ ] **Shared Access:** Verified that `nairobi` can create files in `/opt/team-workspace`.
- [ ] **Security:** Confirmed that users NOT in a group cannot write to that group's directory.

---
**Next Step:** Want to explore **Sudoers configuration** or move into **Advanced File Permissions (Sticky Bits & SUID)**?
