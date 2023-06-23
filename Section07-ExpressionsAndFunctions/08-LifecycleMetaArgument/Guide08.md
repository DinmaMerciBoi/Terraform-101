# Life Cycle Meta-Argument

Since we now have a cluster of 3 web servers, we still would need to manage them manually. However, AWS gives us the option to manage them for us automatically using an Auto Scaling Group (ASG).

An ASG looks after tasks such as:
- Launching a cluster of EC2 instances.
- Monitoring the health of the instances
- Replacing failed instances based on health checks
- Increasing or Decreasing the size of the cluster based on load

In this lab we will create an ASG and learn about the Life Cycle Meta-Argument called `create_before_destroy`.

## Create a Launch Configuration

We first need to create a launch configuration which allows us to specify the configuration of each EC2 instance in the ASG.

The `aws_launch_configuration` resource is very similar to the `aws_instance` resource. Take a look below from the `main.tf` file:

```bash
resource "aws_launch_configuration" "webserver" {
  name_prefix                 = "schoolapp-"
  image_id                    = data.aws_ami.ubuntu.id
  instance_type               = var.my_instance_type
  security_groups             = [aws_security_group.security_group1.id]
  key_name                    = aws_key_pair.mykey.key_name
  user_data                   = local.my_user_data
  associate_public_ip_address = true
  # lifecycle {
  #   create_before_destroy = true
  # }
}
```

Keep the `lifecycle` block commented for now. More on this later.

## Add a New Map Variable for AZs and Subnets

We've added the `availability_zones_subnets` variable to the `variables.tf` file as shown below:

```bash
variable "availability_zones_subnets" {
  type        = map(string)
  description = "Availability Zones to use with subnets"
  default = {
    "us-east-1a" : "10.0.10.0/24",
    "us-east-1b" : "10.0.11.0/24",
    "us-east-1c" : "10.0.12.0/24"
  }
}
```

## Update the Subnet Resource

In `networking.tf` we update the `aws_subnet` resource to use `for_each` to create 3 subnets in 3 availability_zones.

```bash
resource "aws_subnet" "schoolapp" {
  for_each                = var.availability_zones_subnets
  vpc_id                  = aws_vpc.schoolapp.id
  availability_zone       = each.key
  cidr_block              = each.value
  map_public_ip_on_launch = var.allow_public_ips
  tags                    = local.mytags
}
```

## Update the Route Table Association

In `networking.tf`:

```bash
resource "aws_route_table_association" "schoolapp" {
  for_each       = var.availability_zones_subnets
  subnet_id      = aws_subnet.schoolapp[each.key].id
  route_table_id = aws_route_table.schoolapp.id
}
```

## Create an AutoScaling Group

Now it's time to creat the `aws_autoscaling_group`. Check it out below in the `main.tf` file below.

```bash
resource "aws_autoscaling_group" "webserver" {
  launch_configuration = aws_launch_configuration.webserver.name
  vpc_zone_identifier  = [for subnet in aws_subnet.schoolapp : subnet.id]
  min_size             = 2
  max_size             = 3
  desired_capacity     = 3

  dynamic "tag" {
    for_each = local.mytags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
```

Notice that we call on the Launch Configuration. We also need to specify the subnets to use which are located in the different `availability_zones`. We have a for expression to iterate over these subnets we created and grab their ids.

Also notice how we're using a `dynamic` block to build the tags. This is because in `aws_autoscaling_group` the tags configuration looks different than what we saw before. You will see this in the output of Terraform shortly.

## Update the Output File

Since we're using an ASG (AutoScalingGroup), we don't really need to worry about the IPs of the individual EC2 instance. AWS is managing them for us. Soon we will add a load balancer in front of them and use that IP to access our instances.

In the `outputs.tf` file we commented out the private and public ips.

As for the tags, we added the following and commented the old tags output:

```bash
output "tags" {
  value       = aws_autoscaling_group.webserver.tag
  description = "ASG tags"
}
```

## Terraform Apply

Now terraform apply to verify that all works.

Run the following commands:
```bash
terraform apply --auto-approve
```

Check the AWS console to see the EC2 instances and verify that each is in a separate AZ with separate subnets.

