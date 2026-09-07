# Azure Landing Zone Infrastructure & Automated Application Pipeline

> **Repository Name:** `Azure_Landingzone_Infra_Application_Pipeline`

Production-ready, highly scalable Azure Hub-and-Spoke Landing Zone infrastructure written in modular Terraform (HCL) with automated in-VM application build and deployment pipelines using PowerShell and Azure CustomScriptExtension.

---

## 📌 Key Architectural Highlights

* **Hub-and-Spoke VNet Topology**:
  * **`Hub_vnet`**: Hosts Azure Firewall, Azure Bastion Host, and WAF Policy.
  * **`Spoke1_vnet`**: Hosts Frontend workload (React Application).
  * **`Spoke2_vnet`**: Hosts Backend workload (.NET Core 8 Web API).
  * **`Spoke3_vnet`**: Hosts Database workload (Azure SQL Server & SQL Database).
* **Bidirectional VNet Peering**: Configured dynamically between Hub and all three Spokes (`Hub <-> Spoke1`, `Hub <-> Spoke2`, `Hub <-> Spoke3`).
* **Modular Infrastructure Design**: 10 reusable child modules built using dynamic `for_each` map iterations:
  * Resource Groups (`azurerm_resource_group`)
  * Virtual Networks (`azurerm_virtual_network`)
  * Subnets (`azurerm_subnet`)
  * Windows Virtual Machines (`azurerm_windows_virtual_machine`)
  * Azure Bastion Host (`azurerm_bastion_host`)
  * Azure Key Vault (`azurerm_key_vault`)
  * Web Application Firewall (`azurerm_web_application_firewall_policy`)
  * Azure Firewall (`azurerm_firewall`)
  * Azure SQL Server & DB (`azurerm_mssql_server`)
  * Virtual Network Peering (`azurerm_virtual_network_peering`)
* **Automated In-VM Application Provisioning**:
  * **Spoke 1 VM**: Installs IIS & Node.js, builds, and deploys the **React Frontend App**.
  * **Spoke 2 VM**: Installs IIS & .NET 8.0 SDK/Runtime, compiles, and deploys the **.NET Core Web API**.
* **Enterprise Lifecycle Protection**: Guarded with `lifecycle { prevent_destroy = true }` across all critical resources to prevent accidental destruction.
* **Automated Deployment Script (`deploy.ps1`)**: Single-command PowerShell workflow executing `fmt`, `init`, `validate`, `plan`, and `apply`.

---

## 📁 Repository Directory Structure

```text
Azure_Landingzone_Infra_Application_Pipeline/
├── deploy.ps1                         # Master PowerShell Automation Script
├── environment/
│   └── dev/
│       ├── provider.tf                # AzureRM Provider Configuration
│       ├── main.tf                    # Core Module Invocations
│       ├── var.tf                     # Environment Variable Declarations
│       └── terraform.tfvars           # Environment Resource Data & App Scripts
└── child_modules/
    ├── azurerm_resource_group/        # Resource Group Module
    ├── azurerm_virtual_network/       # VNet Module
    ├── azurerm_subnet/                # Subnet Module
    ├── azurerm_virtual_machine/       # VM & CustomScriptExtension Module
    ├── azurerm_bastion/               # Azure Bastion Module
    ├── azurerm_keyvault/              # Azure Key Vault Module
    ├── azurerm_waf/                   # WAF Policy Module
    ├── azurerm_firewall/              # Azure Firewall Module
    ├── azurerm_mssql_server/          # Azure SQL Server & DB Module
    └── azurerm_vnet_peering/          # VNet Peering Module
```

---

## 🚀 How to Run the Automated Pipeline

1. **Clone the repository**:
   ```bash
   git clone https://github.com/YOUR_ORGANIZATION/Azure_Landingzone_Infra_Application_Pipeline.git
   cd Azure_Landingzone_Infra_Application_Pipeline
   ```

2. **Login to Azure CLI**:
   ```powershell
   az login
   ```

3. **Execute the Automated Deployment Script**:
   ```powershell
   .\deploy.ps1
   ```

The script will automatically format your code, initialize modules, validate configurations, generate execution plans, and apply the infrastructure while triggering the application build inside the VMs!
