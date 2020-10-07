output "private_frontend_ip" {
  value = azurerm_lb.firewall_private_load_balancer.private_ip_address
}

