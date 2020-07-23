data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = "LSONG-DEV-VNET"
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = "lsong-subnet-1"
  virtual_network_name = "LSONG-DEV-VNET"
  resource_group_name  = var.resource_group_name
}

