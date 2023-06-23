# Sensitive Variables

Terraform allows you to declare certain variables as sensitive. It also allows you to declare sensitive outputs. Let's check this out in this lab.

## Try without sensitive values

Let's assume that the ingress ports that we're opening for the EC2 instance are considered sensitive.

Take a look at the `variables.tf` file and notice the keyword `sensitive = false`. This is the default for any variable if you omit the keyword `sensitive`.

`variables.tf` file:
```bash
variable "ssh_port" {
  type        = number
  description = "SSH port number for EC2 ingress in security group."
  default     = 22
  sensitive   = false
}

variable "http_port" {
  type        = number
  description = "http port number for EC2 ingress in security group"
  default     = 80
  sensitive   = false
}
```

Now Initialize terraform and run a plan:

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands
```bash
terraform init
terraform plan
```

Notice that we get the output below showing the input ports for ingress as expected after running the plan:

```bash
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "HTTP Ingress"
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "SSH Ingress"
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
            },
        ]
```

## Use sensitive values

Now change the `ssh_port` and `http_port` variables to `sensitive` in the `variables.tf` file to show:

```bash
variable "ssh_port" {
  type        = number
  description = "SSH port number for EC2 ingress in security group."
  default     = 22
  sensitive   = true
}

variable "http_port" {
  type        = number
  description = "http port number for EC2 ingress in security group"
  default     = 80
  sensitive   = true
}
```

Run `terraform plan` now.

Notice the ingress field shows `sensitive` now:

```bash
 + ingress                = (sensitive)
```

Also notice the output, the `private_key` is sensitive along with the `security_group_ingress`.

```bash
Changes to Outputs:
  + private_ip             = (known after apply)
  + private_key            = (sensitive value)
  + public_ip              = (known after apply)
  + security_group_ingress = (sensitive value)
```

## Try changing the output sensitive values

In the `outputs.tf` file, try changing the `private_key` and the `security_group_ingress` to NOT be sensitive values like this:

```bash
output "private_key" {
  value     = tls_private_key.mykey.private_key_pem
  sensitive = false
}
output "security_group_ingress" {
  value = aws_security_group.security_group1.ingress
  sensitive = false
}
```

Run `terraform plan` again and notice the error messages regarding `Output referes to sensitive values`

Terraform is smart enough to understand that some values are sensitive in nature depending on the Terraform provider. In this case the `private_key` is sensitive by nature as part of the `tls` provider. 

The `security_group_ingress` output is sensitive because we declared it sensitive in the `variables.tf` file.

Go back and change `sensitive = true` for both `private_key` and the `security_group_ingress` outputs as follows:

```bash
output "private_key" {
  value     = tls_private_key.mykey.private_key_pem
  sensitive = true
}
output "security_group_ingress" {
  value = aws_security_group.security_group1.ingress
  sensitive = true
}
```

## Terraform Apply

Now terraform apply with our sensitive values.

Run the following command:
```bash
terraform apply --auto-approve
```

Check the AWS console to see the VM instance.

## Let's check our state

Run:
```bash
terraform state list
```

Output:
```
data.aws_ami.ubuntu
aws_instance.webserver
aws_key_pair.mykey
aws_security_group.security_group1
tls_private_key.mykey
```

Now run:
```bash
terraform state show aws_security_group.security_group1
```

Output
```
# aws_security_group.security_group1:
resource "aws_security_group" "security_group1" {
    arn                    = "arn:aws:ec2:us-east-2:706933696988:security-group/sg-0925ff43337f00949"
    description            = "Managed by Terraform"
    egress                 = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
        },
    ]
    id                     = "sg-0925ff43337f00949"
    ingress                = (sensitive)
    name                   = "terraform-20220901162812423400000001"
    name_prefix            = "terraform-"
    owner_id               = "706933696988"
    revoke_rules_on_delete = false
    tags_all               = {}
    vpc_id                 = "vpc-0a621050e4b82066d"
}
```

Notice how `ingress` is still sensitive, which is great! However, if you check the `terraform.tfstate` file, you will see the values there. So always remember that the state file itself will give you access to the sensitive data.

# Check our outputs

Now try this:

```bash
terraform output -raw private_key
terraform output -json security_group_ingress
```

We do end up with the sensitive values from the output! So be aware of this. However, adding sensitive values is definitely a welcomed improvement to Terraform. This is because most of the time, Terraform is run from within pipelines and these sensitive values won't show up during the terraform plan or apply within the CI/CD pipeline execution.

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.