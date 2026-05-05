# Day 10 – File Permissions & File Operations Challenge

## Task
Master file permissions and basic file operations in Linux.

- Create and read files using `touch`, `cat`, `vim`
- Understand and modify permissions using `chmod`

---

## Expected Output
- A markdown file: `day-10-file-permissions.md`
- Screenshots showing permission changes

---

## Challenge Tasks

### Task 1: Create Files (10 minutes)

1. Create empty file `devops.txt` using `touch`
2. Create `notes.txt` with some content using `cat` or `echo`
3. Create `script.sh` using `vim` with content: `echo "Hello DevOps"`

**Verify:** `ls -l` to see permissions

<img width="545" height="122" alt="image" src="https://github.com/user-attachments/assets/c4b89aeb-d6d0-45a8-8291-9b3232b6ac1b" />

---

### Task 2: Read Files (10 minutes)

1. Read `notes.txt` using `cat`
2. View `script.sh` in vim read-only mode
3. Display first 5 lines of `/etc/passwd` using `head`
4. Display last 5 lines of `/etc/passwd` using `tail`


<img width="544" height="98" alt="image" src="https://github.com/user-attachments/assets/dd63d5ab-5ad3-4d87-8621-55b0ad8c3a24" />

<img width="256" height="464" alt="image" src="https://github.com/user-attachments/assets/3a2aab93-0b4b-4f0f-8859-a2705dd2015d" />

<img width="482" height="107" alt="image" src="https://github.com/user-attachments/assets/039f20cd-2f33-483d-9b71-66ca4420cd55" />

<img width="465" height="121" alt="image" src="https://github.com/user-attachments/assets/f7d0c1ea-2c7d-4277-ba86-9b943732a0c0" />

---

### Task 3: Understand Permissions (10 minutes)

Format: `rwxrwxrwx` (owner-group-others)
- `r` = read (4), `w` = write (2), `x` = execute (1)

Check your files: `ls -l devops.txt notes.txt script.sh`

Answer: What are current permissions? Who can read/write/execute?

---

### Task 4: Modify Permissions (20 minutes)

1. Make `script.sh` executable → run it with `./script.sh`
2. Set `devops.txt` to read-only (remove write for all)
3. Set `notes.txt` to `640` (owner: rw, group: r, others: none)
4. Create directory `project/` with permissions `755`

**Verify:** `ls -l` after each change

---

### Task 5: Test Permissions (10 minutes)

1. Try writing to a read-only file - what happens?
2. Try executing a file without execute permission
3. Document the error messages

---

## Hints

- Create: `touch`, `cat > file`, `vim file`
- Read: `cat`, `head -n`, `tail -n`
- Permissions: `chmod +x`, `chmod -w`, `chmod 755`

---

## Documentation

Create `day-10-file-permissions.md`:

```markdown
# Day 10 Challenge

## Files Created
[list files]

## Permission Changes
[before/after for each file]

## Commands Used
[your commands]

## What I Learned
[3 key points]
```

---

## Submission
1. Navigate to `2026/day-10/` folder
2. Add `day-10-file-permissions.md` with screenshots
3. Commit and push

---

## Learn in Public

Share on LinkedIn about mastering file permissions.

Use hashtags:
```
#90DaysOfDevOps
#DevOpsKaJosh
#TrainWithShubham
```

Happy Learning
**TrainWithShubham**
