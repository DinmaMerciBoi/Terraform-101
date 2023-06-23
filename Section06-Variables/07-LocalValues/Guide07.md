# Local Values

Terraform local values (or "locals") assign a name to an expression or value. Using locals simplifies your Terraform configuration – since you can reference the local multiple times, you reduce duplication in your code. 

Locals can also help you write more readable configuration by using meaningful names rather than hard-coding values.

## Update tags

So far we've been using the following tag for our EC2 instance:

```bash
  tags = {
    "Name" = "webserver-${terraform.workspace}"
  }
```

It's time to change this.

We're going to give the user the option to add some tags, but also have certain mandatory tags for all our resources. This can be determined by the DevOps team.

We'll use a combination of locals and variables to do this.

### Create new variables

In the `variables.tf` file, uncomment:

```bash
variable "project_name" {
  description = "Name of the project."
  type        = string
  default     = "my-project"
}

variable "environment" {
  description = "Name of the environment."
  type        = string
  default     = "dev"
}

variable "resource_tags" {
  description = "User defined tags to set for all resources"
  type        = map(string)
  default     = {}
}
```

Notice we have created 3 new variables: `project_name`, `environment`, and `resource_tags`. These 3 variables allow the developer to assign.

### Create locals

Now uncomment the locals block below in the `main.tf` file:

```bash
locals {
  name_suffix = "${var.project_name}-${var.environment}"
  required_tags = {
    Name        = local.name_suffix
    project     = var.project_name
    environment = var.environment
  }
  mytags = merge(var.resource_tags, local.required_tags)
}
```

Notice that we have the ability to assign variable interpolation and other variables and other locals to locals. You can't do that with variables. Variables can't be assigned other variables.

Also notice how we use locals in the `aws_instance` resource block:

`tags = local.mytags`

we use the singular word `local` followed by a `.` followed by the name of the local value.

### Add Output tags

Uncomment the output below in the `outputs.tf`:

```bash
output "tags" {
  value = local.mytags
}
```

Then run:

```bash
terraform init
terraform plan
```

Notice the output for tags:

```
  + tags        = {
      + Name        = "my-project-dev"
      + environment = "dev"
      + project     = "my-project"
    }
```

### Create user defined tags

Uncomment the `resource_tags` variable in the `variables1.auto.tfvars` file:

```bash
resource_tags = {
  department     = "engineering"
  developer_name = "sam"
}
```

and run:
```bash
terraform plan
```

Notice the output for tags:

```
  + tags        = {
      + Name           = "my-project-dev"
      + department     = "engineering"
      + developer_name = "sam"
      + environment    = "dev"
      + project        = "my-project"
    }
```

The merge function merged both the user defined tags via the `resource_tags` map variable and the `required_tags` local map value.

## Terraform Apply

Now terraform apply to verify that all works.

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following command
```bash
terraform apply --auto-approve
```

Check the AWS console to see the VM instance.

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.