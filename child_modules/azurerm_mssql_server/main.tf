resource "azurerm_mssql_server" "resource" {
  for_each                     = var.sqls
  name                         = each.value.name
  resource_group_name          = each.value.resource_group_name
  location                     = each.value.location
  version                      = lookup(each.value, "version", "12.0")
  administrator_login          = each.value.administrator_login
  administrator_login_password = each.value.administrator_login_password

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_mssql_database" "db" {
  for_each  = var.sqls
  name      = lookup(each.value, "db_name", "sql-db")
  server_id = azurerm_mssql_server.resource[each.key].id
  sku_name  = lookup(each.value, "sku_name", "Basic")

  lifecycle {
    prevent_destroy = true
  }
}
