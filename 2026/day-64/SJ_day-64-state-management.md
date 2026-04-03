<img width="850" height="240" alt="image" src="https://github.com/user-attachments/assets/b73d8779-0d94-4633-bd00-dd2f90a1c549" /># Day 64 -- Terraform State Management and Remote Backends

## Task
The state file is the single most important thing in Terraform. It is the source of truth -- the map between your `.tf` files and what actually exists in the cloud. Lose it and Terraform forgets everything. Corrupt it and your next apply could destroy production.

Today you learn to manage state like a professional -- remote backends, locking, importing existing resources, and handling drift.

## Challenge Tasks

### Task 1: Inspect Your Current State
Use your Day 63 config (or create a small config with a VPC and EC2 instance). Apply it and then explore the state:

```bash
terraform show                                    # Full state in human-readable format
terraform state list                              # All resources tracked by Terraform
terraform state show aws_instance.<name>          # Every attribute of the instance
terraform state show aws_vpc.<name>               # Every attribute of the VPC
```

<img width="644" height="207" alt="image" src="https://github.com/user-attachments/assets/3337a3d5-3a97-4d0b-b4bd-acea52f8e352" />

<img width="860" height="385" alt="image" src="https://github.com/user-attachments/assets/5290baec-fa08-4047-9343-98f47518c0e0" />

<img width="777" height="404" alt="image" src="https://github.com/user-attachments/assets/e4530a1c-e589-4936-8b19-669999ca8f69" />


Answer:
1. How many resources does Terraform track?
  - 11 Resources and 2 data
    
2. What attributes does the state store for an EC2 instance? (hint: way more than what you defined)

  - Yes

3. Open `terraform.tfstate` in an editor -- find the `serial` number. What does it represent?

The serial number in a terraform.tfstate file is a monotonically increasing integer that acts as a version counter, incrementing every time the state file is updated.
currently my terraform.tfstate file shows 147 i.e i have udpated terraform 147 times.

---

### Task 2: Set Up S3 Remote Backend
Storing state locally is dangerous -- one deleted file and you lose everything. Time to move it to S3.

1. First, create the backend infrastructure (do this manually or in a separate Terraform config):
```bash
# Create S3 bucket for state storage
aws s3api create-bucket \
  --bucket terraweek-state-<yourname> \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1

# Enable versioning (so you can recover previous state)
aws s3api put-bucket-versioning \
  --bucket terraweek-state-<yourname> \
  --versioning-configuration Status=Enabled

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraweek-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ap-south-1
```

2. Add the backend block to your Terraform config:
```hcl
terraform {
  backend "s3" {
    bucket         = "terraweek-state-<yourname>"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraweek-state-lock"
    encrypt        = true
  }
}
```

3. Run:
```bash
terraform init
```
Terraform will ask: "Do you want to copy existing state to the new backend?" -- say yes.

4. Verify:
   - Check the S3 bucket -- you should see `dev/terraform.tfstate`
   - Your local `terraform.tfstate` should now be empty or gone
   - Run `terraform plan` -- it should show no changes (state migrated correctly)
      Yes, No changes but has 1 add and 1 destory.
     
<img width="601" height="158" alt="image" src="https://github.com/user-attachments/assets/4ef33315-48f3-48d3-90e1-8b96c60fe5ca" />

<img width="572" height="55" alt="image" src="https://github.com/user-attachments/assets/de028de3-ab14-4ea1-ad59-9dc8fce4dc14" />

<img width="959" height="359" alt="image" src="https://github.com/user-attachments/assets/b08b73ef-11e5-4e32-89bb-40f7a163932c" />


---

### Task 3: Test State Locking
State locking prevents two people from running `terraform apply` at the same time and corrupting the state.

1. Open **two terminals** in the same project directory
2. In Terminal 1, run:
```bash
terraform apply
```
3. While Terminal 1 is waiting for confirmation, in Terminal 2 run:
```bash
terraform plan
```
4. Terminal 2 should show a **lock error** with a Lock ID

**Document:** What is the error message? Why is locking critical for team environments?

<img width="850" height="240" alt="image" src="https://github.com/user-attachments/assets/482a4efc-8fc1-4fb3-b5cb-504975abcf6b" />

This error message shows following info:-
 - Current check condition - failed/locked - conditionalcheckfailed
 - lock info :-
 -     Lockid - 
 -     operation - apply
 -     who - ubuntu

5. After the test, if you get stuck with a stale lock:
```bash
terraform force-unlock <LOCK_ID>
```
<img width="657" height="286" alt="image" src="https://github.com/user-attachments/assets/7d73cabd-c501-4c1b-9bdc-1754bbcf3e9c" />

---

### Task 4: Import an Existing Resource
Not everything starts with Terraform. Sometimes resources already exist in AWS and you need to bring them under Terraform management.

1. Manually create an S3 bucket in the AWS console -- name it `terraweek-import-test-<yourname>`
2. Write a `resource "aws_s3_bucket"` block in your config for this bucket (just the bucket name, nothing else)
3. Import it:
```bash
terraform import aws_s3_bucket.imported terraweek-import-test-<yourname>
```

<img width="971" height="286" alt="image" src="https://github.com/user-attachments/assets/2381288e-947c-4628-b5a8-b672636584c5" />

4. Run `terraform plan`:
   - If you see "No changes" -- the import was perfect
   -  no changes 
   - If you see changes -- your config does not match reality. Update your config to match, then plan again until you get "No changes"

