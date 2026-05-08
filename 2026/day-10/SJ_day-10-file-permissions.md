# Day 10 – File Permissions & File Operations Challenge

## Task 1: Create Files
I used three different methods to create the required files:

```bash
# Create an empty file
touch devops.txt

# Create a file with content
echo "Permissions are key to Linux security." > notes.txt

# Create a script using Vim
vim script.sh 
# Added: echo "Hello DevOps"
```

## Task 2: Read Files
Testing different ways to view file contents and system files:

```bash
# View the notes
cat notes.txt

# View script in read-only mode
vim -R script.sh

# View the beginning and end of system user list
head -n 5 /etc/passwd
tail -n 5 /etc/passwd
```

## Task 3: Current Permissions
Initial check of the files using `ls -l`:

```bash
ls -l devops.txt notes.txt script.sh
```
**Observation:** 
Most files default to `-rw-rw-r--`. This means the **Owner** and **Group** can read/write, but **Others** can only read. None have execute (`x`) permissions yet.

## Task 4: Modify Permissions
Applying specific permission sets using both symbolic and numeric modes:

```bash
# 1. Make script executable and run it
chmod +x script.sh
./script.sh

# 2. Set devops.txt to read-only for everyone
chmod a-w devops.txt

# 3. Set notes.txt to 640 (Owner: rw, Group: r, Others: ---)
chmod 640 notes.txt

# 4. Create project directory with 755 (Owner: rwx, Group/Others: r-x)
mkdir project
chmod 755 project
```

## Task 5: Error Testing
Documenting what happens when security constraints are met:

```bash
# Attempting to write to read-only devops.txt
echo "new data" > devops.txt
# Error: bash: devops.txt: Permission denied

# Attempting to execute script without 'x' permission
chmod -x script.sh
./script.sh
# Error: bash: ./script.sh: Permission denied
```

## What I Learned
1. **Numeric vs Symbolic:** `chmod 640` is often faster than `chmod u=rw,g=r,o=`.
2. **Directory Permissions:** A directory needs `+x` (execute) for a user to actually "enter" it using `cd`.
3. **Security:** Denying "Others" (the third triplet) any permissions is a best practice for sensitive configuration files.
