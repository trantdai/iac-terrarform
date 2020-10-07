variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "create_public_ip" {
  type        = bool
  description = "Variable to control the creation of public IP for VM"
  default     = false
}

variable "public_ip_name" {
  type    = string
  default = null
}

variable "domain_name_label" {
  type    = string
  default = null
}

variable "public_address_allocation_method" {
  type    = string
  default = null
}

variable "tags" {
  type = map
}

variable "network_interface_name" {
  type = string
}

variable "ip_config_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "interface_address_allocation_method" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "admin_credentials" {
  type = map
  default = {
    username = "username"
    password = "password"
  }
}

variable "disk_caching_option" {
  type = string
}

variable "os_disk_name" {
  type    = string
  default = null
}

variable "storage_account_type" {
  type = string
}

variable "publisher" {
  type = string
}

variable "offer" {
  type = string
}

variable "sku" {
  type = string
}

variable "windows_version" {
  type = string
}
