############################################################################################
# Author: Dai Tran
# Email: trantdaiau@gmail.com
# Copyright 20202.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
############################################################################################

############################################################################################
# CREATE WINDOWS VIRTUAL MACHINE
############################################################################################

resource "azurerm_public_ip" "windows_public_ip" {
  count               = var.create_public_ip ? 1 : 0
  name                = var.public_ip_name
  domain_name_label   = var.domain_name_label
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = var.public_address_allocation_method
  tags                = var.tags
}

resource "azurerm_network_interface" "windows_interface" {
  #count               = var.create_public_ip ? 1 : 0
  name                = var.network_interface_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  ip_configuration {
    name                          = var.ip_config_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.interface_address_allocation_method
    public_ip_address_id          = var.create_public_ip ? join("", azurerm_public_ip.windows_public_ip.*.id) : ""
  }
}

resource "azurerm_windows_virtual_machine" "windows_vm" {
  #count                 = var.create_public_ip ? 1 : 0
  name                  = var.vm_name
  resource_group_name   = var.resource_group_name
  location              = var.resource_group_location
  size                  = var.vm_size
  admin_username        = var.admin_credentials["username"]
  admin_password        = var.admin_credentials["password"]
  network_interface_ids = [azurerm_network_interface.windows_interface.id]

  os_disk {
    name                 = var.os_disk_name
    caching              = var.disk_caching_option
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.windows_version
  }
}
