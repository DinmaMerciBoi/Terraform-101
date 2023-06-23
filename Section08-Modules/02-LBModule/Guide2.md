# Create a Load Balancer Module

In this lab we're going to build our second module for the load balancer. We created a new folder in the `modules` folder called `lb`. This is our `lb` module.

## How to call the Module

In the `main.tf` file of the `root` module, notice at the end of the file how we call the `lb` module:

```bash
module "lb" {
  source = "./modules/lb"
  region_in = var.region
  vpc_id = aws_vpc.schoolapp.id
  ssh_port = var.ssh_port
  http_port = var.http_port
  project_name = var.project_name
  mytags = local.mytags
  subnets = [for subnet in aws_subnet.schoolapp : subnet.id]
}
```

We can add variables into the module. All the values under the `source` are variable assignments into the module.

We then need to declare these variables via the `variables.tf` file in the `lb` module folder.

Any variable that has defaults in the declaration is considered optional to specify in the module block above.

## The Module Folder Structure

The folder structure is the same as the `tls` module made up of 5 files:

- LICENSE
- README.md
- main.tf
- variables.tf
- outputs.tf

## The main.tf file for the lb module

In `main.tf` for the `lb` module, we've moved the following resources:

- aws_lb
- aws_lb_listener
- aws_security_group
- aws_lb_target_group
- aws_lb_listener_rule

## The outputs.tf file for the lb module

Notice below that the `outputs.tf` file has two outputs:

```bash
output "LB_DNS_Name_Out" {
  value = aws_lb.schoolapp.dns_name
  description = "The LB domain name"
}

output "target_group_arn" {
  value = aws_lb_target_group.schoolapp.arn
}
```

Similar to what we did with the `tls` module, these outputs get passed back to the `root` module.

1. The `LB_DNS_Name_Out` is passed to the output of the `root` module.
2. The `target_group_arn` is used by the `aws_autoscaling_group` resoure in the `main.tf` file of the `root` module:

```bash
resource "aws_autoscaling_group" "webserver" {
...
  target_group_arns = [module.lb.target_group_arn]
...
}
```

## The outputs.tf file of the root module

Notice how we called on the output of the `lb` module using: `module.lb.LB_DNS_Name_Out` to send that output from the `root` module to the user:

```bash
output "LB_DNS_Name" {
  value = module.lb.LB_DNS_Name_Out
  description = "The LB domain name"
}
```

## Run Terraform

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands
```bash
terraform init
terraform apply --auto-approve
```

Congratulations, you should get the same output as before but now you've used 2 modules with variables into the `lb` module!

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.