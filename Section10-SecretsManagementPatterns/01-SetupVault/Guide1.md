# Set up Vault

In this lab we'll setup HashiCorp Vault using Terraform Cloud.

## Create a Workspace

- Create a new workspace.
- Choose `Version control workflow` and pick GitLab and find the `terraform-101` repo that you had forked.
- Name the workspace: `terraform-101-vault-setup` 
- Under `Advanced options`, in the Working Directory add this: `Section10-SecretsManagementPatterns/01-SetupVault` this gets Terraform to use our current folder to run our configuration.

## Add Variables

Once the workspace is created, you'll need to add the following variables:

- Apply the variable set for the AWS credentials that you created in the previous lab to this workspace.

## Workspace sharing

Go to the settings of the workspace and under the `General` tab:
- Under `Remote state sharing`, select: `Share with all workspaces in this organization`

## Run Terraform

Click on `Actions` > `Start new run`

Watch the plan and then confirm the apply.

Notice the output `public_ip` and use that to check that vault is running by going to this link in a browser:

```bash
http://<public_ip>:8200
```

Login with method: `token` and use `root` as the token.

>Note: it may take a minute or two till vault is running so please be patient.

>Warning: This is NOT a PRODUCTION Vault server, please DO NOT use for PRODUCTION!!

## Next Steps

Leave the vault server running as we'll configure it in the next lab.