# AWS Launch Templates

In the last lab we saw that we used an AutoScalingGroup to automatically manage EC2 instances. We needed an `aws_launch_configuration` resource. `aws_launch_configuration` is an immutable resource. This means that Terraform has to destroy it on every change to it and create a new one.

A newer resource that AWS recommends is called `aws_launch_template`. This resource creates a new version of the template on change.

## Create a Launch Template file

In `main.tf`, we commented out the `aws_launch_configuration` and added the `aws_launch_template` below:

```bash
resource "aws_launch_template" "webserver" {
  name_prefix   = "schoolapp-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.my_instance_type
  key_name      = aws_key_pair.mykey.key_name
  user_data     = base64encode(local.my_user_data)
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.security_group1.id]
  }
}
```

The one thing to note here is the `base64encode` function needed with `user_data`.

## Reference the Launch Template from the ASG

In `main.tf`, notice how we reference the `aws_launch_template`:

```bash
resource "aws_autoscaling_group" "webserver" {
  # launch_configuration = aws_launch_configuration.webserver.name
  launch_template {
    id      = aws_launch_template.webserver.id
    version = "$Latest"
  }
  vpc_zone_identifier = [for subnet in aws_subnet.schoolapp : subnet.id]
  min_size            = 2
  max_size            = 3
  desired_capacity    = 3

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

## Terraform Apply

Now terraform apply to verify that all works.

Run the following commands:
```bash
terraform apply --auto-approve
```

Check the AWS console to see the EC2 instances and verify that each is in a separate AZ with separate subnets.

Check also by going to one of the public IPs that the webservers are running.

## Update the Launch Template

Now let's make an update to our launch template by changing the `name_prefix = schoolapp-test-` in `main.tf` as shown below.

```bash
resource "aws_launch_template" "webserver" {
  name_prefix   = "schoolapp-test-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.my_instance_type
  key_name      = aws_key_pair.mykey.key_name
  user_data     = base64encode(local.my_user_data)
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.security_group1.id]
  }
}
```

Run:

```bash
terraform apply --auto-approve
```

Notice that everything worked fine and we didn't need the lifecycle meta-argument: `create_before_destroy`.

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.