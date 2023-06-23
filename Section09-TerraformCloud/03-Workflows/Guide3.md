# Workflows

Terraform Cloud has three workflows for managing Terraform runs:

- The UI/VCS-driven run workflow which is the primary mode of operation and what we've seen so far.
- The API-driven run workflow, which is more flexible but requires you to create some tooling. It's most commonly used with a CI/CD pipeline and is a more advanced topic outside the scope of this course.
- The CLI-driven run workflow, which uses Terraform's standard CLI tools to execute runs in Terraform Cloud. We will explore this workflow in this lab. 

## Create a Workspace

- Create a new workspace and this time choose `CLI-driven workflow`
- Name it: `terraform-101-cli-workflow`
- Give it a description (optional)
- You will get a message saying `Waiting for configuation` with some instructions
  1. Ensure you are properly authenticated into Terraform Cloud by running terraform login on the command line or by using a credentials block.
  2. Add a code block to your Terraform configuration files to set up the cloud integration . You can add this configuration block to any .tf file in the directory where you run Terraform.

  Example code:
  ```bash
  terraform {
    cloud {
      organization = "TeKanAid"

      workspaces {
        name = "terraform-101-cli-workflow"
      }
    }
  }
  ```

  >Note: in your case you will have a different organization name.

  3. Run `terraform init` to initialize the workspace.
  4. Run `terraform apply` to start the first run for this workspace.

## Accessing TFC

There are a few ways to access TFC, below are the 2 most popular ones. We will use the `terraform login` command for our lab.

### Credentials Block

You can use a CLI Configuration File `terraform.rc` on Windows systems or `.terraformrc` on all other systems. 

In this file you can have the following `credentials` block:

```bash
credentials "app.terraform.io" {
  token = "xxxxxx.atlasv1.zzzzzzzzzzzzz"
}
```

[More info in the docs](https://www.terraform.io/cli/config/config-file#cli-configuration-file-terraformrc-or-terraform-rc)

> Important: If you are using Terraform Cloud or Terraform Enterprise, the token provided must be either a `user token` or a` team token`; `organization tokens` cannot be used for command-line Terraform actions.

### Terraform login command

If you are running the Terraform CLI interactively on a computer with a web browser, you can use the `terraform login` command to get credentials and automatically save them in the CLI configuration. If not, you can manually write credentials blocks.

Go ahead and run:
```bash
terraform login
```

You will get this message below, go ahead and type `yes`:

```bash
terraform login
Terraform will request an API token for app.terraform.io using your browser.

If login is successful, Terraform will store the token in plain text in
the following file for use by subsequent commands:
    /home/sam/.terraform.d/credentials.tfrc.json

Do you want to proceed?
  Only 'yes' will be accepted to confirm.
```

Your browser will open up and ask you to create an API token for TFC. Give it a description and click on `Create API token`.

Then grab the API token and paste it in your terminal and hit enter.

> Note that when you paste it in the terminal nothing happens, it won't show you the token pasted for security reasons. Make sure not to paste it twice.

You are now authenticated into TFC and the token is stored in `/home/sam/.terraform.d/credentials.tfrc.json`

Click `Done` in the browser.

Navigate back to our `terraform-101-cli-workflow` workspace.

## Add Cloud Block to `main.tf`

Now grab the example code that was shown in the `Waiting for configuration` section of the workspace and paste it in your `main.tf` file. Below is mine, yours will have a different `organization`:

```bash
terraform {
  cloud {
    organization = "TeKanAid"

    workspaces {
      name = "terraform-101-cli-workflow"
    }
  }
}
```

Which will end up looking like this:

```bash
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
```

## Add Variables

Once the workspace is created, you'll need to add the following variables via the `Variables` tab:

- key: `my_aws_key`, value: `mykey.pem` (Category: Terraform variable, not sensitive)
- Apply the variable set for the AWS credentials that you created previously to this workspace.

## Run Terraform

Back in the terminal initialize with `terraform init` then run `terraform apply`

> Notice that the output starts to stream in the terminal and is also visible at the same time in the UI.

When prompted to accept the apply, type `yes`.

You will get the same results as before but now we've used the CLI-driven workflow of TFC which is very similar to what you would do when you are using terraform open source. Congratulations!

Notice the output LB DNS name and use that to check that the application works.

### State is accessible

Notice that we can run `terraform state list` and see the resources from our state file that are remotely stored in TFC. We can see them from our terminal.

We can also run `terraform console` and work with the console.

Try typing `module.tls` in the console.

## Cleanup

Run `terraform destroy` and notice once again the streaming in the terminal and you can approve this from the terminal or from the UI.

Check the AWS console to verify that the AWS instance is terminated.