# Day 38 – YAML Basics
### Task 1: Key-Value Pairs
Create `person.yaml` that describes yourself with:
- `name`
- `role`
- `experience_years`
- `learning` (a boolean)

**Verify:** Run `cat person.yaml` — does it look clean? No tabs?

---

### Task 2: Lists
Add to `person.yaml`:
- `tools` — a list of 5 DevOps tools you know or are learning
- `hobbies` — a list using the inline format `[item1, item2]`

Write in your notes: What are the two ways to write a list in YAML?

<img width="598" height="302" alt="image" src="https://github.com/user-attachments/assets/d9710b87-9274-436b-a2fa-1fad8238ad0b" />

<img width="601" height="328" alt="image" src="https://github.com/user-attachments/assets/35b0a603-cdb3-4fe9-b4a4-1cc47ea79bff" />

In yaml, we can list down item in two format i.e. either using [] aka flow style or - item (value as a child of key, mentioned above)
aka block style


---

### Task 3: Nested Objects
Create `server.yaml` that describes a server:
- `server` with nested keys: `name`, `ip`, `port`
- `database` with nested keys: `host`, `name`, `credentials` (nested further: `user`, `password`)

**Verify:** Try adding a tab instead of spaces — what happens when you validate it?

<img width="605" height="321" alt="image" src="https://github.com/user-attachments/assets/c0358238-d055-402e-8ca6-d9cc1fdfc81d" />

---

### Task 4: Multi-line Strings
In `server.yaml`, add a `startup_script` field using:
1. The `|` block style (preserves newlines)
2. The `>` fold style (folds into one line)

Write in your notes: When would you use `|` vs `>`?

Before
<img width="598" height="374" alt="image" src="https://github.com/user-attachments/assets/8413c37d-e961-4992-a78c-b0f7a0c523e8" />

After
<img width="592" height="380" alt="image" src="https://github.com/user-attachments/assets/7327ea7b-c378-4b70-a241-25b2f7d53220" />

bold (|):- It is used when you need long string (paragraph) in multi-line format.
fold (>):- It is used when you need long string in single line format.

---

### Task 5: Validate Your YAML
1. Install `yamllint` or use an online validator
2. Validate both your YAML files
3. Intentionally break the indentation — what error do you get?
4. Fix it and validate again

Completed: Refer screenshots

---

### Task 6: Spot the Difference
Read both blocks and write what's wrong with the second one:

```yaml
# Block 1 - correct
name: devops
tools:
  - docker
  - kubernetes
```

```yaml
# Block 2 - broken
name: devops
tools:
- docker
  - kubernetes
```

Mistakes(in block2):
1.Key tools value are not indentented properly(two space is missing before - docker) while using block style list nesting. 

correction:-

```yaml
# Block 2 - broken
name: devops
tools:
  - docker
  - kubernetes
```
---

## Hints
- YAML uses **spaces only** — never tabs
- Indentation is everything — 2 spaces is standard
- Strings don't need quotes unless they contain special characters (`:`, `#`, etc.)
- `true`/`false` are booleans, `"true"` is a string
- Validate online: yamllint.com

---
