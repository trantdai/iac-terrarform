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
# PROCESS EACH MODULE IN ORDER
############################################################################################

## Add bootstrap module here.


############################################################################################
# LOAD RESOURCEGROUP MODULE: CREATING RESOURCE GROUP
############################################################################################

module "resourcegroup" {
  source = "../modules/resourcegroup"

  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

/*
############################################################################################
# CREATE A RESOURCE GROUP
############################################################################################

resource "azurerm_resource_group" "firewall_resource_group" {
  count = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.resource_group_location
  tags     = var.tags
}
*/
############################################################################################
# RETRIEVE RESOURCE GROUP AND DEFINE LOCAL VARS
############################################################################################

data "azurerm_resource_group" "iac_resource_group" {
  name       = var.resource_group_name
  depends_on = [module.resourcegroup]
}

locals {
  resource_group_name     = data.azurerm_resource_group.iac_resource_group.name
  resource_group_location = data.azurerm_resource_group.iac_resource_group.location
}

############################################################################################
# LOAD HUB MODULE: CREATING VNET, FIREWALL SUBNETS, NETWORK SECURITY GROUPS, ROUTE TABLES, ROUTES
############################################################################################

module "hub" {
  source                  = "../modules/network/hub"
  resource_group_name     = local.resource_group_name
  resource_group_location = local.resource_group_location

  hub_virtual_network         = var.hub_virtual_network
  hub_vnet_ipv4_address_space = var.hub_vnet_ipv4_address_space
  hub_subnets                 = var.hub_subnets

  availability_set_name = var.availability_set_name

  data_interface_nsg_name       = var.data_interface_nsg_name
  management_interface_nsg_name = var.management_interface_nsg_name
  security_group_rule_names     = var.security_group_rule_names
  security_rule_priorities      = var.security_rule_priorities
  flow_directions               = var.flow_directions
  security_rule_actions         = var.security_rule_actions
  security_rule_protocols       = var.security_rule_protocols
  security_rule_ports           = var.security_rule_ports
  source_address_prefix         = var.source_address_prefix
  permitted_source              = var.permitted_source
  destination_address_prefix    = var.destination_address_prefix

}

############################################################################################
# LOAD FIREWALL MODULE: CREATING PAN FIREWALL VM1 & VM2
############################################################################################

module "panfw1" {
  source                  = "../modules/network/firewall"
  resource_group_name     = local.resource_group_name
  resource_group_location = local.resource_group_location

  tags = var.tags

  availability_set_id = module.hub.firewall_availability_set_id

  pan_firewall_name = var.pan_firewall_names["fwa"]

  address_allocation_method = var.address_allocation_methods["static"]

  azure_sku = var.azure_sku

  management_subnet_id = module.hub.management_subnet_id
  public_subnet_id     = module.hub.public_subnet_id
  private_subnet_id    = module.hub.private_subnet_id

  data_interface_nsg_id       = module.hub.data_interface_nsg_id
  management_interface_nsg_id = module.hub.management_interface_nsg_id

  management_private_ip        = var.management_private_ips["fwa"]
  public_interface_private_ip  = var.public_interface_private_ips["fwa"]
  private_interface_private_ip = var.private_interface_private_ips["fwa"]

  pa_vm_size = var.pa_vm_sizes["standard_d3v2"]

  #pan_license_type = var.pan_license_types["bundle2"]
  pan_license_type = var.pan_license_types["byol"]

  pan_publisher = var.pan_publisher

  pan_product = var.pan_product

  panos_version = var.panos_version

  disk_caching_option = var.disk_caching_option

  disk_create_option = var.disk_create_option

  admin_credentials = var.admin_credentials

  #Bootstrapping
  bootstrap_storage_account         = var.bootstrap_storage_account
  bootstrap_storage_access_key      = var.bootstrap_storage_access_key
  bootstrap_storage_file_share      = var.bootstrap_storage_file_share
  bootstrap_storage_share_directory = var.bootstrap_storage_share_directory_fwa

}

module "panfw2" {
  source                  = "../modules/network/firewall"
  resource_group_name     = local.resource_group_name
  resource_group_location = local.resource_group_location

  tags = var.tags

  availability_set_id = module.hub.firewall_availability_set_id

  pan_firewall_name = var.pan_firewall_names["fwb"]

  address_allocation_method = var.address_allocation_methods["static"]

  azure_sku = var.azure_sku

  management_subnet_id = module.hub.management_subnet_id
  public_subnet_id     = module.hub.public_subnet_id
  private_subnet_id    = module.hub.private_subnet_id

  data_interface_nsg_id       = module.hub.data_interface_nsg_id
  management_interface_nsg_id = module.hub.management_interface_nsg_id

  management_private_ip        = var.management_private_ips["fwb"]
  public_interface_private_ip  = var.public_interface_private_ips["fwb"]
  private_interface_private_ip = var.private_interface_private_ips["fwb"]

