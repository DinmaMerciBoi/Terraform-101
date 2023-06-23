# Variable Validation

Terraform gives us the option to put some conditions on variables and it checks the validity.

## Add a Condition on the SSH Port Variable

Check the `variables.tf` file. We've added the validation block below:

```bash
variable "ssh_port" {
  type        = number
  description = "SSH port number for EC2 ingress in security group."
  default     = 22
  sensitive   = true
  validation {
    condition = var.ssh_port == 22
    error_message = "SSH Port has to be port 22."
  }
}
```

As you see, we are forcing that the assignment of the `ssh_port` variable has to be port 22.

Now go to the `variables1.auto.tfvars` file and change `ssh_port = 22` to `ssh_port = 23`.

Now run:

```bash
terraform init
terraform plan
```

Notice the error message:

```
│ Error: Invalid value for variable
│ 
│   on variables.tf line 19:
│   19: variable "ssh_port" {
│     ├────────────────
│     │ var.ssh_port is 23
│ 
│ SSH Port has to be port 22.
│ 
│ This was checked by the validation rule at
│ variables.tf:24,3-13.
```

Now go back to the `variables1.auto.tfvars` file and change the `ssh_port` back to 22.

Run:
```bash
terraform plan
```

You should no longer get that error message.

