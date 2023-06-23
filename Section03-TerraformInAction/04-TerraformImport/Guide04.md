# Terraform Import

Suppose an engineer on your team decided to create an EC2 instance in AWS directly via the console and without using Terraform. 

Terraform doesn't know anything about this resource and therefore won't know to add it to its state file.

Now there is a way to import this resource into our state file, but we still need to manually write the configuration for it. [You can see this in the documentation.](https://www.terraform.io/cli/import#currently-state-only)

## Recreate the EC2 Instance

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands
```bash
terraform init
terraform apply --auto-approve
```

Check the AWS console to see the VM instance.

## Create a new EC2 Instance via the Console

Now go ahead and create a new EC2 instance via the AWS console. Use Amazon Linux to be a bit different.

Now check the documentation for the [import command for aws_instance resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)

Then run this command:

```bash
terraform import aws_instance.console <instance_id>
terraform plan
```

Notice that you get an error message that we're missing the configuration.

Uncomment the resource block below in the `main.tf` file to add the proper configuration:

```bash
resource "aws_instance" "console" {
  ami           = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"
}
```

Now run:

```bash
terraform plan
terraform apply --auto-approve
```

Now run `terraform state list` and notice we have two `aws_instances` in the state file.

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instances are terminated.