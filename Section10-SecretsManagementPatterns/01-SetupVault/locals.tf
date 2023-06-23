locals {
  name_suffix = "${var.project_name}-${var.environment}"
  required_tags = {
    project     = var.project_name
    environment = var.environment
    Name        = var.project_name
  }
  mytags = merge(var.resource_tags, local.required_tags)
  my_user_data = templatefile("${path.module}/install_libraries.tftpl", {
    VAULT_ZIP = var.vault_zip_file
  })

  inbound_ports = [var.vault_port, var.ssh_port]
}
