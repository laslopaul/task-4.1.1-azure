# Create resource group
resource "azurerm_resource_group" "rg" {
  name     = "RG_TASK_411"
  location = "eastus"
}

# Create virtual network
resource "azurerm_virtual_network" "vnet0" {
  name                = "VirtualNet411"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnetbe01
resource "azurerm_subnet" "subnetbe01" {
  name                 = "Subnetbe01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet0.name
  address_prefixes     = ["10.0.20.0/24"]
}

# Create subnetfe01
resource "azurerm_subnet" "subnetfe01" {
  name                 = "Subnetfe01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet0.name
  address_prefixes     = ["10.0.10.0/24"]
}

# Create public IP for VMLUE01
resource "azurerm_public_ip" "publicip_vmlue01" {
  name                = "PublicIP_VMLUE01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}
