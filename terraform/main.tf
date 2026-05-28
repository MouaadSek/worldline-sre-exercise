terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "sre" {
  name     = "rg-worldline-sre"
  location = "Sweden Central"
}
resource "azurerm_virtual_network" "sre" {
  name                = "vnet-worldline-sre"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.sre.location
  resource_group_name = azurerm_resource_group.sre.name
}
resource "azurerm_subnet" "sre" {
  name                 = "subnet-worldline-sre"
  resource_group_name  = azurerm_resource_group.sre.name
  virtual_network_name = azurerm_virtual_network.sre.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_public_ip" "sre" {
  name                = "pip-worldline-sre"
  location            = azurerm_resource_group.sre.location
  resource_group_name = azurerm_resource_group.sre.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_network_security_group" "sre" {
  name                = "nsg-worldline-sre"
  location            = azurerm_resource_group.sre.location
  resource_group_name = azurerm_resource_group.sre.name
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_network_interface" "sre" {
  name                = "nic-worldline-sre"
  location            = azurerm_resource_group.sre.location
  resource_group_name = azurerm_resource_group.sre.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sre.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.sre.id
  }
}
resource "azurerm_linux_virtual_machine" "sre" {
  name                = "vm-worldline-sre"
  resource_group_name = azurerm_resource_group.sre.name
  location            = azurerm_resource_group.sre.location
  size                = "Standard_B2ats_v2"
  admin_username      = "msekkouri"
  admin_ssh_key {
    username   = "msekkouri"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  network_interface_ids = [azurerm_network_interface.sre.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "resf"
    offer     = "rockylinux-x86_64"
    sku       = "9-lvm"
    version   = "latest"
  }
}
resource "azurerm_managed_disk" "mysql_logs" {
  name                 = "disk-mysql-logs"
  location             = azurerm_resource_group.sre.location
  resource_group_name  = azurerm_resource_group.sre.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}
resource "azurerm_virtual_machine_data_disk_attachment" "mysql_logs" {
  managed_disk_id    = azurerm_managed_disk.mysql_logs.id
  virtual_machine_id = azurerm_linux_virtual_machine.sre.id
  lun                = 0
  caching            = "None"
}
output "public_ip" {
  value = azurerm_public_ip.sre.ip_address
}
