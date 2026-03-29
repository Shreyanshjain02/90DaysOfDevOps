# Day 61 -- Introduction to Terraform and Your First AWS Infrastructure

## Task
You have been deploying containers, writing CI/CD pipelines, and orchestrating workloads on Kubernetes. But who creates the servers, networks, and clusters underneath? Today you start your Infrastructure as Code journey with Terraform -- the tool that lets you define, provision, and manage cloud infrastructure by writing code.

By the end of today, you will have created real AWS resources using nothing but a `.tf` file and a terminal.

## Challenge Tasks

### Task 1: Understand Infrastructure as Code
Before touching the terminal, research and write short notes on:

1. What is Infrastructure as Code (IaC)? Why does it matter in DevOps?
- Infrastructure as Code (IaC) is the management and provisioning of infrastructure (servers, networks, databases) using machine-readable definition files (code) rather than manual configuration. key aspect are:
  1. Automation
  2. consistency
  3. Version control
  4. Reduce risk (No/less human error)
  5. Cost efficiency(Fast and efficient way)
  6. Scalability
  7. types : Declarative (Terraform,AWS cloudformation etc)(defining the desired state) and imperative  (shell scripts etc) (defining commands to achieve state).

2. What problems does IaC solve compared to manually creating resources in the AWS console?
- Automation, Cost , Risk (human Error) , Scalability , Replication.

3. How is Terraform different from AWS CloudFormation, Ansible, and Pulumi?

4. What does it mean that Terraform is "declarative" and "cloud-agnostic"?
- It means terraform proivide desired end-state of infrastracture i.e. creating S3 bucket here we are declaring to to create s3 bucket instead of writing steps to create s3 bucket. also as terraform is supported by large number of cloud providers that why it an cloud agnostic.

---

### Task 2: Install Terraform and Configure AWS
1. Install Terraform:
```bash
# macOS
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Linux (amd64)
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Windows
choco install terraform
```

2. Verify:
```bash
terraform -version
```

3. Install and configure the AWS CLI:
```bash
aws configure
# Enter your Access Key ID, Secret Access Key, default region (e.g., ap-south-1), output format (json)
```

4. Verify AWS access:
```bash
aws sts get-caller-identity
```

You should see your AWS account ID and ARN.

<img width="401" height="119" alt="image" src="https://github.com/user-attachments/assets/639988c3-f35d-4222-891c-4e565ecfd804" />

---

### Task 3: Your First Terraform Config -- Create an S3 Bucket
Create a project directory and write your first Terraform config:

```bash
mkdir terraform-basics && cd terraform-basics
```

Create a file called `main.tf` with:
1. A `terraform` block with `required_providers` specifying the `aws` provider
2. A `provider "aws"` block with your region
3. A `resource "aws_s3_bucket"` that creates a bucket with a globally unique name

Run the Terraform lifecycle:
```bash
terraform init      # Download the AWS provider
terraform plan      # Preview what will be created
terraform apply     # Create the bucket (type 'yes' to confirm)
terraform state list   #Shows all resources created.
```

Go to the AWS S3 console and verify your bucket exists.

<img width="954" height="419" alt="image" src="https://github.com/user-attachments/assets/9992464d-891d-4d2d-bd75-41d3232d3e02" />


**Document:** What did `terraform init` download? What does the `.terraform/` directory contain?

terraform init download all provider's version and detail used in your .tf file.which will make your resources to work smoothly 

---

### Task 4: Add an EC2 Instance
In the same `main.tf`, add:
1. A `resource "aws_instance"` using AMI `ami-0f5ee92e2d63afc18` (Amazon Linux 2 in ap-south-1 -- use the correct AMI for your region)
2. Set instance type to `t2.micro`
3. Add a tag: `Name = "TerraWeek-Day1"`

_I am creating Amazon Linux 2 EC2 on us-west-2 region with t3.micro_

Run:
```bash
terraform plan      # You should see 1 resource to add (bucket already exists) - YES
terraform apply
```

Go to the AWS EC2 console and verify your instance is running with the correct name tag.

**Document:** How does Terraform know the S3 bucket already exists and only the EC2 instance needs to be created?

<img width="951" height="348" alt="image" src="https://github.com/user-attachments/assets/dcf09681-f588-4e52-b0c9-7d69bc98d3f3" />


---

### Task 5: Understand the State File
Terraform tracks everything it creates in a state file. Time to inspect it.

1. Open `terraform.tfstate` in your editor -- read the JSON structure

2. Run these commands and document what each returns:
```bash
terraform show                          # Human-readable view of current state
terraform state list                    # List all resources Terraform manages

<img width="416" height="52" alt="image" src="https://github.com/user-attachments/assets/c32cb60b-0508-44f5-bff1-b9823e3cb4d0" />

terraform state show aws_s3_bucket.<name>   # Detailed view of a specific resource

<img width="577" height="396" alt="image" src="https://github.com/user-attachments/assets/d9d1c418-0b02-4c68-acef-f954ac401ea4" />


terraform state show aws_instance.<name>
```

3. Answer these questions in your notes:
   - What information does the state file store about each resource?

     It maps your configuration to real-world resources. Beyond just arguments (like null or false values), it stores crucial metadata like resource IDs, dependencies between objects, and the current status of every managed component.
     
   - Why should you never manually edit the state file?

      It’s not just about debugging; it's about corruption. The state file is a sensitive JSON mapping. Even a small typo or structural error can make Terraform lose track of your infrastructure, leading to accidental deletions or "ghost" resources that you can't manage anymore.

     
    - Why should the state file not be committed to Git?

     It often contains secrets in plain text (like database passwords or private keys) that shouldn't be in your version history. Git doesn't support locking. If two people commit changes at once, you’ll get merge conflicts that are nearly impossible to resolve safely
   
---

### Task 6: Modify, Plan, and Destroy
1. Change the EC2 instance tag from `"TerraWeek-Day1"` to `"TerraWeek-Modified"` in your `main.tf`
2. Run `terraform plan` and read the output carefully:
   - What do the `~`, `+`, and `-` symbols mean?
  ~ means places where update in-place
  + Addition
  - deletion
  -> modification
     
   - Is this an in-place update or a destroy-and-recreate?
   - Its an in-place update not destroy and recreate.
     
3. Apply the change
4. Verify the tag changed in the AWS console

<img width="947" height="464" alt="image" src="https://github.com/user-attachments/assets/1b05c833-166d-484e-8e4e-a1c79288fa2a" />


5. Finally, destroy everything:
```bash
terraform destroy
```
6. Verify in the AWS console -- both the S3 bucket and EC2 instance should be gone

---

## Hints
- S3 bucket names must be globally unique -- use something like `terraweek-<yourname>-2026`
- AMI IDs are region-specific -- search "Amazon Linux 2 AMI" in your region's EC2 launch wizard
- `terraform fmt` auto-formats your `.tf` files -- run it before committing
- `terraform validate` checks for syntax errors without connecting to AWS
- The `.terraform/` directory contains downloaded provider plugins
- Add `*.tfstate`, `*.tfstate.backup`, and `.terraform/` to your `.gitignore`

---

## Documentation
Create `day-61-terraform-intro.md` with:
- IaC explanation in your own words (3-4 sentences)
- Screenshot of `terraform apply` creating your S3 bucket and EC2 instance
- Screenshot of the resources in the AWS console
- What each Terraform command does (init, plan, apply, destroy, show, state list)
- What the state file contains and why it matters
