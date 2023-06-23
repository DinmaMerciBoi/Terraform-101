# Inject Secrets into Terraform using Vault

In this lab we'll rebuild our webservers but this this time we won't use long-lived AWS credentials. Instead, we'll rely on Vault to create on demand AWS credentials that are short-lived.

## Use Your Organization Name

In `main.tf` use your organization for the two `tfe_outputs` data blocks:

```bash
data "tfe_outputs" "vault_ip" {
  organization = "TeKanAid" ## Change to your organization
  workspace    = "terraform-101-vault-setup"
}

data "tfe_outputs" "vault_aws_creds" {
  organization = "TeKanAid" ## Change to your organization
  workspace    = "terraform-101-vault-config"
}
```

## Create a Workspace

- Create a new workspace
- Choose `Version control workflow` and pick GitLab and find the `terraform-101` repo that you had forked.
- Name the workspace: `terraform-101-inject-secrets` 
- Under `Advanced options`, in the Working Directory add this: `Section10-SecretsManagementPatterns/03-InjectSecretsIntoTerraformUsingVault` this gets Terraform to use our current folder to run our configuration.

## Add Variables

Once the workspace is created, you'll need to add the following variables:

- Add an environment variable: key = VAULT_TOKEN and value = root and mark it as sensitive

## Run Terraform

Click on `Actions` > `Start new run`

Watch the plan and when it completes, go to your `AWS console` and to the `IAM service` then go to `Users`. Notice that a new user name that starts with `vault-token-terraform-dynamic-aws-creds-vault` was generated. This is dynamically created by Vault.

Go back to TFC and click apply.

Depending on how fast you run apply, you will likely experience errors because the creds that Vault created should only last for 2 minutes since we specified the TTL to be 120 seconds.

You can also check that in the `AWS console`. That vault user name we saw disappeared. Vault removed it from AWS at the end of the TTL.

This shows you the benefit of using short-term secrets. However, we need to increase this TTL to get our deployment to deploy.

## Increase the TTL for Dynamic AWS Credentials

Go back to the `02-ConfigureVault` folder in this section and update the `vault_aws_secret_backend` resource in the `main.tf` file.

Increase the `default_lease_ttl_seconds` and the `max_lease_ttl_seconds`

```bash
resource "vault_aws_secret_backend" "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  path       = "${var.name}-path"

  default_lease_ttl_seconds = "1800"
  max_lease_ttl_seconds     = "3600"
}
```

Commit and push your changes. This should trigger the `terraform-101-vault-config` workspace to re-run Terraform. Check the plan and approve it to apply.

## Re-run Terraform

Go back to the `terraform-101-inject-secrets` workspace and Click on `Actions` > `Start new run`

>You may get a message with a lock icon saying: "Workspace is waiting on a run-xxxx. It must finish or the runs queue must be discarded before future runs can execute." Go ahead and click the button: `Discard run and start this run now`. Then click on `Yes, Unlock Workspace`

Use the `LB_DNS_Name` output to check on our webservers as usual.

## Cleanup

Do the following for the two workspaces:
1. terraform-101-inject-secrets
2. terraform-101-vault-setup

Go to the `settings` of your workspace and then go to the `Destruction and Deletion` tab.

Click on the `Queue destroy plan` and enter the workspace name to confirm running a destroy plan

Check the plan that gets generated and then approve the apply.

Check the AWS console to verify that all AWS instances are terminated.