variable "resource_group_name" {
  type    = string
  default = "iac_firewall_resource_group"
}

variable "resource_group_location" {
  type = string
}

variable "tags" {
  type = map
  default = {
    owner       = "daitran"
    environment = "cnb"
    application = "firewall"
  }
}

variable "hub_virtual_network" {
  type    = string
  default = "hub_firewall_vnet"
}

variable "hub_vnet_ipv4_address_space" {
  type    = list(string)
  default = ["10.10.0.0/16"]
}

variable "private_subnet_name" {
  type    = string
  default = "private_subnet"
}

variable "public_subnet_name" {
  type    = string
  default = "public_subnet"
}

variable "managment_subnet_name" {
  type    = string
  default = "management_subnet"
}

variable "jump_subnet_name" {
  type    = string
  default = "jump_subnet"
}

variable "hub_subnets" {
  type = map
  default = {
    management = ["10.10.10.0/24"]
    public     = ["10.10.11.0/24"]
    private    = ["10.10.12.0/24"]
    jump       = ["10.10.254.0/24"]
  }
}

# Availability set
variable "availability_set_name" {
  type    = string
  default = "iac_firewall_availability_set"
}

### Network security groups
variable "data_interface_nsg_name" {
  type        = string
  description = "Network security group name for firewall data interfaces"
  default     = "data_interface_nsg"
}

variable "management_interface_nsg_name" {
  type        = string
  description = "Network security group name for firewall management interfaces"
  default     = "management_interface_nsg"
}

variable "security_group_rule_names" {
  type = map
  default = {
    allowall   = "AllowAll"
    allowssh   = "AllowSsh"
    allowhttps = "AllowHttps"
    denyall    = "DenyAll"
  }
}

variable "security_rule_priorities" {
  type = map
  default = {
    prio100 = 100
    prio200 = 200
  }
}

variable "flow_directions" {
  type = map
  default = {
    inbound = "Inbound"
    outbout = "Outbound"
  }
}

variable "security_rule_actions" {
  type = map
  default = {
    allow = "Allow"
    deny  = "Deny"
  }
}
#azure_protocol = security_rule_protocol
variable "security_rule_protocols" {
  type = map
  default = {
    all = "*"
    tcp = "Tcp"
    udp = "Udp"
  }
}
#ports = security_rule_ports
variable "security_rule_ports" {
  type = map
  default = {
    all       = "*"
    https     = "443"
    ssh       = "22"
    rdp       = "3389"
    tcp_3978  = "3978"
    port8443  = "8443"
    tcp_28443 = "28443"
  }
}

variable "source_address_prefix" {
  type    = string
  default = "*"
}

variable "permitted_source" {
  type = string
}

variable "destination_address_prefix" {
  type    = string
  default = "*"
}
/*
### Route tables and user defined routes in hub
variable next_hop_types {
  type = map
  default = {
    virtualnetworkgateway = "VirtualNetworkGateway"
    vnetlocal             = "VnetLocal"
    ineternet             = "Internet"
    virtualappliance      = "VirtualAppliance"
    none                  = "None"
  }
}

# Management
variable firewall_management_route_table {
  type        = string
  description = "Route table name for firewall management subnet"
  default     = "firewall_mgmt_subnet_route_table"
}

variable management_to_public_route_name {
  type    = string
  default = "blackhole_public"
}
/*
variable management_to_private_route_name {
  type    = string
  default = "blackhole_private"
}
*/
/*
# Public
variable firewall_public_route_table {
  type        = string
  description = "Route table name for firewall public subnet"
  default     = "firewall_public_subnet_route_table"
}

variable public_to_management_route_name {
  type    = string
  default = "blackhole_management"
}

variable public_to_private_route_name {
  type    = string
  default = "blackhole_private"
}

#Private
variable firewall_private_route_table {
  type        = string
  description = "Route table name for firewall private subnet"
  default     = "firewall_private_subnet_route_table"
}

variable private_to_management_route_name {
  type    = string
  default = "blackhole_management"
}

variable private_to_public_route_name {
  type    = string
  default = "blackhole_public"
}

variable private_default_route_name {
  type    = string
  default = "udr_default"
}
*/
