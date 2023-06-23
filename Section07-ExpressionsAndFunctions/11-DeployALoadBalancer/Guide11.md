# Deploy a Load Balancer

Having 3 EC2 instances as web servers require a load balancer in front of them. This is what we'll deploy in this lab.

## New File lb.tf

We created a new file called `lb.tf` and built our resources there to deploy the load balancer. Take a look.

## Update main.tf

In `main.tf`, we just need to update the `aws_autoscaling_group` resource with the target group for the LB and the health_check_type:

```bash
  target_group_arns = [aws_lb_target_group.schoolapp.arn]
  health_check_type = "ELB" # uses the LB's target group's health check to replace EC2 instances
```

## Run Terraform

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands
```bash
terraform init
terraform apply --auto-approve
```

Check the output, it should look like this:

```bash
LB_DNS_Name = "schoolapp-1652711491.us-east-1.elb.amazonaws.com"
private_key = <sensitive>
tags = {
  "department" = "engineering"
  "developer_name" = "sam"
  "environment" = "dev"
  "project" = "schoolapp"
}
```

Wait a couple of minutes then in a browser window, type the LB_DNS_Name to access the webservers. In my case it's this: `schoolapp-1652711491.us-east-1.elb.amazonaws.com`

Refresh the browser multiple times to see how the LB is switching between our 3 different EC2 instances.

Congratulations! You've now built a highly available, resilient and scalable web application.

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.