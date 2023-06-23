# Lock and Upgrade Providers

Locking provider versions is very important to ensure that your code doesn't break in the future when newer versions of the provider are created.

## Terraform Init

Run `terraform init` with `version = "4.19.0"` in the `main.tf` file.

Notice the creation of the `.terraform.lock.hcl` file. Also notice the version is locked here.

## Upgrade the AWS Provider version

Now in the `main.tf` file change to `version = ">=4.19.0"` and run:

```bash
terraform init
```

Notice that nothing happens and terraform still used the `4.19.0` version although the latest version at this time is `4.23.0`, yours might be later.

Now try again with the `-upgrade` flag:

```bash
terraform init -upgrade
```

Now notice that terraform upgraded to version `4.22.0` and bypassed the `.terraform.lock.hcl` file.

>Note: that it is recommended to check the `.terraform.lock.hcl` file into git so that you or other engineers consistently use the same version of providers, modules, and core terraform

## Downgrade to v4.20.1

Now in the `main.tf` file change to `version = "~>4.20.0"` and run:

```bash
terraform init -upgrade
```

Notice that this time terraform used version `4.20.1` which is the latest patch version.

Finally, notice the multiple provider folders created in the `.terraform` folder.