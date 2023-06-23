# Create an EC2 Module

In this lab we're going to build our fourth module for our EC2 instances using an auto-scaling group. We created a new folder in the `modules` folder called `ec2`. This is our `ec2` module.

## How to call the Module

In the `main.tf` file of the `root` module, notice at the end of the file how we call the `ec2` module:

```bash
module "ec2" {
  source            = "./modules/ec2"
  region            = var.region
  public_key        = module.tls.public_key_out
  my_aws_key        = var.my_aws_key
  security_group_id = module.networking.security_group_id
  my_instance_type  = var.my_instance_type
  my_user_data      = local.my_user_data
  mytags            = local.mytags
  subnets           = module.networking.subnets
  target_group_arn  = module.lb.target_group_arn
}
```

We can add variables into the module. All the values under the `source` are variable assignments into the module.

We then need to declare these variables via the `variables.tf` file in the `ec2` module folder.

Any variable that has defaults in the declaration is considered optional to specify in the module block above.

> Note that some variable assignments are using the outputs of other modules.

## The Module Folder Structure

We are using the same folder structure as other modules made up of 5 files:

- LICENSE
- README.md
- main.tf
- variables.tf
- outputs.tf

## The main.tf file for the ec2 module

In `main.tf` for the `ec2` module, we've moved the following resources:

- aws_key_pair
- aws_launch_template
- aws_autoscaling_group

along with the data block:
- aws_ami

## The outputs.tf file for the ec2 module

Notice below that the `outputs.tf` file has one output for tags:

```bash
output "tags" {
  value       = { for tag in aws_autoscaling_group.webserver.tag : values(tag)[0] => values(tag)[2] }
  description = "ASG tags"
}
```

Similar to what we did with the previous modules, this output gets passed back to the `root` module.

We then use this output in the `outputs.tf` file of the `root` module:

```bash
output "tags" {
  value       = module.ec2.tags
}
```

## Run Terraform

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands
```bash
terraform init
terraform apply --auto-approve
```

Congratulations, you should get the same output as before but now you've moved all networking resources into a separate module!

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.