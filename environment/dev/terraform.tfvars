rgs = {
  rg1 = {
    name     = "Frontend-Rg"
    location = "East US"
  }
  rg2 = {
    name     = "Backend-Rg"
    location = "East US"
  }
}

vnets = {
  vnet1 = {
    name                = "Hub_vnet"
    location            = "East US"
    resource_group_name = "Frontend-Rg"
    address_space       = ["10.0.0.0/16"]
  }
  vnet2 = {
    name                = "Spoke1_vnet"
    location            = "East US"
    resource_group_name = "Frontend-Rg"
    address_space       = ["10.1.0.0/16"]
  }
  vnet3 = {
    name                = "Spoke2_vnet"
    location            = "East US"
    resource_group_name = "Backend-Rg"
    address_space       = ["10.2.0.0/16"]
  }
  vnet4 = {
    name                = "Spoke3_vnet"
    location            = "East US"
    resource_group_name = "Backend-Rg"
    address_space       = ["10.3.0.0/16"]
  }
}

subnets = {
  subnet1 = {
    name                 = "Frontend-Subnet"
    resource_group_name  = "Frontend-Rg"
    virtual_network_name = "Spoke1_vnet"
    address_prefixes     = ["10.1.1.0/24"]
  }
  subnet2 = {
    name                 = "Backend-Subnet"
    resource_group_name  = "Backend-Rg"
    virtual_network_name = "Spoke2_vnet"
    address_prefixes     = ["10.2.1.0/24"]
  }
  sql_subnet = {
    name                 = "SQL-Subnet"
    resource_group_name  = "Backend-Rg"
    virtual_network_name = "Spoke3_vnet"
    address_prefixes     = ["10.3.1.0/24"]
  }
  bastion_subnet = {
    name                 = "AzureBastionSubnet"
    resource_group_name  = "Frontend-Rg"
    virtual_network_name = "Hub_vnet"
    address_prefixes     = ["10.0.1.0/24"]
  }
  firewall_subnet = {
    name                 = "AzureFirewallSubnet"
    resource_group_name  = "Frontend-Rg"
    virtual_network_name = "Hub_vnet"
    address_prefixes     = ["10.0.2.0/24"]
  }
}

