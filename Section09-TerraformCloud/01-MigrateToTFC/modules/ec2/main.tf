data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical https://ubuntu.com/server/docs/cloud-images/amazon-ec2
}

resource "aws_key_pair" "mykey" {
  key_name   = var.my_aws_key
  public_key = var.public_key
}

resource "aws_launch_template" "webserver" {
  name_prefix   = "schoolapp-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.my_instance_type
  key_name      = aws_key_pair.mykey.key_name
  user_data     = base64encode(var.my_user_data)
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.security_group_id]
  }
}

resource "aws_autoscaling_group" "webserver" {
  launch_template {
    id      = aws_launch_template.webserver.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.subnets
  min_size            = 2
  max_size            = 3
  desired_capacity    = 3

  target_group_arns = [var.target_group_arn]
  health_check_type = "ELB" # uses the LB's target group's health check to replace EC2 instances

  dynamic "tag" {
    for_each = var.mytags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}