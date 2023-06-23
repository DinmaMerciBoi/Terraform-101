terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.19.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.8.2"
    }
  }
}

data "tfe_outputs" "vault_ip" {
  organization = "TeKanAid" ## Change to your organization
  workspace    = "terraform-101-vault-setup"
}

provider "vault" {
  address = "http://${data.tfe_outputs.vault_ip.values.public_ip}:8200"
}

data "tfe_outputs" "vault_aws_creds" {
  organization = "TeKanAid" ## Change to your organization
  workspace    = "terraform-101-vault-config"
}

data "vault_aws_access_credentials" "creds" {
  backend = data.tfe_outputs.vault_aws_creds.values.backend
  role    = data.tfe_outputs.vault_aws_creds.values.role
}

provider "aws" {
  region     = var.region
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
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
  source            = "app.terraform.io/TeKanAid/ec2/aws"
  version           = "0.0.1"
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
