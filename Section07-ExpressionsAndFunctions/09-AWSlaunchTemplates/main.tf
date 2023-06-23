terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.19.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}

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

resource "tls_private_key" "mykey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "mykey" {
  key_name   = var.my_aws_key
  public_key = tls_private_key.mykey.public_key_openssh
}

# resource "aws_launch_configuration" "webserver" {
#   name_prefix                 = "schoolapp-test-"
#   image_id                    = data.aws_ami.ubuntu.id
#   instance_type               = var.my_instance_type
#   security_groups             = [aws_security_group.security_group1.id]
#   key_name                    = aws_key_pair.mykey.key_name
#   user_data                   = local.my_user_data
#   associate_public_ip_address = true
#   lifecycle {
#     create_before_destroy = true
#   }
# }

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
