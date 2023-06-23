# Variable Precedence

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:

- Environment variables
- The terraform.tfvars file, if present.
- The terraform.tfvars.json file, if present.
- Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
- Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)

## Variables on the command line

Run:

```bash
terraform init
terraform plan -var http_port=8080
```

Output:
```
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "HTTP Ingress"
              + from_port        = 8080
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 8080
            },
```

Notice that the command line took precedence over the `variables1.auto.tfvars` file where `http_port = 80`

## Variables in *.auto.tfvars

Add `http_port = 8090` to `terraform.tfvars` file.

Run
```bash
terraform plan
```

Output:
```
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "HTTP Ingress"
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
            },
```

Notice how the `http_port` variable in the `variables1.auto.tfvars` file took precendence over the value in the `terraform.tfvars` file.

## Use terraform.tfvars

Now remove the `http_port = 80` from the `variables1.auto.tfvars` file and rerun:

```bash
terraform plan
```

Output:
```
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "HTTP Ingress"
              + from_port        = 8090
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 8090
            },
```

Notice that we got the value of 8090 which was taken from the `terraform.tfvars` file.

## Set an environment variable

Run:
```bash
export TF_VAR_http_port=8088
```

```bash
terraform plan
```

Output:
```
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "HTTP Ingress"
              + from_port        = 8090
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 8090
            },
```

Notice that we got the `http_port` from the `terraform.tfvars` file because it takes precedence over the environment variable.

Now remove the `http_port` variable from the `terraform.tfvars` file to rely only on the environment variable and run:

```bash
terraform plan
```

Output:
```
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "HTTP Ingress"
              + from_port        = 8088
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 8088
            },
```

Notice how the value is now 8088 taken from the environment variable.

## Conclusion

It's important to understand these precedence when working with CI/CD pipelines.