  pa_vm_size = var.pa_vm_sizes["standard_d3v2"]

  #pan_license_type = var.pan_license_types["bundle2"]
  pan_license_type = var.pan_license_types["byol"]

  pan_publisher = var.pan_publisher

  pan_product = var.pan_product

  panos_version = var.panos_version

  disk_caching_option = var.disk_caching_option

  disk_create_option = var.disk_create_option

  admin_credentials = var.admin_credentials

  #Bootstrapping
  bootstrap_storage_account         = var.bootstrap_storage_account
  bootstrap_storage_access_key      = var.bootstrap_storage_access_key
  bootstrap_storage_file_share      = var.bootstrap_storage_file_share
  bootstrap_storage_share_directory = var.bootstrap_storage_share_directory_fwa

}

############################################################################################
# LOAD INTERNAL LOAD BALANCER MODULE
############################################################################################

module "privatelb" {
  source                  = "../modules/network/loadbalancer/internal"
  resource_group_name     = local.resource_group_name
  resource_group_location = local.resource_group_location

  tags = var.tags

  address_allocation_methods = var.address_allocation_methods
  azure_sku                  = var.azure_sku

  pan_firewall_names = var.pan_firewall_names

  private_subnet_id              = module.hub.private_subnet_id
  lb_frontend_private_ip_address = var.lb_frontend_private_ip_address

  load_balancer_name = var.private_load_balancer_name

  load_balancer_frontend_ip_config_name = var.private_load_balancer_frontend_ip_config_name

  lb_probe_name = var.private_lb_probe_name

  load_balancer_protocols = var.load_balancer_protocols

  lb_ports = var.lb_ports

  lb_probe_interval = var.lb_probe_interval

  lb_probe_unhealthy_threshold = var.lb_probe_unhealthy_threshold

  lb_pool_name = var.private_lb_pool_name

  lb_rule_names = var.lb_rule_names

  load_distribution_option = var.load_distribution_options["clientipprotocol"]

  #Retrieve from output of firewall module
  firewall1_private_interface_id = module.panfw1.private_interface_id
  firewall2_private_interface_id = module.panfw2.private_interface_id
}

############################################################################################
# LOAD PUBLIC LOAD BALANCER MODULE
############################################################################################

module "publiclb" {
  source                  = "../modules/network/loadbalancer/public"
  resource_group_name     = local.resource_group_name
  resource_group_location = local.resource_group_location

  tags = var.tags

  address_allocation_methods = var.address_allocation_methods
  azure_sku                  = var.azure_sku

  load_balancer_name = var.public_load_balancer_name

  public_load_balancer_domain_name = var.public_load_balancer_domain_name

  load_balancer_frontend_ip_config_name = var.public_load_balancer_frontend_ip_config_name

  lb_probe_name = var.public_lb_probe_name

  load_balancer_protocols = var.load_balancer_protocols

  lb_ports = var.lb_ports

  lb_probe_interval = var.lb_probe_interval

  lb_probe_unhealthy_threshold = var.lb_probe_unhealthy_threshold

  lb_pool_name = var.public_lb_pool_name

  lb_rule_names = var.lb_rule_names

  load_distribution_option = var.load_distribution_options["clientipprotocol"]

  #Retrieve from output of firewall module
  firewall1_public_interface_id = module.panfw1.public_interface_id
  firewall2_public_interface_id = module.panfw2.public_interface_id

