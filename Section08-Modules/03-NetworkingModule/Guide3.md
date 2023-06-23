# Create a Networking Module

In this lab we're going to build our third module to encompass all our networking. We created a new folder in the `modules` folder called `networking`. This is our `networking` module.

## How to call the Module

In the `main.tf` file of the `root` module, notice at the end of the file how we call the `networking` module:

```bash
module "networking" {
  source                     = "./modules/networking"
  region                     = var.region
  mytags                     = local.mytags
  address_space              = var.address_space
  availability_zones_subnets = var.availability_zones_subnets
  allow_public_ips           = var.allow_public_ips
  project_name               = var.project_name
  inbound_ports              = local.inbound_ports
}
```

We can add variables into the module. All the values under the `source` are variable assignments into the module.

We then need to declare these variables via the `variables.tf` file in the `networking` module folder.

Any variable that has defaults in the declaration is considered optional to specify in the module block above.

## The Module Folder Structure

We are using the same folder structure as other modules made up of 5 files:

- LICENSE
- README.md
- main.tf
- variables.tf
- outputs.tf

## The main.tf file for the networking module

In `main.tf` for the `networking` module, we've moved the following resources:

- aws_vpc
- aws_subnet
- aws_security_group
- aws_internet_gateway
- aws_route_table
- aws_route_table_association

## The outputs.tf file for the networking module

Notice below that the `outputs.tf` file has three outputs:

```bash
output "vpc_id" {
  value = aws_vpc.schoolapp.id
}

output "security_group_id" {
  value = aws_security_group.security_group1.id
}

output "subnets" {
  value = [for subnet in aws_subnet.schoolapp : subnet.id]
}
```

Similar to what we did with the previous modules, these outputs get passed back to the `root` module.

You can see how we use these outputs as inputs to other modules such as the `lb` module below in the `root` module's `main.tf` file:

```bash
module "lb" {
  source       = "./modules/lb"
  region_in    = var.region
  vpc_id       = module.networking.vpc_id
  ssh_port     = var.ssh_port
  http_port    = var.http_port
  project_name = var.project_name
  mytags       = local.mytags
  subnets      = module.networking.subnets
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