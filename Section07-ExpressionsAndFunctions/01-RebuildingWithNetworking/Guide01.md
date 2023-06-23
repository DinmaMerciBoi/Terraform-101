# Rebuilding with Networking

So far we've been using the default VPC in AWS. However, you will likely need to create your own VPC at your organization or use an existing one that isn't the default.

In this lab we'll see the changes to our code to add robust networking.

## Networking File

To make things cleaner, we now have a separate networking file called `networking.tf`. Take a look at the content of this file to understand the different networking resources created.

## Notice the New Variables

We've also created 4 new variables. Check the `variables.tf` file. Also notice how we've moved `locals` to the top of the `variables.tf` file.

## Updates to the `install_libraries.sh` script

We've made some modifications to the html rendered in our webserver to show the instance_id and the private_ip. This will get us ready for when we introduce a load balancer. This way we will know that load balancing is happening when we see different instance_ids and private_ips.

## Terraform Apply

Now terraform apply to verify that all works.

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands:
```bash
terraform init
terraform apply --auto-approve
```

Check the AWS console to see the VM instance.

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.