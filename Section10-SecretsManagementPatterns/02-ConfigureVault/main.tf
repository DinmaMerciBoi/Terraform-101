terraform {
  required_providers {
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

resource "vault_aws_secret_backend" "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  path       = "${var.name}-path"

  default_lease_ttl_seconds = "1800"
  max_lease_ttl_seconds     = "3600"
}

resource "vault_aws_secret_backend_role" "admin" {
  backend         = vault_aws_secret_backend.aws.path
  name            = "${var.name}-role"
  credential_type = "iam_user"

  policy_document = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:*", "ec2:*", "elasticloadbalancing:*", "autoscaling:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
