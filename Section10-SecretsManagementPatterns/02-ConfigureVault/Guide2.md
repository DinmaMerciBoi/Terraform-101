# Setup Vault

In this lab we'll configure HashiCorp Vault using Terraform Cloud to enable dynamic AWS secrets. This will allow us to inject AWS secrets dynamically when running Terraform for all runs by our Dev team.

## Use Your Organization Name

In `main.tf` use your organization for the `tfe_outputs` data block:

```bash
data "tfe_outputs" "vault_ip" {
  organization = "TeKanAid" ## Change to your organization
  workspace    = "terraform-101-vault-setup"
}
```

## Create a Workspace

- Create a new workspace 
- Choose `Version control workflow` and pick GitLab and find the `terraform-101` repo that you had forked.
- Name the workspace: `terraform-101-vault-config`
- Under `Advanced options`, in the Working Directory add this: `Section10-SecretsManagementPatterns/02-ConfigureVault` this gets Terraform to use our current folder to run our configuration.

## Add Variables

Once the workspace is created, you'll need to add the following variables:

- Add an environment variable: key = VAULT_TOKEN and value = root and mark it as sensitive
- Add a terraform variable: key = aws_access_key and value = "your aws access key" and mark it as sensitive
- Add a terraform variable: key = aws_secret_key and value = "your aws secret key" and mark it as sensitive

## Workspace sharing

Go to the settings of the workspace and under the `General` tab:
- Under `Remote state sharing`, select: `Share with all workspaces in this organization`

## Run Terraform

Click on `Actions` > `Start new run`

Watch the plan and then confirm the apply.

Notice in Vault that a new AWS secrets engine is configured at path: `dynamic-aws-creds-vault-admin-path`.

## Next Steps

Now the vault server is configured and ready to create dynamic AWS credentials for whenever we use Terraform in the future.

We will see this in action in the next lab.