Check also by going to one of the public IPs that the webservers are running.

## Update the Launch Configuration

Now let's make an update to our launch configuration by changing the `name_prefix = schoolapp-test-` in `main.tf` as shown below and still keep the `lifecycle` block commented:

```bash
resource "aws_launch_configuration" "webserver" {
  name_prefix                 = "schoolapp-test-"
  image_id                    = data.aws_ami.ubuntu.id
  instance_type               = var.my_instance_type
  security_groups             = [aws_security_group.security_group1.id]
  key_name                    = aws_key_pair.mykey.key_name
  user_data                   = local.my_user_data
  associate_public_ip_address = true
  # lifecycle {
  #   create_before_destroy = true
  # }
}
```

Run:

```bash
terraform apply --auto-approve
```

This will take a few minutes trying to destroy the `aws_launch_configuration` and then fails with an error saying that it can't delete it because it is attached to the AutoScalingGroup.

Terraform's default behavior is to destroy before create. So it's trying to destroy the `aws_launch_configuration` before it creates a new one. However, it can't destroy it because it's attached to the AutoScalingGroup.

The `aws_launch_configuration` is immutable, and that's why Terraform needs to destroy if any of its settings changes.

To solve this, we use the `lifecycle` meta-argument to reverse terraform's behavior by creating the `aws_launch_configuration` before destroying it. So terraform will associate the AutoScalingGroup with the new `aws_launch_configuration` freeing up the old one to be deleted.


Output:

```bash
Plan: 1 to add, 1 to change, 1 to destroy.

aws_launch_configuration.webserver: Destroying... [id=schoolapp-test-20220907202611978200000001]
aws_launch_configuration.webserver: Still destroying... [id=schoolapp-test-20220907202611978200000001, 10s elapsed]
aws_launch_configuration.webserver: Still destroying... [id=schoolapp-test-20220907202611978200000001, 20s elapsed]
aws_launch_configuration.webserver: Still destroying... [id=schoolapp-test-20220907202611978200000001, 30s elapsed]
aws_launch_configuration.webserver: Still destroying... [id=schoolapp-test-20220907202611978200000001, 40s elapsed]
aws_launch_configuration.webserver: Still destroying... [id=schoolapp-test-20220907202611978200000001, 50s elapsed]
aws_launch_configuration.webserver: Still destroying... [id=schoolapp-test-20220907202611978200000001, 1m0s elapsed]
aws_launch_configuration.webserver: Still destroying... [id=schoolapp-test-20220907202611978200000001, 1m10s elapsed]
aws_launch_configuration.webserver: Still destroying... [id=schoolapp-test-20220907202611978200000001, 1m20s elapsed]
aws_launch_configuration.webserver: Still destroying... [id=schoolapp-test-20220907202611978200000001, 1m30s elapsed]
aws_launch_configuration.webserver: Still destroying... [id=schoolapp-test-20220907202611978200000001, 1m40s elapsed]
aws_launch_configuration.webserver: Still destroying... [id=schoolapp-test-20220907202611978200000001, 1m50s elapsed]
aws_launch_configuration.webserver: Still destroying... [id=schoolapp-test-20220907202611978200000001, 2m0s elapsed]
╷
│ Error: deleting Auto Scaling Launch Configuration (schoolapp-test-20220907202611978200000001): ResourceInUse: Cannot delete launch configuration schoolapp-test-20220907202611978200000001 because it is attached to AutoScalingGroup terraform-20220907202240612600000002
│       status code: 400, request id: 923c8e58-262a-4de5-b675-3eec14d5e9e6
│ 
│ 

```


## Retry with the lifecycle meta-argument

Now uncomment the `lifecycle` block in `main.tf` and re-run terraform apply:

```bash
resource "aws_launch_configuration" "webserver" {
  name_prefix                 = "schoolapp-test-"
  image_id                    = data.aws_ami.ubuntu.id
  instance_type               = var.my_instance_type
  security_groups             = [aws_security_group.security_group1.id]
  key_name                    = aws_key_pair.mykey.key_name
  user_data                   = local.my_user_data
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
}
```

Run:

```bash
terraform apply --auto-approve
```

Notice how the apply is successful and takes seconds.


## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.