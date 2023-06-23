# Resource Graph

Terraform builds a dependency graph from the Terraform configurations, and walks this graph to generate plans, refresh state, and more. You can [learn more from the docs.](https://www.terraform.io/internals/graph)

The `terraform graph` command helps us see the dependencies and gives us the ability to troubleshoot any dependency issues.

## Initialize First

Make sure you have your AWS credentials defined in the `~/.aws/credentials` file. You can also run aws configure if you have the `aws cli` installed.

Run the following command:
```bash
terraform init
```

## Check the graph before applying

Run the following command:
```bash
terraform graph
```

Notice the output is in text format called the `DOT format`, which is not very nice to visualize. We can use a tool called GraphViz to help us visualize the dependencies.

Install it by running the following command:

```bash
sudo apt install graphviz
```

## Show the Graph

Now let's run the command below to visualize the dependency graph:

```bash
terraform graph | dot -Tpng > graph.png
```

## Apply the plan

Let's apply the plan and take a look at the graph again.

```bash
terraform apply --auto-approve
```

Now let's run the command again to visualize the dependency graph:

```bash
terraform graph | dot -Tpng > graph-applied.png
```

Notice that there are no differences, which is expected.

## Check Destroying

Now if you comment out the public IP output in the `main.tf` and run the command below:

```bash
terraform graph | dot -Tpng > graph-nopublicip.png
```

Notice that the `output.public_ip` is set for destruction which is expected since we commented it out in our configuration.

## Wrap-up

When you add a reference from one resource to another, you create an `implicit dependency`. Terraform builds a graph from them that automatically determines the right order to create the resources.

In some cases, you may run into dependency issues, you can use the `depends_on` meta-argument to create `explicit dependencies`.

## Cleanup

```bash
terraform destroy --auto-approve
```

Check the AWS console to verify that the AWS instance is terminated.