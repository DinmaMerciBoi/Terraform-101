terraform {
    cloud {
    organization = "TeKanAid"

    workspaces {
      name = "terraform-101-cli-workflow"
    }
  }
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

module "tls" {
  source  = "app.terraform.io/TeKanAid/tls/tls"
  version = "0.0.1"
}

module "lb" {
  source       = "app.terraform.io/TeKanAid/lb/aws"
  version      = "0.0.1"
  region_in    = var.region
  vpc_id       = module.networking.vpc_id
  ssh_port     = var.ssh_port
  http_port    = var.http_port
  project_name = var.project_name
  mytags       = local.mytags
  subnets      = module.networking.subnets
}

module "networking" {
  source                     = "app.terraform.io/TeKanAid/networking/aws"
  version                    = "0.0.1"
  region                     = var.region
  mytags                     = local.mytags
  address_space              = var.address_space
  availability_zones_subnets = var.availability_zones_subnets
  allow_public_ips           = var.allow_public_ips
  project_name               = var.project_name
  inbound_ports              = local.inbound_ports
}

module "ec2" {
  source  = "app.terraform.io/TeKanAid/ec2/aws"
  version = "0.0.1"
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
