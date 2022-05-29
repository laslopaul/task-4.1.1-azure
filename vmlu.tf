# ----VMLU01 & VMLU02 CONFIGURATION FILE----

# Create network interfaces
resource "azurerm_network_interface" "nic_vmlu" {
  count               = 2
  name                = "NIC_VMLU0${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal_static"
    subnet_id                     = azurerm_subnet.subnetbe01.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.20.1${count.index + 1}"
  }
}

# Create SSH keys
resource "tls_private_key" "ssh_vmlu" {
  count     = 2
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machines
resource "azurerm_linux_virtual_machine" "vmlu" {
  count                 = 2
  name                  = "VMLU0${count.index + 1}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [element(azurerm_network_interface.nic_vmlu.*.id, count.index)]
  size                  = "Standard_B1s"

  os_disk {
    caching              = "None"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "vmlu0${count.index + 1}"
  admin_username                  = "sysadmin"
  custom_data                     = filebase64("cloudinit/add_publickey.yaml")
  disable_password_authentication = true

  admin_ssh_key {
    username   = "sysadmin"
    public_key = element(tls_private_key.ssh_vmlu.*.public_key_openssh, count.index)
  }
}