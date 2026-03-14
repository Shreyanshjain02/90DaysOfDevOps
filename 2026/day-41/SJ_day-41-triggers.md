# Day 41 – Triggers & Matrix Builds

## Challenge Tasks

### Task 1: Trigger on Pull Request
1. Create `.github/workflows/pr-check.yml`
2. Trigger it only when a pull request is **opened or updated** against `main`
3. Add a step that prints: `PR check running for branch: <branch name>`
4. Create a new branch, push a commit, and open a PR
5. Watch the workflow run automatically

**Verify:** Does it show up on the PR page? 

Yes, and also have check.

https://github.com/Shreyanshjain02/Github-Action/blob/main/.github/workflows/pr-check.yml

---

### Task 2: Scheduled Trigger
1. Add a `schedule:` trigger to any workflow using cron syntax
https://github.com/Shreyanshjain02/Github-Action/blob/main/.github/workflows/hello.yml

Tried cron for every 5min but not working.

3. Set it to run every day at midnight UTC
schedule:
  -cron: "* 0 * * *"
4. Write in your notes: What is the cron expression for every Monday at 9 AM?

schedule:
  -cron: "* 9 * * 1"
  
 https://github.com/Shreyanshjain02/Github-Action/blob/main/.github/workflows/hello.yml 
 
---

### Task 3: Manual Trigger
1. Create `.github/workflows/manual.yml` with a `workflow_dispatch:` trigger
2. Add an **input** that asks for an `environment` name (staging/production)
3. Print the input value in a step
4. Go to the **Actions** tab → find the workflow → click **Run workflow**

**Verify:** Can you trigger it manually and see your input printed?

https://github.com/Shreyanshjain02/Github-Action/blob/main/.github/workflows/input.yml

---

### Task 4: Matrix Builds
Create `.github/workflows/matrix.yml` that:
1. Uses a matrix strategy to run the same job across:
   - Python versions: `3.10`, `3.11`, `3.12`
2. Each job installs Python and prints the version
3. Watch all 3 run in parallel

Then extend the matrix to also include 2 operating systems — how many total jobs run now?

https://github.com/Shreyanshjain02/Github-Action/blob/action-test-branch/.github/workflows/matrix.yml


Total 10 jobs for 5 python version 2 different os
---

### Task 5: Exclude & Fail-Fast
1. In your matrix, **exclude** one specific combination (e.g., Python 3.10 on Windows)
2. Set `fail-fast: false` — trigger a failure in one job and observe what happens to the rest
3. Write in your notes: What does `fail-fast: true` (the default) do vs `false`?

https://github.com/Shreyanshjain02/Github-Action/blob/main/.github/workflows/matrix.yml

with fail fast - false it ignore failed job and keep other jobs running
   exclude installation of 3.14 on window which result in 9 jobs
   and given 3.10 with "" which failed on ubuntu as it doesn't have version 3.1 but due to fail fast: false 8job completed out 9 as per expectation.

with fail-fast: true it will cancel all pending or running job once any job is failed. Any job that is completed before failure will be green/completed.

---

## Hints
- PR trigger: `on: pull_request: branches: [main]`
- Cron trigger: `on: schedule: - cron: '0 0 * * *'`
- Manual trigger: `on: workflow_dispatch: inputs:`
- Matrix: `strategy: matrix: python-version: [...]`
- Exclude: `exclude: - os: windows-latest python-version: "3.10"`

----
