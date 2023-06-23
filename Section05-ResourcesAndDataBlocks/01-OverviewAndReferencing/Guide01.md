# Resources and Data Blocks Overview and Referencing

Resources and Data Blocks are the main blocks you will use in your Terraform code. In this lab you'll learn how to use them and reference them.

## Use a Data Block for the AMI

Instead of hardcoding the EC2 instance's ami, we will use a data block to get it.

In the `main.tf` file, comment the hard-coded ami line and uncomment the ami line to reference the data block: `data.aws_ami.ubuntu.id` as shown below:

```bash
resource "aws_instance" "webserver" {
  # ami                    = "ami-08d4ac5b634553e16"
  ami                    = data.aws_ami.ubuntu.id
  ...truncated
  }
```

## Recreate the EC2 Instance

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands
```bash
terraform init
terraform apply --auto-approve
```

Check the AWS console to see the VM instance and compare the AMI details with the old one.

## Old AMI details

Below are the AMI details for the `Ubuntu` AMI we've been using so far:

AMI ID: ami-08d4ac5b634553e16
AMI name: ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220610
AMI location: 099720109477/ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220610

## New AMI details

Below are the AMI details for the `Ubuntu` AMI that we just launched. Notice that this one is more recent since we used `most_recent = true` in the `aws_ami` data block. Note that yours might even be newer than the one I'm showing below:

AMI ID: ami-0cf6c10214cc015c9
AMI name: ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220810
AMI location: 099720109477/ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220810

Congratulations, you've now learned the differences between resource and data blocks. You also got a better understanding of how to reference these blocks in other blocks.

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.