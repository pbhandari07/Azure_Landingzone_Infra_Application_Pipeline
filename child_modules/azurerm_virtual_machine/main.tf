data "azurerm_network_interface" "nic" {
  for_each            = var.vms
  name                = each.value.nic_name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_windows_virtual_machine" "resource" {
  for_each              = var.vms
  name                  = each.value.name
  resource_group_name   = each.value.resource_group_name
  location              = each.value.location
  size                  = each.value.size
  admin_username        = each.value.admin_username
  admin_password        = each.value.admin_password
  network_interface_ids = [data.azurerm_network_interface.nic[each.key].id]
  custom_data           = lookup(each.value, "custom_data", null) != null ? base64encode(each.value.custom_data) : null

  os_disk {
    caching              = lookup(each.value, "os_disk_caching", "ReadWrite")
    storage_account_type = lookup(each.value, "os_disk_storage_account_type", "Standard_LRS")
  }

  source_image_reference {
    publisher = lookup(each.value, "publisher", "MicrosoftWindowsServer")
    offer     = lookup(each.value, "offer", "WindowsServer")
    sku       = lookup(each.value, "sku", "2022-Datacenter")
    version   = lookup(each.value, "version", "latest")
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_virtual_machine_extension" "powershell_deploy" {
  for_each             = { for k, v in var.vms : k => v if lookup(v, "powershell_script", null) != null }
  name                 = "AutoAppDeploy"
  virtual_machine_id   = azurerm_windows_virtual_machine.resource[each.key].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  protected_settings = jsonencode({
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -Command \"${each.value.powershell_script}\""
  })

  lifecycle {
    prevent_destroy = true
  }
}
