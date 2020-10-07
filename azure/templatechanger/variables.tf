variable "hostname" {
  description = "The DNS name or IP address of the Panorama"
  type        = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "apikey" {
  type = string
}

variable "template" {
  description = "The name of the Panorama template"
  type        = string
  default     = "tpl_azure_common"
}

variable "stack" {
  description = "The name of the Panorama template stack"
  type        = string
  default     = "stk_azure_cluster1"
}

variable "template_public_interface" {
  description = "Public interface of firewall"
  type = object({
    name                      = string
    vsys                      = string
    mode                      = string
    static_ips                = list(string)
    enable_dhcp               = bool
    create_dhcp_default_route = bool
    comment                   = string
  })
  default = {
    name                      = "ethernet1/1"
    vsys                      = "vsys1"
    mode                      = "layer3"
    static_ips                = ["10.10.11.5/24"]
    enable_dhcp               = false
    create_dhcp_default_route = false
    comment                   = "Public interface"
  }
}

variable "template_private_interface" {
  description = "Private interface of firewall"
  type = object({
    name                      = string
    vsys                      = string
    mode                      = string
    static_ips                = list(string)
    enable_dhcp               = bool
    create_dhcp_default_route = bool
    comment                   = string
  })
  default = {
    name                      = "ethernet1/2"
    vsys                      = "vsys1"
    mode                      = "layer3"
    static_ips                = ["10.10.`2.5/24"]
    enable_dhcp               = false
    create_dhcp_default_route = false
    comment                   = "Private interface"
  }
}

variable "virtual_router1_name" {
  type    = string
  default = "default"
}

variable "default_gateway_object" {
  description = "Default gateway address object for firewall public subnet"
  type = object({
    name         = string
    device_group = string
    value        = string
    description  = string
    tags         = list(string)
  })
  default = {
    name         = "public.net.gateway"
    device_group = "shared"
    value        = "10.10.11.1/32"
    description  = "Default gateway for firewall public subnet"
    tags         = ["gateway"]
  }
}

variable "default_route_name" {
  type    = string
  default = "default_route"
}

variable "route_to_private" {
  type    = string
  default = "to_private"
}

variable "zone_mode" {
  type    = string
  default = "layer3"
}

variable "public_zone_name" {
  type    = string
  default = "public"
}

variable "private_zone_name" {
  type    = string
  default = "private"
}
