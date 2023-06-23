# Output Tags with Values and Zipmap Functions

Let's clean up the tags output to something that looks better. We will use some functions and the for expression to accomplish this. We will work with the `outputs.tf` file exclusively in this lab along with the `terraform console`.

## Run Terraform

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following commands
```bash
terraform init
terraform apply --auto-approve
```

Check the tags output, it should look like this:

```bash
tags = toset([
  {
    "key" = "department"
    "propagate_at_launch" = true
    "value" = "engineering"
  },
  {
    "key" = "developer_name"
    "propagate_at_launch" = true
    "value" = "sam"
  },
  {
    "key" = "environment"
    "propagate_at_launch" = true
    "value" = "dev"
  },
  {
    "key" = "project"
    "propagate_at_launch" = true
    "value" = "schoolapp"
  },
])
```

That's pretty ugly, so let's clean it up.

## Explore with the Console

Now let's run some experiments with the console.

Run:

```bash
terraform console
```

We want to end up with something like this:

```bash
{
  "department" = "engineering"
  "developer_name" = "sam"
  "environment" = "dev"
  "project" = "schoolapp"
}
```

Now this is a map, so we need a way to get a map. Let's first explore the `for expression` with maps.

First let's grab the keys and values of our tags from the current output.

In the console, run this:
```bash
aws_autoscaling_group.webserver.tag
```

This will give us the same output. Notice how we have a set of objects. We want to grab the values of the `key` and `value` keys in each of the objects.

Let's try to get the first object in the set.

Run:
```bash
aws_autoscaling_group.webserver.tag[0]
```

Notice the error:

```bash

│ Error: Cannot index a set value
│ 
│   on <console-input> line 1:
│   (source code not available)
│ 
│ Block type "tag" is represented by a set of objects, and set
│ elements do not have addressable keys. To find elements
│ matching specific criteria, use a "for" expression with an
│ "if" clause.
```

We can't index a set. So let's convert it to a list first.

Run:

```bash
tolist(aws_autoscaling_group.webserver.tag)
```

Output:

```bash
tolist([
  {
    "key" = "department"
    "propagate_at_launch" = true
    "value" = "engineering"
  },
  {
    "key" = "developer_name"
    "propagate_at_launch" = true
    "value" = "sam"
  },
  {
    "key" = "environment"
    "propagate_at_launch" = true
    "value" = "dev"
  },
  {
    "key" = "project"
    "propagate_at_launch" = true
    "value" = "schoolapp"
  },
])
```

At the top notice it says `tolist` now.

Ok, let's reference the first object in the list:

```bash
tolist(aws_autoscaling_group.webserver.tag)[0]
```

Output:
```bash
{
  "key" = "department"
  "propagate_at_launch" = true
  "value" = "engineering"
}
```

Looks good, now let's grab the values of the object. There is a function called `values` to do that. Run:

```bash
values(tolist(aws_autoscaling_group.webserver.tag)[0])
```

Output:

```bash
[
  "department",
  true,
  "engineering",
]
```

That looks great, but we don't want this value of true. So let's keep that in mind.

We now want to iterate over the entire set/list to get all our tags and not just the first one. We will use a for loop for that.

Run:

```bash
[for tag in tolist(aws_autoscaling_group.webserver.tag) : values(tag)]
```

Output:

```bash
[
  [
    "department",
    true,
    "engineering",
  ],
  [
    "developer_name",
    true,
    "sam",
  ],
  [
    "environment",
    true,
    "dev",
  ],
  [
    "project",
    true,
    "schoolapp",
  ],
]
```

That looks great, we could also get rid of the tolist() as we're not accessing any indices. Run:

```bash
[for tag in aws_autoscaling_group.webserver.tag : values(tag)]
```

and we get a similar output:

```bash
[
  [
    "department",
    true,
    "engineering",
  ],
  [
    "developer_name",
    true,
    "sam",
  ],
  [
    "environment",
    true,
    "dev",
  ],
  [
    "project",
    true,
    "schoolapp",
  ],
]
```

Now let's go ahead and use a for expression with a map:

```bash
{ for tag in aws_autoscaling_group.webserver.tag : values(tag)[0] => values(tag)[2] }
```

Output:

```bash
{
  "department" = "engineering"
  "developer_name" = "sam"
  "environment" = "dev"
  "project" = "schoolapp"
}
```

So notice that to get a map from a for loop, instead of using the `[]` brackets, we use these: `{}`. Also, the `=>` operator separates our keys from our values within the map.

We are grabbing index 0 and index 2 from each object which corresponds to our tag keys and values.

Now exit the terraform console by typing `exit`

## Re-run Terraform Apply

In the `outputs.tf` file, comment the first tags block and uncomment the second one as shown below:

```bash
# output "tags" {
#   value       = aws_autoscaling_group.webserver.tag
#   description = "ASG tags"
# }

output "tags" {
  value       = { for tag in aws_autoscaling_group.webserver.tag : values(tag)[0] => values(tag)[2] }
  description = "ASG tags"
}

# output "tags" {
#   value       = zipmap([for tag in aws_autoscaling_group.webserver.tag : values(tag)[0]], [for tag in aws_autoscaling_group.webserver.tag : values(tag)[2]])
#   description = "ASG tags"
# }
```

Re-run terraform apply:

```bash
terraform apply --auto-approve
```

You should get the same output we got when exploring the terraform console.

## Exploring Zipmap

Let's go back to the terraform console to learn more about the zipmap function.

This function takes in 2 lists and converts them into a map with the first list used as keys and the second one as values.

Run:

```bash
zipmap(["a","b","c"], [1,2,3])
```

Output:

```bash
{
  "a" = 1
  "b" = 2
  "c" = 3
}
```

For our example, let's see how we can produce to lists, one for the tag keys and the other for the tag values:

```bash
[for tag in aws_autoscaling_group.webserver.tag : values(tag)[0]]
[for tag in aws_autoscaling_group.webserver.tag : values(tag)[2]]
```

Output:

```bash
> [for tag in aws_autoscaling_group.webserver.tag : values(tag)[0]]
[
  "department",
  "developer_name",
  "environment",
  "project",
]
> [for tag in aws_autoscaling_group.webserver.tag : values(tag)[2]]
[
  "engineering",
  "sam",
  "dev",
  "schoolapp",
]
```

Now let's add the list to the zipmap function:

```bash
zipmap([for tag in aws_autoscaling_group.webserver.tag : values(tag)[0]], [for tag in aws_autoscaling_group.webserver.tag : values(tag)[2]])
```

And we get the same output as before using a different method:

```bash
{
  "department" = "engineering"
  "developer_name" = "sam"
  "environment" = "dev"
  "project" = "schoolapp"
}
```

## Re-run Terraform Apply with Zipmap Function

You can also test this by updating the `outputs.tf` file as shown below:

```bash
# output "tags" {
#   value       = aws_autoscaling_group.webserver.tag
#   description = "ASG tags"
# }

# output "tags" {
#   value       = { for tag in aws_autoscaling_group.webserver.tag : values(tag)[0] => values(tag)[2] }
#   description = "ASG tags"
# }

output "tags" {
  value       = zipmap([for tag in aws_autoscaling_group.webserver.tag : values(tag)[0]], [for tag in aws_autoscaling_group.webserver.tag : values(tag)[2]])
  description = "ASG tags"
}
```

Re-run terraform apply:

```bash
terraform apply --auto-approve
```

You should get the same output we got when exploring the terraform console.

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.