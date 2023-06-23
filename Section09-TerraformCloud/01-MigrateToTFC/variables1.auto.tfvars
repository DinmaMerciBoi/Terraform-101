region           = "us-east-1"
my_instance_type = "t2.micro"
ssh_port         = 22
http_port        = 80
resource_tags = {
  department     = "engineering"
  developer_name = "sam"
}
allow_public_ips = true
display_version  = true
app_version      = "0.2.5"
webserver_count  = 3
