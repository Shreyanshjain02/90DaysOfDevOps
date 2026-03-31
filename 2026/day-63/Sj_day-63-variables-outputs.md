# Day 63 -- Variables, Outputs, Data Sources and Expressions

## Task
Your Day 62 config works, but it is full of hardcoded values -- region, CIDR blocks, AMI IDs, instance types, tags. Change the region and everything breaks. Today you make your Terraform configs dynamic, reusable, and environment-aware.

This is the difference between a config that works once and a config you can use across projects.


## Challenge Tasks

### Task 1: Extract Variables
Take your Day 62 infrastructure config and refactor it:

1. Create a `variables.tf` file with input variables for:
   - `region` (string, default: your preferred region)
   - `vpc_cidr` (string, default: `"10.0.0.0/16"`)
   - `subnet_cidr` (string, default: `"10.0.1.0/24"`)
   - `instance_type` (string, default: `"t2.micro"`)
   - `project_name` (string, no default -- force the user to provide it)
   - `environment` (string, default: `"dev"`)
   - `allowed_ports` (list of numbers, default: `[22, 80, 443]`)
   - `extra_tags` (map of strings, default: `{}`)

2. Replace every hardcoded value in `main.tf` with `var.<name>` references
3. Run `terraform plan` -- it should prompt you for `project_name` since it has no default


<img width="566" height="200" alt="image" src="https://github.com/user-attachments/assets/f124f540-261c-4822-8ae7-c0ad37294311" />


**Document:** What are the five variable types in Terraform? (`string`, `number`, `bool`, `list`, `map`)

---

### Task 2: Variable Files and Precedence
1. Create `terraform.tfvars`:
```hcl
project_name = "terraweek"
environment  = "dev"
instance_type = "t2.micro"
```

2. Create `prod.tfvars`:
```hcl
project_name = "terraweek"
environment  = "prod"
instance_type = "t3.small"
vpc_cidr     = "10.1.0.0/16"
subnet_cidr  = "10.1.1.0/24"
```

3. Apply with the default file:
```bash
terraform plan                              # Uses terraform.tfvars automatically
```

4. Apply with the prod file:
```bash
terraform plan -var-file="prod.tfvars"      # Uses prod.tfvars
```

5. Override with CLI:
```bash
terraform plan -var="instance_type=t2.nano"  # CLI overrides everything
```

6. Set an environment variable:
```bash
export TF_VAR_environment="staging"
terraform plan                              # env var overrides default but not tfvars
```

**Document:** Write the variable precedence order from lowest to highest priority.

Terraform allows you to feed values into your root module using several methods. From the most manual to the most automated, they are:

- Environment Variables: Prefixing your system variables with TF_VAR_.
- The terraform.tfvars file: The default file Terraform automatically looks for in your current directory.
- The terraform.tfvars.json file: The JSON equivalent of the default file.
- Auto-loaded files (*.auto.tfvars or *.auto.tfvars.json): Any file ending in this extension in the current directory will be automatically processed.
- CLI flags (-var or -var-file): Passing values or custom files directly into the command line when running a plan or apply.

**Order**
- Environment Variables (**Lowest**)
   Example: export TF_VAR_environment="Development"
- The terraform.tfvars file
   Example: environment = "Staging" (This overrides the environment variable above).
- The terraform.tfvars.json file
   Note: If both a .tfvars and a .tfvars.json exist, they have the same priority level, but the JSON file is read last and will override the HCL file.
   Any *.auto.tfvars or *.auto.tfvars.json files
   Example: common.auto.tfvars. These are evaluated in alphabetical order by filename. A file named z.auto.tfvars will override a.auto.tfvars.
- Command-line flags (-var and -var-file) (**Highest**)
   Example: terraform plan -var-file="production.tfvars" or terraform plan -var="environment=Production".
   Note: Anything you explicitly type into the CLI always wins. If you use multiple -var or -var-file flags, Terraform processes them from left to right, meaning the rightmost flag has the ultimate final say.



---

### Task 3: Add Outputs
Create an `outputs.tf` file with outputs for:

1. `vpc_id` -- the VPC ID
2. `subnet_id` -- the public subnet ID
3. `instance_id` -- the EC2 instance ID
4. `instance_public_ip` -- the public IP of the EC2 instance
5. `instance_public_dns` -- the public DNS name
6. `security_group_id` -- the security group ID

```bash
terraform plan
```

<img width="454" height="175" alt="image" src="https://github.com/user-attachments/assets/cf1785a2-9a89-4f2f-a1a1-5ea0037cde05" />


