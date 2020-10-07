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
# DEFINE PUBLIC LOAD BALANCER IN FIREWALL HUB VNET
############################################################################################

resource "azurerm_public_ip" "load_balancer_public_ip" {
  name                = var.load_balancer_public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = var.address_allocation_methods["static"]
  domain_name_label   = var.public_load_balancer_domain_name
  sku                 = var.azure_sku
  tags                = var.tags
}

resource "azurerm_lb" "firewall_public_load_balancer" {
  name                = var.load_balancer_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = var.azure_sku

  frontend_ip_configuration {
    name                 = var.load_balancer_frontend_ip_config_name
    public_ip_address_id = azurerm_public_ip.load_balancer_public_ip.id
  }
  tags = var.tags
}

resource "azurerm_lb_probe" "firewall_public_probe" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.firewall_public_load_balancer.id
  name                = var.lb_probe_name
  protocol            = var.load_balancer_protocols["tcp"]
  port                = var.lb_ports["port443"]
  interval_in_seconds = var.lb_probe_interval
  number_of_probes    = var.lb_probe_unhealthy_threshold
}

resource "azurerm_lb_backend_address_pool" "firewall_public_pool" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.firewall_public_load_balancer.id
  name                = var.lb_probe_name
}

resource "azurerm_lb_rule" "tcp_22_to_22" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.firewall_public_load_balancer.id
  name                           = var.lb_rule_names["tcp_22_to_22"]
  protocol                       = var.load_balancer_protocols["tcp"]
  frontend_port                  = var.lb_ports["port22"]
  backend_port                   = var.lb_ports["port22"]
  frontend_ip_configuration_name = var.load_balancer_frontend_ip_config_name
  probe_id                       = azurerm_lb_probe.firewall_public_probe.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.firewall_public_pool.id
  load_distribution              = var.load_distribution_option
  enable_floating_ip             = true
  depends_on = [azurerm_lb.firewall_public_load_balancer,
  azurerm_lb_backend_address_pool.firewall_public_pool, azurerm_lb_probe.firewall_public_probe]
}

resource "azurerm_lb_rule" "tcp_443_to_443" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.firewall_public_load_balancer.id
  name                           = var.lb_rule_names["tcp_443_to_443"]
  protocol                       = var.load_balancer_protocols["tcp"]
  frontend_port                  = var.lb_ports["port443"]
  backend_port                   = var.lb_ports["port443"]
  frontend_ip_configuration_name = var.load_balancer_frontend_ip_config_name
  probe_id                       = azurerm_lb_probe.firewall_public_probe.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.firewall_public_pool.id
  load_distribution              = var.load_distribution_option
  enable_floating_ip             = true
  depends_on = [azurerm_lb.firewall_public_load_balancer,
  azurerm_lb_backend_address_pool.firewall_public_pool, azurerm_lb_probe.firewall_public_probe]
}

resource "azurerm_lb_rule" "tcp_3389_to_3389" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.firewall_public_load_balancer.id
  name                           = var.lb_rule_names["tcp_3389_to_3389"]
  protocol                       = var.load_balancer_protocols["tcp"]
  frontend_port                  = var.lb_ports["port3389"]
  backend_port                   = var.lb_ports["port3389"]
  frontend_ip_configuration_name = var.load_balancer_frontend_ip_config_name
  probe_id                       = azurerm_lb_probe.firewall_public_probe.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.firewall_public_pool.id
  load_distribution              = var.load_distribution_option
  enable_floating_ip             = true
  depends_on = [azurerm_lb.firewall_public_load_balancer,
  azurerm_lb_backend_address_pool.firewall_public_pool, azurerm_lb_probe.firewall_public_probe]
}

resource "azurerm_network_interface_backend_address_pool_association" "firewall1_public_pool_association" {
  network_interface_id    = var.firewall1_public_interface_id
  ip_configuration_name   = "${var.pan_firewall_names["fwa"]}_public"
  backend_address_pool_id = azurerm_lb_backend_address_pool.firewall_public_pool.id
  depends_on              = [azurerm_lb_backend_address_pool.firewall_public_pool]
}

resource "azurerm_network_interface_backend_address_pool_association" "firewall2_public_pool_association" {
  network_interface_id    = var.firewall2_public_interface_id
  ip_configuration_name   = "${var.pan_firewall_names["fwb"]}_public"
  backend_address_pool_id = azurerm_lb_backend_address_pool.firewall_public_pool.id
  depends_on              = [azurerm_lb_backend_address_pool.firewall_public_pool]
}
