output "load_balancer_public_domain_name" {
  value = azurerm_public_ip.load_balancer_public_ip.fqdn
}

output "load_balancer_frontend_public_ip" {
  value = azurerm_public_ip.load_balancer_public_ip.ip_address
}
