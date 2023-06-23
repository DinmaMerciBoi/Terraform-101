# Move our Modules to the Private Registry in TFC

In this lab we'll see how to move our modules to TFC's private registry.

## Create Repos

Each module has to live in it's own VCS repo. Notice we already have 4 repos created with the following names:

- [terraform-aws-ec2](https://gitlab.com/public-projects3/training/terraform-aws-ec2)
- [terraform-aws-lb](https://gitlab.com/public-projects3/training/terraform-aws-lb)
- [terraform-aws-networking](https://gitlab.com/public-projects3/training/terraform-aws-networking)
- [terraform-tls-tls](https://gitlab.com/public-projects3/training/terraform-tls-tls)

You can go ahead and fork these repos into your own GitLab instance.

## Naming Structure of Module Repos

Below is the naming structure needed to publish modules into TFC's private registry:

`terraform-<PROVIDER>-<NAME>`

## Publishing Modules in TFC

Under the `Registry` tab in TFC, select the `Modules` tab and click the `Publish` button then the `Module` button. 

Go through the wizard and select the GitLab.com VCS then select the module you want to add then click `Publish module`.

## Module tags

Every module needs to have at least one published tag in the VCS repo.

Make sure to create and push a tag before publishing the module.

## Getting the Module Source

Once you publish your modules, you can click into them and on the right hand side of the screen you'll find the configuation details. Copy that into the `main.tf` file:

```bash
module "networking" {
  source  = "app.terraform.io/TeKanAid/networking/aws"
  version = "0.0.1"
  # insert required variables here
}
```

## Create a Workspace

- Create a new workspace called `terraform-101-private-registry` 
- In the Working Directory add this: `Section09-TerraformCloud/02-MoveOurModulesToPrivateRegistry` this gets Terraform to use our current folder to run our configuration.

## Add Variables

Once the workspace is created, you'll need to add the following variables:

- key: `my_aws_key`, value: `mykey.pem` (Category: Terraform variable, not sensitive)
- Apply the variable set for the AWS credentials that you created in the previous lab to this workspace.

## Run Terraform

Click on `Actions` > `Start new run`

Notice the output LB DNS name and use that to check that the application works.

## Cleanup

Go to the `settings` of your workspace and then go to the `Destruction and Deletion` tab.

Click on the `Queue destroy plan` and enter the workspace name to confirm running a destroy plan

Check the plan that gets generated and then approve the apply.

Check the AWS console to verify that the AWS instance is terminated.