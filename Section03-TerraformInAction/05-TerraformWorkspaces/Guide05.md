# Terraform Workspaces

Workspaces allow you to run in different environments such as dev, test, qa, prod, etc.

## Recreate the EC2 Instance

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands
```bash
terraform init
terraform apply --auto-approve
```

Check the AWS console to see the VM instance.

## Workspaces in Action

The main point of using workspaces is for the DRY (Don't Repeat Yourself) principle. We have 1 `main.tf` file that can be used with multiple environments.

You can use the keyword `terraform.workspace` within your terraform code to reference which workspace you're working in.

Let's add the following tag to our `aws_instance` resource by uncommenting the block below in the `main.tf` file:

```bash
  tags = {
    "Name" = "webserver-${terraform.workspace}"
  }
```

Notice that now we are using string interpolation to add a name to our EC2 instance. This name is made up of a static word: `webserver-` and the name of the workspace that we are working in.

So if we don't create any new workspace, then the `default` workspace will be used. In this case, our tag will have the name: `webserver-default`

Try running `terraform plan` to verify and notice that terraform will make the change in place without having to destroy the EC2 instance.

Now let's create two workspaces called `dev` and `prod`. To do so run these commands:

```bash
terraform workspace new dev
terraform workspace new prod
```

Notice a new folder got created called `terraform.tfstate.d` and inside it we have 2 folders called `dev` and `prod`.

Now list these using the command:

```bash
terraform workspace list
```

To select a specific workspace use:
```bash
terraform workspace select dev
```

To see which workspace we are in run:
```bash
terraform workspace show
```

Now since we are in the `dev` workspace let's run:

```bash
terraform plan
terraform apply --auto-approve
```

Then do the same for the `prod` workspace:

```bash
terraform workspace select prod
terraform plan
terraform apply --auto-approve
```

Now go to the AWS console and notice that we now have two instances called:
- webserver-dev
- webserver-prod

Also notice that we now have two separate state files. One for the dev environment and one is for the prod environment.

The original state file outside the `terraform.tfstate.d` folder is for the `default` workspace.

## Cleanup

```bash
terraform workspace select default
terraform destroy --auto-approve
terraform workspace select dev
terraform destroy --auto-approve
terraform workspace select prod
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instances are terminated.

## Check the Terraform State Backup file

Notice that we have a `terraform.tfstate.backup` file that contains the previous state of our environment. This is useful in case we make mistakes.