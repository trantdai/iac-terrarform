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

/*
############################################################################################
# LOAD RESOURCEGROUP MODULE: CREATING RESOURCE GROUP
############################################################################################

module "resourcegroup" {
  source = "./modules/resourcegroup"

  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}
*/
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
# RETRIEVE DEPENDING RESOURCES: RESOURCE GROUP, HUB SUBNETS, SECURITY GROUPS
############################################################################################

data "azurerm_resource_group" "iac_resource_group" {
  name = var.resource_group_name
}

data "azurerm_subnet" "management_subnet" {
  name                 = var.management_subnet_name
  virtual_network_name = var.hub_virtual_network_name
  #resource_group_name  = var.resource_group_name
  resource_group_name = data.azurerm_resource_group.iac_resource_group.name
}

data "azurerm_subnet" "public_subnet" {
  name                 = var.public_subnet_name
  virtual_network_name = var.hub_virtual_network_name
  #resource_group_name  = var.resource_group_name
  resource_group_name = data.azurerm_resource_group.iac_resource_group.name
}

data "azurerm_subnet" "private_subnet" {
  name                 = var.private_subnet_name
  virtual_network_name = var.hub_virtual_network_name
  #resource_group_name  = var.resource_group_name
  resource_group_name = data.azurerm_resource_group.iac_resource_group.name
}

data "azurerm_network_security_group" "data_interface_nsg" {
  name = var.data_interface_nsg_name
  #resource_group_name = var.resource_group_name
  resource_group_name = data.azurerm_resource_group.iac_resource_group.name
}

data "azurerm_network_security_group" "management_interface_nsg" {
  name = var.management_interface_nsg_name
  #resource_group_name = var.resource_group_name
  resource_group_name = data.azurerm_resource_group.iac_resource_group.name
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
# RETRIEVE RESOURCE GROUP AND DEFINE LOCAL VARS
############################################################################################

locals {
  resource_group_name          = data.azurerm_resource_group.iac_resource_group.name
  resource_group_location      = data.azurerm_resource_group.iac_resource_group.location
  firewall_availability_set_id = azurerm_availability_set.firewall_availability_set.id
  management_subnet_id         = data.azurerm_subnet.management_subnet.id
  public_subnet_id             = data.azurerm_subnet.public_subnet.id
  private_subnet_id            = data.azurerm_subnet.private_subnet.id
  data_interface_nsg_id        = data.azurerm_network_security_group.data_interface_nsg.id
  management_interface_nsg_id  = data.azurerm_network_security_group.management_interface_nsg.id
}

############################################################################################
# LOAD FIREWALL MODULE: CREATING PAN FIREWALL VM1 & VM2
############################################################################################

module "panfw1" {
  source                  = "../modules/network/firewall"
  resource_group_name     = local.resource_group_name
  resource_group_location = local.resource_group_location

  tags = var.tags

  availability_set_id = local.firewall_availability_set_id

  pan_firewall_name = var.pan_firewall_names["fwa"]

  address_allocation_method = var.address_allocation_methods["static"]

  azure_sku = var.azure_sku

  management_subnet_id = local.management_subnet_id
  public_subnet_id     = local.public_subnet_id
  private_subnet_id    = local.private_subnet_id

  data_interface_nsg_id       = local.data_interface_nsg_id
  management_interface_nsg_id = local.management_interface_nsg_id

  management_private_ip        = var.management_private_ips["fwa"]
  public_interface_private_ip  = var.public_interface_private_ips["fwa"]
  private_interface_private_ip = var.private_interface_private_ips["fwa"]

  pa_vm_size = var.pa_vm_sizes["standard_d3v2"]

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

  availability_set_id = local.firewall_availability_set_id

  pan_firewall_name = var.pan_firewall_names["fwb"]

  address_allocation_method = var.address_allocation_methods["static"]

  azure_sku = var.azure_sku

  management_subnet_id = local.management_subnet_id
  public_subnet_id     = local.public_subnet_id
  private_subnet_id    = local.private_subnet_id

  data_interface_nsg_id       = local.data_interface_nsg_id
  management_interface_nsg_id = local.management_interface_nsg_id

  management_private_ip        = var.management_private_ips["fwb"]
  public_interface_private_ip  = var.public_interface_private_ips["fwb"]
  private_interface_private_ip = var.private_interface_private_ips["fwb"]

  pa_vm_size = var.pa_vm_sizes["standard_d3v2"]

  pan_license_type = var.pan_license_types["byol"]
  #pan_license_type = var.pan_license_types["byol"]

  pan_publisher = var.pan_publisher

  pan_product = var.pan_product
  #pan_product = "vmseries1"

  panos_version = var.panos_version

  disk_caching_option = var.disk_caching_option

  disk_create_option = var.disk_create_option

  admin_credentials = var.admin_credentials

  #Bootstrapping
  bootstrap_storage_account         = var.bootstrap_storage_account
  bootstrap_storage_access_key      = var.bootstrap_storage_access_key
  bootstrap_storage_file_share      = var.bootstrap_storage_file_share
  bootstrap_storage_share_directory = var.bootstrap_storage_share_directory_fwb
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

  private_subnet_id              = local.private_subnet_id
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
