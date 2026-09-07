data "azurerm_subnet" "subnet" {
  for_each             = var.firewalls
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

data "azurerm_public_ip" "pip" {
  for_each            = var.firewalls
  name                = each.value.public_ip_name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_firewall" "resource" {
  for_each            = var.firewalls
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku_name            = lookup(each.value, "sku_name", "AZFW_VNet")
  sku_tier            = lookup(each.value, "sku_tier", "Standard")

  ip_configuration {
    name                 = each.value.ip_config_name
    subnet_id            = data.azurerm_subnet.subnet[each.key].id
    public_ip_address_id = data.azurerm_public_ip.pip[each.key].id
  }

  lifecycle {
    prevent_destroy = true
  }
}
