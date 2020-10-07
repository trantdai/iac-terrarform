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
# CREATE HUB VNET AND FIREWALL SUBNETS
############################################################################################

resource "azurerm_virtual_network" "iac_firewall_vnet" {
  name                = var.hub_virtual_network
  address_space       = var.hub_vnet_ipv4_address_space
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "private_subnet" {
  name                 = var.private_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.iac_firewall_vnet.name
  address_prefixes     = var.hub_subnets["private"]
}

resource "azurerm_subnet" "public_subnet" {
  name                 = var.public_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.iac_firewall_vnet.name
  address_prefixes     = var.hub_subnets["public"]
}

resource "azurerm_subnet" "management_subnet" {
  name                 = var.managment_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.iac_firewall_vnet.name
  address_prefixes     = var.hub_subnets["management"]
}

resource "azurerm_subnet" "jump_subnet" {
  name                 = var.jump_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.iac_firewall_vnet.name
  address_prefixes     = var.hub_subnets["jump"]
}

############################################################################################
# CREATE FIREWALL AVAILABILITY SET
############################################################################################

resource "azurerm_availability_set" "firewall_availability_set" {
  name                = var.availability_set_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

############################################################################################
# CREATE NETWORK SECURITY GROUPS FOR FIREWALL INTERFACES
############################################################################################

resource "azurerm_network_security_group" "data_interface_nsg" {
  name                = var.data_interface_nsg_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = var.security_group_rule_names["allowall"]
    priority                   = var.security_rule_priorities["prio100"]
    direction                  = var.flow_directions["inbound"]
    access                     = var.security_rule_actions["allow"]
    protocol                   = var.security_rule_protocols["all"]
    source_port_range          = var.security_rule_ports["all"]
    destination_port_range     = var.security_rule_ports["all"]
    source_address_prefix      = var.source_address_prefix
    destination_address_prefix = var.destination_address_prefix
  }
  tags = var.tags
}

resource "azurerm_network_security_group" "management_interface_nsg" {
  name                = var.management_interface_nsg_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = var.security_group_rule_names["allowhttps"]
    priority                   = var.security_rule_priorities["prio100"]
    direction                  = var.flow_directions["inbound"]
    access                     = var.security_rule_actions["allow"]
    protocol                   = var.security_rule_protocols["tcp"]
    source_port_range          = var.security_rule_ports["all"]
    destination_port_ranges    = [var.security_rule_ports["https"], var.security_rule_ports["tcp_28443"], var.security_rule_ports["tcp_3978"]]
    source_address_prefix      = var.source_address_prefix
    destination_address_prefix = var.destination_address_prefix
  }
  security_rule {
    name                       = var.security_group_rule_names["allowssh"]
    priority                   = var.security_rule_priorities["prio200"]
    direction                  = var.flow_directions["inbound"]
    access                     = var.security_rule_actions["allow"]
    protocol                   = var.security_rule_protocols["tcp"]
    source_port_range          = var.security_rule_ports["all"]
    destination_port_range     = var.security_rule_ports["ssh"]
    source_address_prefix      = var.permitted_source
    destination_address_prefix = var.destination_address_prefix
  }
  tags = var.tags
}
