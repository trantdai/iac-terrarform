output "management_interface_id" {
  value = azurerm_network_interface.firewall_management_eth10.id
}

output "public_interface_id" {
  value = azurerm_network_interface.firewall_public_eth11.id
}

output "private_interface_id" {
  value = azurerm_network_interface.firewall_private_eth12.id
}

output "management_interface_public_domain_name" {
  value = var.create_public_ip ? azurerm_public_ip.firewall_management_public_ip1.*.fqdn : null
  #value = azurerm_public_ip.firewall_management_public_ip1.*.fqdn
}

output "management_interface_public_ip" {
  value = var.create_public_ip ? azurerm_public_ip.firewall_management_public_ip1.*.ip_address : null
  #value = azurerm_public_ip.firewall_management_public_ip1.*.ip_address
}

output "management_interface_ip" {
  value = var.management_private_ip
}

output "public_interface_ip" {
  value = var.public_interface_private_ip
}

output "private_interface_ip" {
  value = var.private_interface_private_ip
}

