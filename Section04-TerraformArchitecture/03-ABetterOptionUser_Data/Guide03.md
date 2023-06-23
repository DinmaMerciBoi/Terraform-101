# A Better Option: user_data

Most cloud computing platform resources provide mechanisms to pass data to instances.

So, Provisioners are a last resort, use provisioners only if there is no other option.

In this lab, we'll add use `user_data` to run remote commands on our EC2 instance.

## Recreate the EC2 Instance

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands
```bash
terraform init
terraform apply --auto-approve
```

Check the AWS console to see the VM instance.

## user_data Script

Pay close attention to the `main.tf` line:
```bash
user_data = file("install_libraries.sh")
```

This basically tells the EC2 instance to use the `install_libraries` script whenever it launches for the first time.

Take a look at the `install_libraries` script to see what it's doing.

## SSH into the EC2 Instance

First, save the private key locally by running these commands:

```bash
terraform output -raw private_key > myKey.pem
sudo chmod 400 myKey.pem
ssh -i myKey.pem ubuntu@$(terraform output -raw public_ip)
```

Now run `tree` and `jq` to see that they've been installed.

## Install NGINX Webserver

Now uncomment the following 2 lines in `install_libraries.sh`:

```bash
apt install nginx -y
systemctl enable nginx
```

and rerun:

```bash
terraform apply --auto-approve
```

Notice how terraform is destroying and recreating the EC2 instance because of the line below in `main.tf`:

```bash
user_data_replace_on_change = true
```

This is a good practice as you start to follow immutable infrastructure principles.

This output below shows that terraform detected some changes in our `user_data` script and is causing it to recreate the EC2 instance. Provisioners on the other hand don't get Terraform to re-run as it doesn't keep track of changes.
```bash
~ user_data                            = "5ee6d6cc3f1ea0aac89dc38986f330f19b97a6e9" -> "d2713bc7dc18b72b372601c5beede8d8f632a4e1" # forces replacement
```

Finally, open your browser and type the `public_ip` for your EC2 instance and you should be greeted by the `Welcome to nginx!` message.

Congratulations, you just deployed a webserver using Terraform and without using provisioners that are brittle.

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.