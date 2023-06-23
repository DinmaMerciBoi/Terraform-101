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

resource "aws_key_pair" "mykey" {
  key_name   = var.my_aws_key
  public_key = module.tls.public_key_out
}

resource "aws_launch_template" "webserver" {
  name_prefix   = "schoolapp-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.my_instance_type
  key_name      = aws_key_pair.mykey.key_name
  user_data     = base64encode(local.my_user_data)
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [module.networking.security_group_id]
  }
}

resource "aws_autoscaling_group" "webserver" {
  launch_template {
    id      = aws_launch_template.webserver.id
    version = "$Latest"
  }
  vpc_zone_identifier = module.networking.subnets
  min_size            = 2
  max_size            = 3
  desired_capacity    = 3

  target_group_arns = [module.lb.target_group_arn]
  health_check_type = "ELB" # uses the LB's target group's health check to replace EC2 instances

  dynamic "tag" {
    for_each = local.mytags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

module "tls" {
  source = "./modules/tls"
}

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

module "networking" {
  source                     = "./modules/networking"
  region                     = var.region
  mytags                     = local.mytags
  address_space              = var.address_space
  availability_zones_subnets = var.availability_zones_subnets
  allow_public_ips           = var.allow_public_ips
  project_name = var.project_name
  inbound_ports = local.inbound_ports
}
