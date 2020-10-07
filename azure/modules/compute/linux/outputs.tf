/*
The output like public_ip_address is shown when running terraform apply
or terraform output public_ip_address

output "public_ip_address" {
  #value = data.azurerm_public_ip.ip.ip_address
  description = "The Core VNET id"
}
*/
/*
output "windows_public_ip" {
  value = data.azurerm_public_ip.windows_public_ip.ip_address
}

output "linux_public_ip" {
  value = data.azurerm_public_ip.linux_public_ip.ip_address
}
*/