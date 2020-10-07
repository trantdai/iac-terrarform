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
/*
############################################################################################
# RETRIEVE FIREWALL AVAILABILITY SET
############################################################################################

data "azurerm_availability_set" "firewall_availability_set" {
  name                = var.availability_set_name
  resource_group_name = var.resource_group_name
  #depends_on          = [azurerm_availability_set.firewall_availability_set]
}
*/
############################################################################################
# DEFINE PAN FIREWALL VM
############################################################################################

resource "azurerm_public_ip" "firewall_management_public_ip1" {
  count               = var.create_public_ip ? 1 : 0
  name                = "${var.pan_firewall_name}_public_mgmt"
  domain_name_label   = "${var.pan_firewall_name}-public-mgmt"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = var.address_allocation_method
  sku                 = var.azure_sku
  tags                = var.tags
}

resource "azurerm_network_interface" "firewall_management_eth10" {
  name                = "${var.pan_firewall_name}_mgmt_eth10"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.pan_firewall_name}_management"
    subnet_id                     = var.management_subnet_id
    private_ip_address_allocation = var.address_allocation_method
    private_ip_address            = var.management_private_ip
    #public_ip_address_id          = azurerm_public_ip.firewall_management_public_ip1.id
    public_ip_address_id = var.create_public_ip ? join("", azurerm_public_ip.firewall_management_public_ip1.*.id) : ""
  }
  tags = var.tags
}

resource "azurerm_network_interface" "firewall_public_eth11" {
  name                 = "${var.pan_firewall_name}_public_eth11"
  location             = var.resource_group_location
  resource_group_name  = var.resource_group_name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "${var.pan_firewall_name}_public"
    subnet_id                     = var.public_subnet_id
    private_ip_address_allocation = var.address_allocation_method
    private_ip_address            = var.public_interface_private_ip
  }
  tags = var.tags
}

resource "azurerm_network_interface" "firewall_private_eth12" {
  name                 = "${var.pan_firewall_name}_private_eth12"
  location             = var.resource_group_location
  resource_group_name  = var.resource_group_name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "${var.pan_firewall_name}_private"
    subnet_id                     = var.private_subnet_id
    private_ip_address_allocation = var.address_allocation_method
    private_ip_address            = var.private_interface_private_ip
  }
  tags = var.tags
}

resource "azurerm_virtual_machine" "panfw" {
  name                = var.pan_firewall_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  vm_size             = var.pa_vm_size
  availability_set_id = var.availability_set_id

  depends_on = [azurerm_network_interface.firewall_management_eth10,
    azurerm_network_interface.firewall_public_eth11,
    azurerm_network_interface.firewall_private_eth12
  ]
  plan {
    #name      = var.pan_license_types["byol"]
    name      = var.pan_license_type
    publisher = var.pan_publisher
    product   = var.pan_product
  }

  storage_image_reference {
    publisher = var.pan_publisher
    offer     = var.pan_product
    #sku       = var.pan_license_types["byol"]
    sku     = var.pan_license_type
    version = var.panos_version
  }

  storage_os_disk {
    name          = "${var.pan_firewall_name}_os_disk"
    caching       = var.disk_caching_option
    create_option = var.disk_create_option
  }

  os_profile {
    computer_name  = var.pan_firewall_name
    admin_username = var.admin_credentials["username"]
    admin_password = var.admin_credentials["password"]
    custom_data = join(
      ",",
      [
        "storage-account=${var.bootstrap_storage_account}",
        "access-key=${var.bootstrap_storage_access_key}",
        "file-share=${var.bootstrap_storage_file_share}",
        "share-directory=${var.bootstrap_storage_share_directory}"
      ],
    )
  }

  primary_network_interface_id = azurerm_network_interface.firewall_management_eth10.id
  network_interface_ids = [azurerm_network_interface.firewall_management_eth10.id,
    azurerm_network_interface.firewall_public_eth11.id,
    azurerm_network_interface.firewall_private_eth12.id,
  ]

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = var.tags
}

############################################################################################
# APPLY NETWORK SECURITY GROUPS TO PAN FIREWALL VM NICS
############################################################################################

resource "azurerm_network_interface_security_group_association" "firewall_management_sga" {
  network_interface_id      = azurerm_network_interface.firewall_management_eth10.id
  network_security_group_id = var.management_interface_nsg_id
}

resource "azurerm_network_interface_security_group_association" "firewall_public_interface_sga" {
  network_interface_id      = azurerm_network_interface.firewall_public_eth11.id
  network_security_group_id = var.data_interface_nsg_id
}

resource "azurerm_network_interface_security_group_association" "firewall_private_interface_sga" {
  network_interface_id      = azurerm_network_interface.firewall_private_eth12.id
  network_security_group_id = var.data_interface_nsg_id
}