5. Run `terraform state list` -- the imported bucket should now appear alongside your other resources

<img width="665" height="230" alt="image" src="https://github.com/user-attachments/assets/6c1a7cba-a3ae-471b-90fb-46b61bdeba85" />


**Document:** What is the difference between `terraform import` and creating a resource from scratch?

With import we are adding details of already exist resource state in terraform.tfstate so that our state is updated date with other's changes as well.

---

### Task 5: State Surgery -- mv and rm
Sometimes you need to rename a resource or remove it from state without destroying it in AWS.

1. **Rename a resource in state:**
```bash
terraform state list                              # Note the current resource names
terraform state mv aws_s3_bucket.imported aws_s3_bucket.logs_bucket
```
Update your `.tf` file to match the new name. Run `terraform plan` -- it should show no changes.

<img width="731" height="257" alt="image" src="https://github.com/user-attachments/assets/3a2f24b3-0714-4dcb-83fa-47c1b9e831c2" />

<img width="942" height="68" alt="image" src="https://github.com/user-attachments/assets/a386f673-9948-4b01-867b-38f138ffbb80" />

<img width="907" height="173" alt="image" src="https://github.com/user-attachments/assets/20bdbfad-7146-4fa5-b66a-6b02351f718e" />


2. **Remove a resource from state (without destroying it):**
```bash
terraform state rm aws_s3_bucket.logs_bucket
```
<img width="727" height="59" alt="image" src="https://github.com/user-attachments/assets/34be037f-3490-485c-9f37-75962b0b82bc" />

Run `terraform plan` -- Terraform no longer knows about the bucket, but it still exists in AWS.

<img width="910" height="182" alt="image" src="https://github.com/user-attachments/assets/7dea0fdc-14d0-4be8-92d3-84b6bd5c6862" />

<img width="616" height="227" alt="image" src="https://github.com/user-attachments/assets/535023eb-9fe7-49a3-8f75-81d237652a2a" />


3. **Re-import it** to bring it back:
```bash
terraform import aws_s3_bucket.logs_bucket terraweek-import-test-<yourname>
```

**Document:** When would you use `state mv` in a real project? When would you use `state rm`?

We can use state mv for backup purpose in real project that is before doing state rm.
also, In a real-world project, these commands are used to manually adjust the "mapping" between your code and the actual infrastructure.
state rm :- Use this to "forget" a resource. It removes the item from the state file but does not delete the actual resource in your cloud provider. as we saw even after removing resource aws_s3_bucket.logs_bucket there were no changes on console.

---

### Task 6: Simulate and Fix State Drift
State drift happens when someone changes infrastructure outside of Terraform -- through the AWS console, CLI, or another tool.

1. Apply your full config so everything is in sync

<img width="641" height="179" alt="image" src="https://github.com/user-attachments/assets/7d2c54f2-aea4-4bcf-b1ff-56ee4f99b7d2" />

2. Go to the **AWS console** and manually:
   - Change the Name tag of your EC2 instance to `"ManuallyChanged"`
   - Change the instance type if it's stopped (or add a new tag)
3. Run:
```bash
terraform plan
```
<img width="944" height="242" alt="image" src="https://github.com/user-attachments/assets/78545cd9-d4e7-4948-8271-9f4cf0d97ff8" />


You should see a **diff** -- Terraform detects that reality no longer matches the desired state.

<img width="722" height="260" alt="image" src="https://github.com/user-attachments/assets/2df026ea-6189-43ce-8e80-9ae1502999a6" />


4. You have two choices:
   - **Option A:** Run `terraform apply` to force reality back to match your config (reconcile)
   - **Option B:** Update your `.tf` files to match the manual change (accept the drift)

5. Choose Option A -- apply and verify the tags are restored.

<img width="947" height="232" alt="image" src="https://github.com/user-attachments/assets/a0e14e40-5d5f-4073-b95c-ffb82766e155" />


6. Run `terraform plan` again -- it should show "No changes." Drift resolved.

<img width="930" height="320" alt="image" src="https://github.com/user-attachments/assets/29cbde78-206c-4368-a28d-fc3588f4589b" />


**Document:** How do teams prevent state drift in production? (hint: restrict console access, use CI/CD for all changes)
1. Don't grant console access with admin or creation role. give only read-only role.
2. Use git to track every commit and pull request before implementing.
3. Storing state files locally is a major risk for teams. Instead, use a remote backend
4. learn more about policy and control.

---

## Hints
- S3 bucket names must be globally unique
- DynamoDB table must have a `LockID` string key -- this is what Terraform uses for locking
- `terraform init -migrate-state` explicitly triggers state migration
- `terraform refresh` (or `terraform apply -refresh-only`) updates state to match real infrastructure without making changes
- State locking only works with backends that support it (S3+DynamoDB, Consul, Terraform Cloud)
- `terraform force-unlock` should only be used when you are sure no other operation is running
- Always version your S3 bucket so you can recover a previous state file if something goes wrong

---

## Documentation
Create `day-64-state-management.md` with:
- Diagram: local state vs remote state setup
- Screenshot of state file in S3 bucket
- Screenshot of the lock error from Task 3
- Steps you followed for `terraform import` and the result
- Explanation of state drift with your real example
- When to use: `state mv`, `state rm`, `import`, `force-unlock`, `refresh`

