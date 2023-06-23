# Migrate to TFC

In this lab we'll see how to migrate our configuration to use TFC instead of our local machine.

## Connect the GitLab VCS Provider

- Go to the `Settings` and select `Providers` under the `Version Control` section.
- Click `Add a VCS provider` then select `GitLab` and `GitLab.com`
- Follow the instructions there to generate an Application ID and Secret.

## Create a Workspace

- Go to the `Workspaces` tab and click `+ New workspace`
- Select `Version control workflow`
- Select `GitLab.com`
- Choose your `terraform-101` repo that you forked in the very beginning of the course. Or fork it now. Hint: you can use the filter to search.
- Use `terraform-101-migrate` as the `Workspace Name`
- Add a description (optional)
- Click `Advanced options`
- In the Working Directory add this: `Section09-TerraformCloud/01-MigrateToTFC` this gets Terraform to use our current folder to run our configuration.
- Scroll to the bottom and click `Create workspace`

## Add Variables

Once the workspace is created, you'll need to add the following variables:

- key: `my_aws_key`, value: `mykey.pem` (Category: Terraform variable, not sensitive)
- key: `AWS_ACCESS_KEY_ID`, value: <put_yours>, (Category: Environment variable, sensitive)
- key: `AWS_SECRET_ACCESS_KEY`, value: <put_yours>, (Category: Environment variable, sensitive)

>Pro tip: use Variable sets for the AWS credentials (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`) to be able to re-use them in multiple workspaces. You can add Variable sets under the global settings.

## Run Terraform

In the workspace, click on `Actions` > `Start new run`

Notice the output LB DNS name and use that to check the application works.

## Cleanup

Go to the `settings` of your workspace and then go to the `Destruction and Deletion` tab.

Click on the `Queue destroy plan` and enter the workspace name to confirm running a destroy plan

Check the plan that gets generated and then approve the apply.

Check the AWS console to verify that the AWS instance is terminated.