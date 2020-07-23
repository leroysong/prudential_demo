variable "prefix" {
  default = "lsong-tf-test"
}

resource "azurerm_resource_group" "main" {
  name     = data.azurerm_resource_group.resource_group.name
  location = data.azurerm_resource_group.resource_group.location
}

resource "azurerm_virtual_network" "main" {
  name                = data.azurerm_virtual_network.vnet.name
  address_space       = data.azurerm_virtual_network.vnet.address_space
  location            = data.azurerm_virtual_network.vnet.location
  resource_group_name = data.azurerm_virtual_network.vnet.resource_group_name
}

resource "azurerm_subnet" "internal" {
  name                 = data.azurerm_subnet.subnet.name
  resource_group_name  = data.azurerm_subnet.subnet.resource_group_name
  virtual_network_name = data.azurerm_subnet.subnet.virtual_network_name
  address_prefix       = data.azurerm_subnet.subnet.address_prefix
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "lsong-test"
  }
}