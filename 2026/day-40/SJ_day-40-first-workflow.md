# Day 40 – Your First GitHub Actions Workflow
## Challenge Tasks

### Task 1: Set Up
1. Create a new **public** GitHub repository called `github-actions-practice`
2. Clone it locally
3. Create the folder structure: `.github/workflows/`

https://github.com/Shreyanshjain02/Github-Action

---

### Task 2: Hello Workflow
Create `.github/workflows/hello.yml` with a workflow that:
1. Triggers on every `push`
2. Has one job called `greet`
3. Runs on `ubuntu-latest`
4. Has two steps:
   - Step 1: Check out the code using `actions/checkout`
   - Step 2: Print `Hello from GitHub Actions!`

Push it. Go to the **Actions** tab on GitHub and watch it run.

**Verify:** Is it green? Click into the job and read every step.

Yes, It worked!

for Step 1: It sync my respository, check git version at runner machine, initialize my repository into runner..my action repository is remote to runner.

<img width="280" height="263" alt="image" src="https://github.com/user-attachments/assets/e58aaa9c-f258-4aa6-9648-01aa78a2bb67" />


<img width="389" height="215" alt="image" src="https://github.com/user-attachments/assets/14f40e5b-c924-4f1f-99fb-18c5ba33a688" />


---

### Task 3: Understand the Anatomy
Look at your workflow file and write in your notes what each key does:
- `on:` Trigger,this command controls when to trigger workflow.
- `jobs:` It is body of workflow which has all tasks to perform
- `runs-on:` This on which runner we need to run particular job
- `steps:` Every job has steps, which defines order and type of execution i.e. A linear list of operations within a job. Steps run sequentially on the same runner.
- `uses:` Steps can use already existing actions for reference. Imports a reusable unit of code (an Action) from GitHub's marketplace or a local path.
- `run:` Step can run particular shell command inside runner
- `name:` (on a step) label given to step later used to verify which step failed or passed in complex worksflow

---

### Task 4: Add More Steps
Update `hello.yml` to also:
1. Print the current date and time
2. Print the name of the branch that triggered the run (hint: GitHub provides this as a variable)
3. List the files in the repo
4. Print the runner's operating system

Push again — watch the new run.

<img width="356" height="347" alt="image" src="https://github.com/user-attachments/assets/dd4c8a80-d9f5-4f18-a51b-84721f7e0e69" />


---

### Task 5: Break It On Purpose
1. Add a step that runs a command that will **fail** (e.g., `exit 1` or a misspelled command)
2. Push and observe what happens in the Actions tab
3. Fix it and push again

Write in your notes: What does a failed pipeline look like? How do you read the error?

While performing code checkout I used run: instead uses: which failed that particular step

<img width="659" height="246" alt="image" src="https://github.com/user-attachments/assets/cd7bc710-0713-4ea7-bb18-441b2179e107" />

Later, I referred official checkout github repository and readme.md to fix issue.


---

## Hints
- Workflow files live in `.github/workflows/` and must end in `.yml`
- `uses: actions/checkout@v4` checks out your code onto the runner
- `run:` executes shell commands
- GitHub provides built-in variables like `${{ github.ref_name }}` for branch name
- Every push triggers a new run — check the Actions tab

---