Apply your config and verify the outputs are printed at the end:
```bash
terraform apply

# After apply, you can also run:
terraform output                          # Show all outputs
terraform output instance_public_ip       # Show a specific output
terraform output -json                    # JSON format for scripting
```
<img width="590" height="170" alt="image" src="https://github.com/user-attachments/assets/436762d1-79da-47c7-a94b-10f778712d83" />

**Verify:** Does `terraform output instance_public_ip` return the correct IP?
Yes public Ip is correct

---

### Task 4: Use Data Sources
Stop hardcoding the AMI ID. Use a data source to fetch it dynamically.

1. Add a `data "aws_ami"` block that:
   - Filters for Amazon Linux 2 images
   - Filters for `hvm` virtualization and `gp2` root device
   - Uses `owners = ["amazon"]`
   - Sets `most_recent = true`

2. Replace the hardcoded AMI in your `aws_instance` with `data.aws_ami.amazon_linux.id`

3. Add a `data "aws_availability_zones"` block to fetch available AZs in your region

4. Use the first AZ in your subnet: `data.aws_availability_zones.available.names[0]`

Apply and verify -- your config now works in any region without changing the AMI.

<img width="953" height="263" alt="image" src="https://github.com/user-attachments/assets/06783987-6dcd-4b5e-a26e-60c9ca11dfb9" />


**Document:** What is the difference between a `resource` and a `data` source?

resource like service we are using example ec2 instance, s3 bucket etc. More  A resource is used when you want Terraform to create, update, or delete something in your cloud provider.
A data source is a read-only query. You use it when you need to fetch information about something that already exists in your AWS account, but your current Terraform code did not build it.

---


### Task 5: Use Locals for Dynamic Values
1. Add a `locals` block:
```hcl
locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
```

2. Replace all Name tags with `local.name_prefix`:
   - VPC: `"${local.name_prefix}-vpc"`
   - Subnet: `"${local.name_prefix}-subnet"`
   - Instance: `"${local.name_prefix}-server"`

3. Merge common tags with resource-specific tags:
```hcl
tags = merge(local.common_tags, {
  Name = "${local.name_prefix}-server"
})
```

Apply and check the tags in the AWS console -- every resource should have consistent tagging.

<img width="953" height="356" alt="image" src="https://github.com/user-attachments/assets/633ef040-b431-4daa-b11a-2bcc44097066" />

<img width="545" height="436" alt="image" src="https://github.com/user-attachments/assets/f45f0cee-5931-4f6a-95ce-d12b06dc4843" />

<img width="955" height="22" alt="image" src="https://github.com/user-attachments/assets/43a37978-93bb-4505-b5cc-b0456c685498" />

---

### Task 6: Built-in Functions and Conditional Expressions
Practice these in `terraform console`:
```bash
terraform console
```

1. **String functions:**
   - `upper("terraweek")` -> `"TERRAWEEK"`
   - `join("-", ["terra", "week", "2026"])` -> `"terra-week-2026"`
   - `format("arn:aws:s3:::%s", "my-bucket")`

2. **Collection functions:**
   - `length(["a", "b", "c"])` -> `3`
   - `lookup({dev = "t2.micro", prod = "t3.small"}, "dev")` -> `"t2.micro"`
   - `toset(["a", "b", "a"])` -> removes duplicates

3. **Networking function:**
   - `cidrsubnet("10.0.0.0/16", 8, 1)` -> `"10.0.1.0/24"`

<img width="511" height="258" alt="image" src="https://github.com/user-attachments/assets/28a8d050-084a-431f-b7be-97e4b2f29358" />


4. **Conditional expression** -- add this to your config:
```hcl
instance_type = var.environment == "prod" ? "t3.small" : "t2.micro"
```

Apply with `environment = "prod"` and verify the instance type changes.

**Document:** Pick five functions you find most useful and explain what each does.

---

## Hints
- `terraform.tfvars` is loaded automatically. Any other `.tfvars` file needs `-var-file`
- Variable precedence (low to high): default -> `terraform.tfvars` -> `*.auto.tfvars` -> `-var-file` -> `-var` flag -> `TF_VAR_*` env vars
- `terraform console` is an interactive REPL for testing expressions and functions
- Data sources are read-only -- they fetch information, they don't create resources
- `merge()` combines two maps -- great for tags
- `terraform output -json` is useful when piping output into other scripts

---

## Documentation
Create `day-63-variables-outputs.md` with:
- Your `variables.tf` with all variable types
- Both `.tfvars` files (dev and prod)
- Screenshot of outputs after `terraform apply`
- Explanation of variable precedence with examples
- Five built-in functions you found most useful
- The difference between `variable`, `local`, `output`, and `data`


