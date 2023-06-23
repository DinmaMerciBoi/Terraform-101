# Create a TLS Module

In this lab we're going to build our first module. We'll move the `tls_private_key` resource to a module called `tls`.

In practice, you don't want to create a module that is just a wrapper for one or two resources. However, this is just a simple example to understand some basic concepts of modules.

## How to call the Module

In the `main.tf` file of the `root` module, notice at the end of the file how we call the `tls` module:

```bash
module "tls" {
  source = "./modules/tls"
}
```
## The Module Folder Structure

Notice how we created a new folder called `modules` and in it is a another folder called `tls`. In this case the name of our module is the name of the folder which is `tls`.

This `tls` folder has the following 5 files:

- LICENSE
- README.md
- main.tf
- variables.tf
- outputs.tf

Creating these 5 files at a minimum is a good practice.

## The main.tf file for the tls module

In `main.tf` for the `tls` module, we've moved the `tls_private_key` resource from the `main.tf` folder of the `root` module.

```bash
resource "tls_private_key" "mykey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
```

## The variables.tf file for the tls module

The `variables.tf` file is empty because we won't create any variables for this module. You may opt to hard-code certain values in a module such as the `algorithm` and `rsa_bits` as we did here to prevent your users from changing them. This is helpful when running a self-serve model.

## The outputs.tf file for the tls module

Notice below that the `outputs.tf` file has two outputs. 

```bash
output "private_key" {
  value     = tls_private_key.mykey.private_key_pem
  sensitive = true
}

output "public_key_out" {
  value = tls_private_key.mykey.public_key_openssh
}
```

1. The `private_key` that we will pass to the calling `root` module's output.
2. The `public_key_out` which is used by the `root` module's `aws_key_pair` resource in the `main.tf` file of the `root` module below:

```bash
resource "aws_key_pair" "mykey" {
  key_name   = var.my_aws_key
  public_key = module.tls.public_key_out
}
```

Notice the format used:
`module.tls.public_key_out`

## The outputs.tf file of the root module

Notice how we called on the output of the `tls` module using: `module.tls.private_key` to send that output from the `root` module to the user:

```bash
output "private_key" {
  value     = module.tls.private_key
  sensitive = true
}
```

## Run Terraform

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands
```bash
terraform init
terraform apply --auto-approve
```

Congratulations, you should get the same output as before but now you've used a module!

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.