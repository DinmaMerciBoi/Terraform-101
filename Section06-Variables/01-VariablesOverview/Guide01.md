# Variables Overview

Let's learn the basics about input variables in this lab. Variables are used so that you define them once in one place and re-use them in many other places. If you need to make a change, then you change it once in one place.

## Declare a variable called my_instance_type

Instead of hardcoding the `instance_type` to  `t2.micro` for the `aws_instance` let's create a variable to store this value.

In the `main.tf` file, type the below variable block just above the `aws_ami` data block:

```bash
variable "my_instance_type" {}
```

## Reference the my_instance_type variable

Now we need to reference this variable in the `aws_instance` resource.

Replace `t2.micro` with `var.my_instance_type`

## Check with terraform plan

Run terraform init and plan 

```bash
terraform init
terraform plan
```

Notice the prompt asking for a value for the `my_instance_type` variable.

Enter: `t2.micro`

Now that's not ideal to get a prompt every time. Let's provide the variable on the cli command. 

## Variables on CLI

So run:

```bash
terraform plan -var my_instance_type="t2.micro"
```

This method is very useful with CI/CD pipelines.

## Variables via Environment Variables

Now let's try assigning the variable using an environment variable

```bash
export TF_VAR_my_instance_type="t2.micro"
terraform plan
```

This is another way to assign the variable. Now let's unset this environment variable, run the following command:

```bash
unset TF_VAR_my_instance_type
```

## Use a default value

We can also specify a default value with the variable declaration.

In `main.tf` add `default = "t2.micro"` in the variable block to look like this:

```bash
variable "my_instance_type" {
    default = "t2.micro"
}
```

## Apply

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