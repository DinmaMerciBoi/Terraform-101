# Provisioners

Provisioners can be used to model specific actions on the local machine or on a remote machine in order to prepare servers or other infrastructure objects for service.

Provisioners are a last resort, use provisioners only if there is no other option.

Terraform cannot model the actions of provisioners as part of a plan because they can in principle take any action.

In this lab, we will test the three types of provisioners:
- file
- local_exec
- remote_exec

Take a look at the `main.tf` file and read the comments to familiarize yourself with the configuration.

## Create the EC2 Instance

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands
```bash
terraform init
terraform apply --auto-approve
```

Check the AWS console to see the VM instance.

## Local-Exec Provisioner

Notice that the `local-exec` provisioner created a local file called `finished.log` that contains the date of the finished terraform run.

Another `local-exec` created a local file `/tmp/myKey.pem` that has the private key for the EC2 instance to ssh into it.

And one last `local-exec` was used to change the permissions of the `/tmp/myKey.pem` file to 400 to be used to ssh.

## Remote-Exec Provisioner

Notice how we used `remote-exec` to run commands on the remote EC2 instance that we just created. We ran it to install the `tree` and `jq` utilities after updating the apt repos.

```bash
sudo apt -y update
sudo apt install tree jq -y
```

## File Provisioner

Notice how we used the `file` provisioner to copy the `example.txt` file from our local computer to the newly created EC2 instance.

Double check that by ssh into the EC2 instance using the private key. Run the following:

```bash
ssh -i /tmp/myKey.pem ubuntu@<public_ip>
cat /tmp/example.txt
```

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.