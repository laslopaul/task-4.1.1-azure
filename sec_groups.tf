# Create security group for VMLUE01, making it accessible from the Internet
resource "azurerm_network_security_group" "nsg_vmlue01" {
  name                = "NSG_VMLUE01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowSSHInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowFTPInbound"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "21"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create security group for subnetbe01
resource "azurerm_network_security_group" "nsg_backend" {
  name                = "NSG_Backend"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowInboundFromVMLUE"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.20.10/32"
    destination_address_prefix = "10.0.20.0/24"
  }

  security_rule {
    name                       = "DenyVnetInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "10.0.20.0/24"
  }

}

# Connect the security group to subnetbe01
resource "azurerm_subnet_network_security_group_association" "nsg_assoc_subnetbe01" {
  subnet_id                 = azurerm_subnet.subnetbe01.id
  network_security_group_id = azurerm_network_security_group.nsg_backend.id
}
