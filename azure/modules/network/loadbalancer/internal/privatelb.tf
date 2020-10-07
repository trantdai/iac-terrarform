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
# DEFINE INTERNAL LOAD BALANCER IN FIREWALL HUB VNET
############################################################################################

resource "azurerm_lb" "firewall_private_load_balancer" {
  name                = var.load_balancer_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = var.azure_sku

  frontend_ip_configuration {
    name                          = var.load_balancer_frontend_ip_config_name
    subnet_id                     = var.private_subnet_id
    private_ip_address            = var.lb_frontend_private_ip_address
    private_ip_address_allocation = var.address_allocation_methods["static"]
  }
  tags = var.tags
}

resource "azurerm_lb_probe" "firewall_private_probe" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.firewall_private_load_balancer.id
  name                = var.lb_probe_name
  protocol            = var.load_balancer_protocols["tcp"]
  port                = var.lb_ports["port443"]
  interval_in_seconds = var.lb_probe_interval
  number_of_probes    = var.lb_probe_unhealthy_threshold
}

resource "azurerm_lb_backend_address_pool" "firewall_private_pool" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.firewall_private_load_balancer.id
  name                = var.lb_pool_name
}

resource "azurerm_lb_rule" "private_all_ports" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.firewall_private_load_balancer.id
  name                           = var.lb_rule_names["private_all"]
  protocol                       = var.load_balancer_protocols["all"]
  frontend_port                  = var.lb_ports["all"]
  backend_port                   = var.lb_ports["all"]
  frontend_ip_configuration_name = var.load_balancer_frontend_ip_config_name
  probe_id                       = azurerm_lb_probe.firewall_private_probe.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.firewall_private_pool.id
  load_distribution              = var.load_distribution_option
  depends_on = [azurerm_lb.firewall_private_load_balancer,
  azurerm_lb_backend_address_pool.firewall_private_pool, azurerm_lb_probe.firewall_private_probe]

}

resource "azurerm_network_interface_backend_address_pool_association" "firewall1_private_pool_association" {
  network_interface_id    = var.firewall1_private_interface_id
  ip_configuration_name   = "${var.pan_firewall_names["fwa"]}_private"
  backend_address_pool_id = azurerm_lb_backend_address_pool.firewall_private_pool.id
  depends_on              = [azurerm_lb_backend_address_pool.firewall_private_pool]
}

resource "azurerm_network_interface_backend_address_pool_association" "firewall2_private_pool_association" {
  network_interface_id    = var.firewall2_private_interface_id
  ip_configuration_name   = "${var.pan_firewall_names["fwb"]}_private"
  backend_address_pool_id = azurerm_lb_backend_address_pool.firewall_private_pool.id
  depends_on              = [azurerm_lb_backend_address_pool.firewall_private_pool]
}
