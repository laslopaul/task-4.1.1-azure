# ----VMLU02 CONFIGURATION FILE----

# Create network interface
resource "azurerm_network_interface" "nic_vmlu02" {
  name                = "NIC_VMLU02"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal_static"
    subnet_id                     = azurerm_subnet.subnetbe01.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.20.12"
  }
}

# Create (and display) an SSH key
resource "tls_private_key" "ssh_vmlu02" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vmlu02" {
  name                  = "VMLU02"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic_vmlu02.id]
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

  computer_name                   = "vmlu02"
  admin_username                  = "sysadmin"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "sysadmin"
    public_key = tls_private_key.ssh_vmlu02.public_key_openssh
  }
}