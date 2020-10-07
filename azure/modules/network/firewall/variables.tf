### Resource Group
variable "resource_group_name" {
  type    = string
  default = "iac_firewall_resource_group"
}

variable "resource_group_location" {
  type = string
}

### Tag
variable "tags" {
  type = map
  default = {
    owner       = "daitran"
    environment = "cnb"
    application = "firewall"
  }
}

### Palo Alto
variable "create_public_ip" {
  type        = bool
  description = "Variable to control the creation of management public IP for firewall"
  default     = true
}

variable "pan_firewall_name" {
  type = string
}

variable "address_allocation_method" {
  type    = string
  default = "Static"
}

variable "management_private_ip" {
  type = string
}

variable "public_interface_private_ip" {
  type = string
}

variable "private_interface_private_ip" {
  type = string
}

variable "azure_sku" {
  type    = string
  default = "Standard"
}

variable "management_subnet_id" {
}

variable "public_subnet_id" {
}

variable "private_subnet_id" {
}

variable "data_interface_nsg_id" {
}

variable "management_interface_nsg_id" {
}

variable "pa_vm_size" {
  type    = string
  default = "Standard_D3_v2"
}

variable "availability_set_id" {
}


# License options: byol bundle1 bundle2
variable "pan_license_type" {
  type    = string
  default = "bundle2"
}

variable "pan_publisher" {
  type    = string
  default = "paloaltonetworks"
}

variable "pan_product" {
  type    = string
  default = "vmseries-flex"
}

variable "panos_version" {
  type    = string
  default = "9.0.1"
}

# VM OS disk
variable disk_caching_option {
  type    = string
  default = "ReadWrite"
}

variable disk_create_option {
  type    = string
  default = "FromImage"
}

variable admin_credentials {
  type = map
  default = {
    username = "username"
    password = "password"
  }
}

variable bootstrap_storage_account {
  type = string
}

variable bootstrap_storage_access_key {
  type = string
}

variable bootstrap_storage_file_share {
  type = string
}

variable bootstrap_storage_share_directory {
  type = string
}

variable "data_interface_security_group_name" {
  type    = string
  default = "data_interface_security_group"
}

variable "management_interface_security_group_name" {
  type    = string
  default = "management_interface_security_group"
}
