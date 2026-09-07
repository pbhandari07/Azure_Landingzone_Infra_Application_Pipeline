data "azurerm_virtual_network" "remote_vnet" {
  for_each            = var.peerings
  name                = each.value.remote_virtual_network_name
  resource_group_name = each.value.remote_resource_group_name
}

resource "azurerm_virtual_network_peering" "resource" {
  for_each                     = var.peerings
  name                         = each.value.name
  resource_group_name          = each.value.resource_group_name
  virtual_network_name         = each.value.virtual_network_name
  remote_virtual_network_id    = data.azurerm_virtual_network.remote_vnet[each.key].id
  allow_virtual_network_access = lookup(each.value, "allow_virtual_network_access", true)
  allow_forwarded_traffic      = lookup(each.value, "allow_forwarded_traffic", true)
  allow_gateway_transit        = lookup(each.value, "allow_gateway_transit", false)
  use_remote_gateways          = lookup(each.value, "use_remote_gateways", false)

  lifecycle {
    prevent_destroy = true
  }
}
