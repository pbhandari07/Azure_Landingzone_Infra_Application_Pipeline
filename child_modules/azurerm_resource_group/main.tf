resource "azurerm_resource_group" "resource" {
  for_each = var.rgs
  name     = each.value.name
  location = each.value.location

  lifecycle {
    prevent_destroy = true
  }
}
