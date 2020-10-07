//WORK IN PROGRESS
/*
############################################################################################
# FIREWALL 1 OUTPUT
############################################################################################

output "fwa_management_interface_public_domain_name" {
  value = module.panfw1.management_interface_public_domain_name
}

output "fwa_management_interface_public_ip" {
  value = module.panfw1.management_interface_public_ip
}

output "fwa_management_interface_ip" {
  value = module.panfw1.management_interface_ip
}

output "fwa_public_interface_ip" {
  value = module.panfw1.public_interface_ip
}

output "fwa_private_interface_ip" {
  value = module.panfw1.private_interface_ip
}

############################################################################################
# FIREWALL 2 OUTPUT
############################################################################################

output "fwb_management_interface_public_domain_name" {
  value = module.panfw2.management_interface_public_domain_name
}

output "fwb_management_interface_public_ip" {
  value = module.panfw2.management_interface_public_ip
}

output "fwb_management_interface_ip" {
  value = module.panfw2.management_interface_ip
}

output "fwb_public_interface_ip" {
  value = module.panfw2.public_interface_ip
}

output "fwb_private_interface_ip" {
  value = module.panfw2.private_interface_ip
}

############################################################################################
# INTERNAL LOAD BALANCER OUTPUT
############################################################################################

output "private_frontend_ip" {
  value = module.privatelb.private_frontend_ip
}

############################################################################################
# PUBLIC LOAD BALANCER OUTPUT
############################################################################################

output "load_balancer_public_domain_name" {
  value = module.publiclb.load_balancer_public_domain_name
}

output "load_balancer_frontend_public_ip" {
  value = module.publiclb.load_balancer_frontend_public_ip
}
/*
Test
output "management_interface_public_domain_name" {
  value = var.create_public_ip ? azurerm_public_ip.firewall_management_public_ip1.*.fqdn : null
}
*/
