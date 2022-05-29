# ----VMLUE01 CONFIGURATION FILE----

# Create frontend network interface
resource "azurerm_network_interface" "nic_front_vmlue01" {
  name                = "NIC_Front_VMLUE01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "external"
    subnet_id                     = azurerm_subnet.subnetfe01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip_vmlue01.id
  }
}

# Connect the security group to the frontend interface
resource "azurerm_network_interface_security_group_association" "nsg_assoc_vmlue01" {
  network_interface_id      = azurerm_network_interface.nic_front_vmlue01.id
  network_security_group_id = azurerm_network_security_group.nsg_vmlue01.id
}

# Create backend network interface
resource "azurerm_network_interface" "nic_back_vmlue01" {
  name                = "NIC_Back_VMLUE01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal_static"
    subnet_id                     = azurerm_subnet.subnetbe01.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.20.2"
  }
}

# Create (and display) an SSH key
resource "tls_private_key" "ssh_vmlue01" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vmlue01" {
  name                = "VMLUE01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [
    azurerm_network_interface.nic_front_vmlue01.id,
    azurerm_network_interface.nic_back_vmlue01.id
  ]
  size = "Standard_B1s"

  os_disk {
    caching              = "None"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }

  computer_name                   = "vmlue01"
  admin_username                  = "sysadmin"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "sysadmin"
    public_key = tls_private_key.ssh_vmlue01.public_key_openssh
  }
}