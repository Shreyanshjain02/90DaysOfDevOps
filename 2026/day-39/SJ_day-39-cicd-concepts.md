# Day 39 – What is CI/CD?

## Challenge Tasks

### Task 1: The Problem
Think about a team of 5 developers all pushing code to the same repo manually deploying to production.

Write in your notes:
1. What can go wrong?

As all 5 devs are working on same repo, possibility:

  -Code integration will not work smoothly.
  -Correct code might not reach to production due to merge conflicts and overwrite. 
  -As code is not linted (security check) and tested thoroughly it could cause bug or outages in production.
  -Manualy deployment is tedious work.
  -reverting to failure is also time consuming activity
  
  


2. What does "it works on my machine" mean and why is it a real problem?

- This very common excuse in software industry, this kind of problem even increases when CI-CD is not implemented and deployments are manual.
- Possible reason could be:-
    - Hardware and software configuration(OS, version) differences.
    - One's code is not compatible with others (integration and dependencies issue).
    - Productions are set differently than personal machine. they have security setting enabled to avoid vulnerability.
    - Blame game:As human we are traits to defend yourself. which affect MTTR (mean time to resolution)
  

3. How many times a day can a team safely deploy manually?

- As per my understanding team can safely deploy manually close to 1 time i.e. when they come together with a collaborative approach which is very expensive. so once a week would be better and safer for manual deployment.
---

### Task 2: CI vs CD
Research and write short definitions (2-3 lines each):

<img width="447" height="307" alt="image" src="https://github.com/user-attachments/assets/42e855b0-3ff9-419b-ac30-1e656b1579a7" />


1. **Continuous Integration** — what happens, how often, what it catches

As per live session, CI is initial stage of DevOps. In this stage developer's code is build and merged into main repository.
this is also an important stage where testing is also completed. Occurence of this stage is dependent on trigger applied on pipeline used for integration.
Mostly with:-
merge and pull request
workflow_dispatch button
dependent on other pipeline status
As this stage involve testing, it helps developer to catch bugs early, linting and programming mistakes, security checks are completed in this stage.

2. **Continuous Delivery** — how it's different from CI, what "delivery" means

In this stage, Developers code is released or delivered( code is checked-out, compiled) for further task like regression testing, performance testing,functional impact, environmental or infrastructural impact etc before deploying to production.
this stage later conclude or deployed into production by a product owner or stack holder decide to push code or not.

3. **Continuous Deployment** — how it differs from Delivery, when teams use it

This last stage in DevSecOps cycle, where developers code is automatically deployed to customer or production for end user to use without human check
In delivery, code deployment is dependent on approval and human verification while ine deployment code is automatically deployed to production once completed testing phase

Write one real-world example for each.

CI-CRelease/Delivery-CD:-
Finance Business scenario:-
Plan :- your customer requested for ammount transfer funcationality in a banking app.
Code:- You developed functionality.
Build:- You build and integrated your code in main repository (after unit test and linting)
Test:- QA Team use that build for testing :- regression, performance, security, functional and automation.
Release/Delivery:- Once all type of testing and above checks are completed product owner review code, test reports and decide to deploy or not.
Deployment:- Once he/she is satisfied with review and reports, code is deployed to production
Operation:- End user start using functionality on their environment.
Monitor:- while we keep monitoring functionality and application.

CI-CD:-
In live session:-We plan to create a python base fast api website/webpage.
Plan:- Plan "how to develop"
Code:- we coded index.html, api.py and other files
build:- we checkout code, build image and push it on docker hub
test:- during building stage we used flake8 to verify python code quality.
Deployed:- Once above workflow passed we directly deployed it self hosted runner.
operation:- Webpage was live to use.

In CI-CD process we were not relying human to review code and approve.



---
### Task 3: Pipeline Anatomy
A pipeline has these parts — write what each one does:
- **Trigger** — what starts the pipeline
  
-  Trigger starting condition for any pipeline to start.
-  It’s the "event" (like a code push, a timer, or a manual button click) that tells the system to start working.

- **Stage** — a logical phase (build, test, deploy).

- An pipeline go through multiple stages like build , test ,deploy etc
- Stages act as checkpoints. For example, the "Deploy" stage usually won't start unless the "Test" stage finishes successfully.

- **Job** — a unit of work inside a stage

  Jobs is important part of workflow which is started with once triggered
  A key detail is that jobs within the same stage can often run in parallel (at the same time) to save time.

- **Step** — a single command or action inside a job

 Steps are sub-part of any job which decides order of execution within a job
 These are the individual "to-do" items (e.g., npm install, run tests). If one step fails, the whole job stops.


- **Runner** — the machine that executes the job

  Runner is node/machine where whole pipeline is runs.
  This is the server or container (the "worker") where the code is actually downloaded and the commands are typed out by the system
  
- **Artifact** — output produced by a job

  once a job is executed it we have different artifacts to cross check status and error. this can be used as needs for other stages
  While artifacts can be used to check errors (like logs), their main purpose is often to carry the "package" (like a .zip or .exe file) from the "Build" stage to the "Deploy" stage.
---

### Task 4: Draw a Pipeline
Draw a CI/CD pipeline for this scenario:
> A developer pushes code to GitHub. The app is tested, built into a Docker image, and deployed to a staging server.

Include at least 3 stages. Hand-drawn and photographed is perfectly fine.

<img width="596" height="271" alt="image" src="https://github.com/user-attachments/assets/5fa565b4-f834-4b5c-82a1-fc2258787f24" />


---

### Task 5: Explore in the Wild
1. Open any popular open-source repo on GitHub (Kubernetes, React, FastAPI — pick one you know)

https://github.com/fastapi/fastapi/tree/master/.github

2. Find their `.github/workflows/` folder

https://github.com/fastapi/fastapi/tree/master/.github/workflows

3. Open one workflow YAML file

https://github.com/fastapi/fastapi/blob/master/.github/workflows/add-to-project.yml


4. Write in your notes:
   - What triggers it?
   - pull_request_target and issue status (open and re-open) trigger above workflow.
   - pull_request_target
   - issues:
      types:
       - opened
       - reopened


   - How many jobs does it have?
   - it has only one job "Add to project" which runs on github runner ubuntu-latest and have one step only that uses github actions


   - What does it do? (best guess)
   - Whenever, an pull request or issue is opened, reopened, job "add to project" is executed which will use actions/add-to-project@v1.0.2 to add issue and pull request into project  with url and secret PAT.



-

## Hints
- CI/CD is a practice, not just a tool
- GitHub Actions, Jenkins, GitLab CI, CircleCI — all are tools that implement CI/CD
- A pipeline failing is not a problem — it's CI/CD doing its job
