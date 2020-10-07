output "management_subnet_id" {
  value = azurerm_subnet.management_subnet.id
}

output "public_subnet_id" {
  value = azurerm_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = azurerm_subnet.private_subnet.id
}

output "jump_subnet_id" {
  value = azurerm_subnet.jump_subnet.id
}

output "firewall_availability_set_id" {
  value = azurerm_availability_set.firewall_availability_set.id
}

output "management_interface_nsg_id" {
  value = azurerm_network_security_group.management_interface_nsg.id
}

output "data_interface_nsg_id" {
  value = azurerm_network_security_group.data_interface_nsg.id
}
