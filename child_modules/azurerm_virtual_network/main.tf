resource "azurerm_virtual_network" "resource" {
  for_each            = var.vnets
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space

  lifecycle {
    prevent_destroy = true
  }
}
