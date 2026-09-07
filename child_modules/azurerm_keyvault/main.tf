resource "azurerm_key_vault" "resource" {
  for_each                   = var.keyvaults
  name                       = each.value.name
  location                   = each.value.location
  resource_group_name        = each.value.resource_group_name
  tenant_id                  = each.value.tenant_id
  sku_name                   = lookup(each.value, "sku_name", "standard")
  soft_delete_retention_days = lookup(each.value, "soft_delete_retention_days", 7)
  purge_protection_enabled   = lookup(each.value, "purge_protection_enabled", false)

  lifecycle {
    prevent_destroy = true
  }
}
