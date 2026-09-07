module "resource_group" {
  source = "../../child_modules/azurerm_resource_group"
  rgs    = var.rgs
}

module "virtual_network" {
  source     = "../../child_modules/azurerm_virtual_network"
  vnets      = var.vnets
  depends_on = [module.resource_group]
}

module "subnet" {
  source     = "../../child_modules/azurerm_subnet"
  subnets    = var.subnets
  depends_on = [module.virtual_network]
}

module "virtual_machine" {
  source     = "../../child_modules/azurerm_virtual_machine"
  vms        = var.vms
  depends_on = [module.subnet]
}

module "bastion" {
  source     = "../../child_modules/azurerm_bastion"
  bastions   = var.bastions
  depends_on = [module.subnet]
}

module "keyvault" {
  source     = "../../child_modules/azurerm_keyvault"
  keyvaults  = var.keyvaults
  depends_on = [module.resource_group]
}

module "waf" {
  source     = "../../child_modules/azurerm_waf"
  wafs       = var.wafs
  depends_on = [module.resource_group]
}

module "firewall" {
  source     = "../../child_modules/azurerm_firewall"
  firewalls  = var.firewalls
  depends_on = [module.subnet]
}

module "sql" {
  source     = "../../child_modules/azurerm_mssql_server"
  sqls       = var.sqls
  depends_on = [module.resource_group, module.subnet]
}

module "vnet_peering" {
  source     = "../../child_modules/azurerm_vnet_peering"
  peerings   = var.peerings
  depends_on = [module.virtual_network]
}
