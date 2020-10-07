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

variable "address_allocation_methods" {
  type = map
  default = {
    static  = "Static"
    dynamic = "Dynamic"
  }
}

variable "azure_sku" {
  type    = string
  default = "Standard"
}

variable "private_subnet_id" {
}
/*
variable "pan_firewall1_name" {
  type = string
}

variable "pan_firewall2_name" {
  type = string
}
*/
variable "pan_firewall_names" {
  type = map
  default = {
    fwa = "azrfwa"
    fwb = "azrfwb"
  }
}
variable "lb_frontend_private_ip_address" {
  type    = string
  default = ""
}

variable "load_balancer_name" {
  type    = string
  default = "azr_private_load_balancer"
}

variable "load_balancer_frontend_ip_config_name" {
  type    = string
  default = "lb_private_frontend_ip_config"
}

variable "lb_probe_name" {
  type    = string
  default = "private_firewall_probe"
}

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

variable "lb_pool_name" {
  type    = string
  default = "private_firewall_pool"
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

variable "load_distribution_option" {
  type    = string
  default = "SourceIPProtocol"
}

variable "firewall1_private_interface_id" {
  type    = string
  default = ""
}

variable "firewall2_private_interface_id" {
  type    = string
  default = ""
}