  pan_firewall_names = var.pan_firewall_names
}

############################################################################################
# CREATE ROUTE TABLES AND USER DEFINED ROUTES IN HUB
############################################################################################

# Firewall management subnet
resource "azurerm_route_table" "firewall_management_route_table" {
  name                          = var.firewall_management_route_table
  location                      = local.resource_group_location
  resource_group_name           = local.resource_group_name
  disable_bgp_route_propagation = false
  route {
    name           = var.management_to_public_route_name
    address_prefix = var.hub_subnets["public"][0]
    next_hop_type  = var.next_hop_types["none"]
  }
  tags = var.tags
}

resource "azurerm_subnet_route_table_association" "management_subnet_route_table_asscociation" {
  subnet_id      = module.hub.management_subnet_id
  route_table_id = azurerm_route_table.firewall_management_route_table.id
}

# Firewall public subnet
resource "azurerm_route_table" "firewall_public_route_table" {
  name                          = var.firewall_public_route_table
  location                      = local.resource_group_location
  resource_group_name           = local.resource_group_name
  disable_bgp_route_propagation = false
  route {
    name           = var.public_to_management_route_name
    address_prefix = var.hub_subnets["management"][0]
    next_hop_type  = var.next_hop_types["none"]
  }
  route {
    name           = var.public_to_private_route_name
    address_prefix = var.hub_subnets["private"][0]
    next_hop_type  = var.next_hop_types["none"]
  }
  tags = var.tags
}

resource "azurerm_subnet_route_table_association" "public_subnet_route_table_asscociation" {
  subnet_id      = module.hub.public_subnet_id
  route_table_id = azurerm_route_table.firewall_public_route_table.id
}

# Firewall private subnet
resource "azurerm_route_table" "firewall_private_route_table" {
  name                          = var.firewall_private_route_table
  location                      = local.resource_group_location
  resource_group_name           = local.resource_group_name
  disable_bgp_route_propagation = false

  route {
    name           = var.private_to_public_route_name
    address_prefix = var.hub_subnets["public"][0]
    next_hop_type  = var.next_hop_types["none"]
  }
  route {
    name                   = var.private_default_route_name
    address_prefix         = var.all_ipv4_networks
    next_hop_type          = var.next_hop_types["virtualappliance"]
    next_hop_in_ip_address = var.lb_frontend_private_ip_address
  }
  tags = var.tags
}

resource "azurerm_subnet_route_table_association" "private_subnet_route_table_asscociation" {
  subnet_id      = module.hub.private_subnet_id
  route_table_id = azurerm_route_table.firewall_private_route_table.id
}

# Hub jump subnet
resource "azurerm_route_table" "hub_jump_subnet_route_table" {
  name                          = var.hub_jump_subnet_route_table
  location                      = local.resource_group_location
  resource_group_name           = local.resource_group_name
  disable_bgp_route_propagation = false
  route {
    name                   = var.jump_to_hub_vnet_route_name
    address_prefix         = var.hub_vnet_ipv4_address_space[0]
    next_hop_type          = var.next_hop_types["virtualappliance"]
    next_hop_in_ip_address = var.lb_frontend_private_ip_address
  }
  route {
    name                   = var.jump_to_rfc1918_classa_route_name
    address_prefix         = var.rfc1918_networks["classa"]
    next_hop_type          = var.next_hop_types["virtualappliance"]
    next_hop_in_ip_address = var.lb_frontend_private_ip_address
  }
  route {
    name                   = var.jump_to_rfc1918_classb_route_name
    address_prefix         = var.rfc1918_networks["classb"]
    next_hop_type          = var.next_hop_types["virtualappliance"]
    next_hop_in_ip_address = var.lb_frontend_private_ip_address
  }
  route {
    name                   = var.jump_to_rfc1918_classc_route_name
    address_prefix         = var.rfc1918_networks["classc"]
    next_hop_type          = var.next_hop_types["virtualappliance"]
    next_hop_in_ip_address = var.lb_frontend_private_ip_address
  }
  tags = var.tags
}

resource "azurerm_subnet_route_table_association" "jump_subnet_route_table_asscociation" {
  subnet_id      = module.hub.jump_subnet_id
  route_table_id = azurerm_route_table.hub_jump_subnet_route_table.id
}

############################################################################################
# CREATE WINDOWS JUMP VM IN PRIVATE SUBNET
############################################################################################

module "jumpserver" {
  source                  = "../modules/compute/windows"
  resource_group_name     = local.resource_group_name
  resource_group_location = local.resource_group_location

  tags = var.tags

  create_public_ip  = true #var.create_public_ip
  public_ip_name    = var.windows_jumpserver_public_ip_name
  domain_name_label = var.windows_jumpserver_domain_name_label

  public_address_allocation_method = var.address_allocation_methods["dynamic"]

  network_interface_name = var.windows_jumpserver_network_interface_name

  ip_config_name = var.windows_jumpserver_ip_config_name

  subnet_id = module.hub.jump_subnet_id

  interface_address_allocation_method = var.address_allocation_methods["dynamic"]

  vm_name = var.windows_jumpserver_vm_name

  vm_size = var.vm_sizes["standardf2"]

  admin_credentials = var.admin_credentials

  os_disk_name = "win_jumpserver_os_disk"

  disk_caching_option = var.disk_caching_option

  storage_account_type = var.storage_account_types["standardlrs"]

  publisher       = var.windows_publisher
  offer           = var.windows_offer
  sku             = var.windows_sku
  windows_version = var.windows_version
}


############################################################################################
# CREATE WINDOWS VM IN PRIVATE SUBNET
############################################################################################

module "windows" {
  source                  = "../modules/compute/windows"
  resource_group_name     = local.resource_group_name
  resource_group_location = local.resource_group_location

  tags = var.tags

  create_public_ip = false #var.create_public_ip

  network_interface_name = var.windows_vm_network_interface_name

  ip_config_name = var.windows_vm_ip_config_name

  subnet_id = module.hub.private_subnet_id

  interface_address_allocation_method = var.address_allocation_methods["dynamic"]

  vm_name = var.windows_vm_name

  vm_size = var.vm_sizes["standardf2"]

  admin_credentials = var.admin_credentials

  os_disk_name = "win1_os_disk"

  disk_caching_option = var.disk_caching_option

  storage_account_type = var.storage_account_types["standardlrs"]

  publisher       = var.windows_publisher
  offer           = var.windows_offer
  sku             = var.windows_sku
  windows_version = var.windows_version
}
