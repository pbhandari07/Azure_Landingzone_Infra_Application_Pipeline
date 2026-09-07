resource "azurerm_web_application_firewall_policy" "resource" {
  for_each            = var.wafs
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }

  policy_settings {
    enabled = true
    mode    = "Prevention"
  }

  lifecycle {
    prevent_destroy = true
  }
}
