
locals {
  recreate_bastion = data.azurerm_bastion_host.existing_bastion.sku == "Standard"
}

resource "azurerm_bastion_host" "example" {
  for_each            = local.recreate_bastion ? toset(["0", "0"]) : toset(["0"])
  name                  = "shared-bastion"
  location              = var.location
  resource_group_name   = var.target_infra_rg
  sku                   = "Basic"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.example.id
    public_ip_address_id = azurerm_public_ip.example.id
  }
}
