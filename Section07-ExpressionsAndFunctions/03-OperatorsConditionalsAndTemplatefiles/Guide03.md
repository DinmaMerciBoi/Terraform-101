# Operators, Conditionals, and Templatefiles

## Operators

The Terraform language uses operators similar to other programming languages, [take a look at the docs.](https://www.terraform.io/language/expressions/operators)

You can also test some of these on the terraform console:

```bash
terraform init
terraform console
```

```bash
1 > 2
false
false && true
false
```

## Conditionals

The syntax of a conditional is as below:

`condition ? true_val : false_val`

If condition is `true` then the result is `true_val`. If condition is `false` then the result is `false_val`.

We are now going to introduce a new feature to our app and that is put the version of the app in the footer.

We will use a conditional to either include the version of our app or not.

Check the `variables.tf` file for 2 new variables:
- `display_version`: is a boolean. True for displaying the app_version and false otherwise.
- `app_version`: the app version string.

We've created a new terraform file called `locals.tf` and moved our locals from the `variables.tf` file.

Notice the new local value `my_user_data`:

```bash
  my_user_data = var.display_version == true ? templatefile("${path.module}/install_libraries.tftpl", {
    version = var.app_version
  }) : file("${path.module}/install_libraries.sh")
```

Let's dissect this.

`my_user_data` is using a conditional expression. Depending on the value of the variable `display_version`, `my_user_data` will either use a templatefile or a file. More on templatfiles below.

We could also write this expression like this:

```bash
  my_user_data = var.display_version ? templatefile("${path.module}/install_libraries.tftpl", {
    version = var.app_version
  }) : file("${path.module}/install_libraries.sh")
```

notice we replaced `display_version == true` with just `display_version`. This is fine since `display_version` is already a boolean which will be either `true` or `false`. Sometimes it's better to be more explicit and leave `display_version == true`.

## Templatefiles

So far we've been feeding `user_data` with a shell script: `install_libraries.sh` using the `file()` function. This shell script didn't contain variables that were fed in from Terraform.

If we need to pass in terraform variables into a file, we can do that with a terraform template file, using the `templatefile()` function.

The syntax for calling a templatfile function is:

`templatefile(path, vars)`

Notice once again how we're calling the `templatefile()` function:

```bash
templatefile("${path.module}/install_libraries.tftpl", {
    version = var.app_version
  })
```

we are using the string interpolation with the `path.module` referring to the root path of our module which resolves to `.` and then referencing the `install_libraries.tftpl` file. Notice the `.tftpl` extension for terraform templates.

Now let's take a look at the templatefile: `install_libraries.tftpl`

```html
...
        <footer>
            <p style="text-align: center;">App Version: ${version}</p>
        </footer>
...
```

Notice how we are supplying the `version` variable into the footer of our html page.

Let's now test this all out.

## Terraform Apply

### Run with App version enabled

Notice how we assigned the following variables in `variables1.auto.tfvars`:

```
display_version  = true
app_version      = "0.2.5"
```

Now terraform apply to verify that all works.

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands:
```bash
terraform init
terraform apply --auto-approve
```

Check the AWS console to see the VM instance.

### Run with App version disabled

Now change the `display_version` variable to `false` in `variables1.auto.tfvars`:

```
display_version  = false
```

and re-run terraform apply:

```bash
terraform apply --auto-approve
```

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.