vms = {
  vm1 = {
    name                = "Frontend_vm"
    resource_group_name = "Frontend-Rg"
    location            = "East US"
    size                = "Standard_B2s"
    admin_username      = "azureuser"
    admin_password      = "P@ssw0rd1234!"
    nic_name            = "frontend-nic"
    powershell_script   = <<EOF
Install-WindowsFeature -Name Web-Server -IncludeManagementTools;
New-Item -ItemType Directory -Force -Path 'C:\inetpub\wwwroot\react-app';
@'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Spoke 1 - React Application</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #0f172a; color: #f8fafc; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .card { background: #1e293b; padding: 2.5rem; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.5); text-align: center; }
        h1 { color: #38bdf8; }
    </style>
</head>
<body>
    <div class="card">
        <h1>⚛️ Spoke 1: React Application</h1>
        <p>Built and Deployed Automatically on Azure VM via PowerShell CustomScriptExtension</p>
    </div>
</body>
</html>
'@ | Set-Content -Path 'C:\inetpub\wwwroot\react-app\index.html';
Import-Module WebAdministration;
Set-ItemProperty 'IIS:\Sites\Default Web Site' -Name physicalPath -Value 'C:\inetpub\wwwroot\react-app';
Restart-Service W3SVC;
EOF
  }
  vm2 = {
    name                = "Backend_vm"
    resource_group_name = "Backend-Rg"
    location            = "East US"
    size                = "Standard_B2s"
    admin_username      = "azureuser"
    admin_password      = "P@ssw0rd1234!"
    nic_name            = "backend-nic"
    powershell_script   = <<EOF
Install-WindowsFeature -Name Web-Server -IncludeManagementTools;
New-Item -ItemType Directory -Force -Path 'C:\dotnet-app';
Set-Location 'C:\dotnet-app';
Invoke-WebRequest -Uri 'https://dotnetcli.azureedge.net/dotnet/Sdk/8.0.100/dotnet-sdk-8.0.100-win-x64.exe' -OutFile '$env:TEMP\dotnet.exe';
Start-Process '$env:TEMP\dotnet.exe' -ArgumentList '/quiet /norestart' -Wait;
& 'C:\Program Files\dotnet\dotnet.exe' new webapi -n DotNetBackend --no-https;
Set-Location 'C:\dotnet-app\DotNetBackend';
& 'C:\Program Files\dotnet\dotnet.exe' publish -c Release -o 'C:\inetpub\wwwroot\dotnet-api';
Import-Module WebAdministration;
Set-ItemProperty 'IIS:\Sites\Default Web Site' -Name physicalPath -Value 'C:\inetpub\wwwroot\dotnet-api';
Restart-Service W3SVC;
EOF
  }
}

bastions = {
  bastion1 = {
    name                 = "Hub-Bastion"
    location             = "East US"
    resource_group_name  = "Frontend-Rg"
    virtual_network_name = "Hub_vnet"
    subnet_name          = "AzureBastionSubnet"
    public_ip_name       = "bastion-pip"
    ip_config_name       = "bastion-ip-config"
  }
}

keyvaults = {
  kv1 = {
    name                = "dev-keyvault-01"
    location            = "East US"
    resource_group_name = "Backend-Rg"
    tenant_id           = "00000000-0000-0000-0000-000000000000"
  }
}

wafs = {
  waf1 = {
    name                = "dev-waf-policy"
    location            = "East US"
    resource_group_name = "Frontend-Rg"
  }
}

firewalls = {
  fw1 = {
    name                 = "Hub-Firewall"
    location             = "East US"
    resource_group_name  = "Frontend-Rg"
    virtual_network_name = "Hub_vnet"
    subnet_name          = "AzureFirewallSubnet"
    public_ip_name       = "firewall-pip"
    ip_config_name       = "fw-ip-config"
  }
}

sqls = {
  sql1 = {
    name                         = "spoke3-sql-server"
    resource_group_name          = "Backend-Rg"
    location                     = "East US"
    version                      = "12.0"
    administrator_login          = "sqladmin"
    administrator_login_password = "P@ssw0rd1234!"
    db_name                      = "Spoke3-SQL-Db"
    sku_name                     = "Basic"
  }
}

peerings = {
  hub_to_spoke1 = {
    name                         = "hub-to-spoke1"
    resource_group_name          = "Frontend-Rg"
    virtual_network_name         = "Hub_vnet"
    remote_virtual_network_name  = "Spoke1_vnet"
    remote_resource_group_name   = "Frontend-Rg"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
  }
  hub_to_spoke2 = {
    name                         = "hub-to-spoke2"
    resource_group_name          = "Frontend-Rg"
    virtual_network_name         = "Hub_vnet"
    remote_virtual_network_name  = "Spoke2_vnet"
    remote_resource_group_name   = "Backend-Rg"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
  }
  hub_to_spoke3 = {
    name                         = "hub-to-spoke3"
    resource_group_name          = "Frontend-Rg"
    virtual_network_name         = "Hub_vnet"
    remote_virtual_network_name  = "Spoke3_vnet"
    remote_resource_group_name   = "Backend-Rg"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
  }
  spoke1_to_hub = {
    name                         = "spoke1-to-hub"
    resource_group_name          = "Frontend-Rg"
    virtual_network_name         = "Spoke1_vnet"
    remote_virtual_network_name  = "Hub_vnet"
    remote_resource_group_name   = "Frontend-Rg"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
  }
  spoke2_to_hub = {
    name                         = "spoke2-to-hub"
    resource_group_name          = "Backend-Rg"
    virtual_network_name         = "Spoke2_vnet"
    remote_virtual_network_name  = "Hub_vnet"
    remote_resource_group_name   = "Frontend-Rg"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
  }
  spoke3_to_hub = {
    name                         = "spoke3-to-hub"
    resource_group_name          = "Backend-Rg"
    virtual_network_name         = "Spoke3_vnet"
    remote_virtual_network_name  = "Hub_vnet"
    remote_resource_group_name   = "Frontend-Rg"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
  }
}
