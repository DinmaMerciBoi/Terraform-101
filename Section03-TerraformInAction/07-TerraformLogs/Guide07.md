# Terraform Logs

Terraform has detailed logs which can be enabled by setting the `TF_LOG` environment variable to any value. This will cause detailed logs to appear on `stderr`.

You can set TF_LOG to one of these log levels (in order of decreasing verbosity):
- TRACE
- DEBUG
- INFO
- WARN
- ERROR

If `TF_LOG` is defined, but the value is not one of the five listed verbosity levels, Terraform will default to `TRACE`.

## Turn on TRACE

Run the following:

```bash
export TF_LOG=TRACE
```

Also notice that in the `main.tf` file, we've commented out `instance_type = "t2.micro"` in order to force an error on `terraform plan`.

## Attempt to Recreate the EC2 Instance

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands
```bash
terraform init
terraform plan
```

Notice the verbose output.

## Try with INFO

Let's try again with `INFO` level now:

```bash
export TF_LOG=INFO
terraform plan
```

Notice the verbosity level is much less.

## Turn off Logging

```bash
unset TF_LOG
terraform plan
```
