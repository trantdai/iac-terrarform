############################################################################################
# PROVIDER VARIABLES
############################################################################################

# Subscription ID
variable "subscription_id" {
  type = string
}

# Tenant ID
variable "tenant_id" {
  type = string
}

############################################################################################
# COMMON VARIABLES
############################################################################################

variable "resource_group_name" {
  type    = string
  default = "iac_firewall_resource_group"
}

variable "resource_group_location" {
  type = string
}

# Tag
variable "tags" {
  type = map
  default = {
    owner       = "daitran"
    environment = "cnb"
    application = "firewall"
  }
}

# Availability set
variable "availability_set_name" {
  type    = string
  default = "iac_firewall_availability_set"
}

variable "azure_sku" {
  type    = string
  default = "Standard"
}

variable "address_allocation_methods" {
  type = map
  default = {
    static  = "Static"
    dynamic = "Dynamic"
  }
}

variable "pan_firewall_names" {
  type = map
  default = {
    fwa = "azrfwa"
    fwb = "azrfwb"
  }
}

############################################################################################
# HUB VARIABLES
############################################################################################

variable "hub_virtual_network_name" {
  type    = string
  default = "hub_firewall_vnet"
}

variable "management_subnet_name" {
  type    = string
  default = "management_subnet"
}

variable "public_subnet_name" {
  type    = string
  default = "public_subnet"
}

variable "private_subnet_name" {
  type    = string
  default = "private_subnet"
}

variable "data_interface_nsg_name" {
  type    = string
  default = "data_interface_nsg"
}

variable "management_interface_nsg_name" {
  type    = string
  default = "management_interface_nsg"
}

############################################################################################
# FIREWALL VARIABLES
############################################################################################

variable "create_public_ip" {
  type        = bool
  description = "Variable to control the creation of management public IP for firewall"
  default     = true
}

variable "management_private_ips" {
  type = map
  default = {
    fwa = "10.10.10.5"
    fwb = "10.10.10.6"
  }
}

variable "public_interface_private_ips" {
  type = map
  default = {
    fwa = "10.10.11.5"
    fwb = "10.10.11.6"
  }
}

variable "private_interface_private_ips" {
  type = map
  default = {
    fwa = "10.10.12.5"
    fwb = "10.10.12.6"
  }
}

variable "pa_vm_sizes" {
  type = map
  default = {
    standard_d3v2 = "Standard_D3_v2"
    standard_d4v2 = "Standard_D4_v2"
  }
}

# License options: byol bundle1 bundle2
variable "pan_license_types" {
  type = map
  default = {
    byol    = "byol"
    bundle1 = "bundle1"
    bundle2 = "bundle2"
  }
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
variable "disk_caching_option" {
  type    = string
  default = "ReadWrite"
}

variable "disk_create_option" {
  type    = string
  default = "FromImage"
}

variable "admin_credentials" {
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

variable bootstrap_storage_share_directory_fwa {
  type = string
}

variable bootstrap_storage_share_directory_fwb {
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

############################################################################################
# COMMON LOAD BALANCER VARIABLES
############################################################################################

variable "load_balancer_protocols" {
  type = map
  default = {
    all   = "All"
    tcp   = "TCP"
    http  = "HTTP"
    https = "HTTPS"
  }
}

variable "lb_ports" {
  type = map
  default = {
    all      = 0
    port22   = 22
    port443  = 443
    port8443 = 8443
    port3389 = 3389
  }
}

variable "lb_probe_interval" {
  type    = number
  default = 10
}

variable "lb_probe_unhealthy_threshold" {
  type    = number
  default = 3
}

variable "lb_rule_names" {
  type = map
  default = {
    private_all      = "all_ports_to_all"
    tcp_443_to_8443  = "tcp_443_to_8443"
    tcp_22_to_22     = "tcp_22_to_22"
    tcp_443_to_443   = "tcp_443_to_443"
    tcp_3389_to_3389 = "tcp_3389_to_3389"
  }
}

variable "load_distribution_options" {
  type = map
  default = {
    default            = "Default"
    "sourceip"         = "SourceIP"
    "sourceipprotocol" = "SourceIPProtocol"
    "none"             = "Default"
    "clientip"         = "SourceIP"
    "clientipprotocol" = "SourceIPProtocol"
  }
}

############################################################################################
# INTERNAL LOAD BALANCER VARIABLES
############################################################################################

variable "lb_frontend_private_ip_address" {
  type    = string
  default = ""
}

variable "private_load_balancer_name" {
  type    = string
  default = "azr_private_load_balancer"
}

variable "private_load_balancer_frontend_ip_config_name" {
  type    = string
  default = "lb_private_front_end_ip"
}

variable "private_lb_probe_name" {
  type    = string
  default = "private_firewall_probe"
}

variable "private_lb_pool_name" {
  type    = string
  default = "private_firewall_pool"
}

############################################################################################
# PUBLIC LOAD BALANCER VARIABLES
############################################################################################

variable "public_load_balancer_name" {
  type    = string
  default = "azr_public_load_balancer"
}

variable "load_balancer_public_ip_name" {
  type    = string
  default = "load_balancer_public_ip"
}

variable "public_load_balancer_domain_name" {
  type    = string
  default = "iac-public"
}

variable "public_load_balancer_frontend_ip_config_name" {
  type    = string
  default = "lb_public_front_end_ip_config"
}

variable "public_lb_probe_name" {
  type    = string
  default = "public_firewall_probe"
}

variable "public_lb_pool_name" {
  type    = string
  default = "public_firewall_pool"
}
