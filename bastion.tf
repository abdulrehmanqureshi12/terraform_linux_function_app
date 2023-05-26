resource "null_resource" "recreate_bastion" {
  depends_on = [azurerm_bastion_host.example]
  count      = data.azurerm_bastion_host.existing_bastion.sku == "Standard" ? 1 : 0

  provisioner "local-exec" {
    when    = destroy
    command = "azurerm_bastion_host.example.destroy"
  }

  provisioner "local-exec" {
    when    = create
    command = "terraform apply -target=azurerm_bastion_host.example"
  }
}
