# ----VMLU01 CONFIGURATION FILE----

# Create network interface
resource "azurerm_network_interface" "nic_vmlu01" {
  name                = "NIC_VMLU01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal_static"
    subnet_id                     = azurerm_subnet.subnetbe01.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.20.11"
  }
}

# Create (and display) an SSH key
resource "tls_private_key" "ssh_vmlu01" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vmlu01" {
  name                  = "VMLU01"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic_vmlu01.id]
  size                  = "Standard_B1s"

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

  computer_name                   = "vmlu01"
  admin_username                  = "sysadmin"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "sysadmin"
    public_key = tls_private_key.ssh_vmlu01.public_key_openssh
  }
}