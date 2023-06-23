# Data Types and String Interpolation

The Terraform language uses the following types for its values:

- `string`: a sequence of Unicode characters representing some text, like "hello".
- `number`: a numeric value. The number type can represent both whole numbers like 15 and fractional values like 6.283185.
- `bool`: a boolean value, either true or false. bool values can be used in conditional logic.
- `list` `(or tuple)`: a sequence of values, like ["us-west-1a", "us-west-1c"]. Elements in a list or tuple are identified by consecutive whole numbers, starting with zero.
- `map` `(or object)`: a group of values identified by named labels, like {name = "Mabel", age = 52}.

## Take a closer look at the variables file

Let's examine the `variables.tf` file closer to see all our data types there.

## Use the Console to check out the Data Types

Now Initialize terraform by running:

```bash
terraform init
```

Then get into the console by running:

```bash
terraform console
```

Run the following commands to see the outputs of the different variables we saw in the `variables.tf` file:

```bash
var.http_port           # number
var.environment         # string
var.allow_public_ips    # bool
var.resource_tags       # map
var.private_ips         # list
```

Referencing maps:
```bash
var.resource_tags.department
```
Referencing lists:
```bash
var.private_ips[0]
```

## String Interpolation

We've seen this before. We can add variables to a string using `${}`.
Example:

```bash
resource "aws_security_group" "security_group1" {
  name = "${var.project_name}-security-group"
...truncated
```