# Managing Drifts with Terraform Refresh

You may find that one of your colleagues made changes to a resource outside of Terraform. Maybe via the AWS console directly.

The `terraform refresh` command helps to reconcile the state Terraform knows about (via its state file) with the real-world infrastructure

By default, Terraform runs a refresh every time you run `terraform plan` or `terraform apply`.

## Recreate the EC2 Instance

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands
```bash
terraform init
terraform apply --auto-approve
```

Check the AWS console to see the VM instance.

## Make a Change in the AWS Console

Now change the name of the EC2 Instance from the AWS console from `webserver-default` to `webserver-changedname`. You can do this under the Tags section then click on `Manage tags`

When done, run this:

```bash
terraform refresh
```

Then check the state file and notice that now Terraform has changed the tag in the state file to `webserver-changedname` to match reality.

Now run this:

```bash
terraform plan
```

Notice that in the output, terraform will change the name back to `webserver-default`. This is because in our configuration we've declared that we want the name to be `webserver-default`.

Also notice that at the top of the `terraform plan` output it says `Refreshing state`.

Let's change it back to clear the drift:

```bash
terraform apply --auto-approve
```

Notice the need to run refresh because Terraform would not have known that we made some changes in the real-world. So refresh brings the state file up-to-date and then when you run apply you eliminate the drift created outside of Terraform.

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.