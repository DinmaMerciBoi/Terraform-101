locals {
  name_suffix = "${var.project_name}-${var.environment}"
  required_tags = {
    project     = var.project_name
    environment = var.environment
  }
  mytags = merge(var.resource_tags, local.required_tags)
  my_user_data = var.display_version == true ? templatefile("${path.module}/install_libraries.tftpl", {
    version = var.app_version
  }) : file("${path.module}/install_libraries.sh")

  inbound_ports = [var.http_port, var.ssh_port]
}
