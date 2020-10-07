############################################################################################
# PROVIDER VARIABLES
############################################################################################

### Subscription ID
variable "subscription_id" {
  type = string
}

### Tenant ID
variable "tenant_id" {
  type = string
}

############################################################################################
# COMMON VARIABLES
############################################################################################

variable "create_resource_group" {
  type        = bool
  description = "Variable to control the resource group creation"
  default     = false
}

### Resource Group
variable "resource_group_name" {
  type    = string
  default = "iac_firewall_resource_group"
}

#location = eastus1, australiaeast
variable "resource_group_location" {
  type    = string
  default = "westeurope"
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

variable "hub_virtual_network" {
  type    = string
  default = "hub_firewall_vnet"
}

variable "hub_vnet_ipv4_address_space" {
  type    = list(string)
  default = ["10.251.0.0/16"]
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

############################################################################################
# ROUTE TABLE AND USER DEFINED ROUTE VARIABLES IN HUB
############################################################################################

variable "rfc1918_networks" {
  type = map
  default = {
    classa = "10.0.0.0/8"
    classb = "172.16.0.0/12"
    classc = "192.168.0.0/16"
  }
}

variable "all_ipv4_networks" {
  type    = string
  default = "0.0.0.0/0"
}

### Route tables and user defined routes in hub
variable "next_hop_types" {
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
variable "firewall_management_route_table" {
  type        = string
  description = "Route table name for firewall management subnet"
  default     = "firewall_mgmt_subnet_route_table"
}

variable "management_to_public_route_name" {
  type    = string
  default = "blackhole_public"
}

# Public
variable "firewall_public_route_table" {
  type        = string
  description = "Route table name for firewall public subnet"
  default     = "firewall_public_subnet_route_table"
}

variable "public_to_management_route_name" {
  type    = string
  default = "blackhole_management"
}

variable "public_to_private_route_name" {
  type    = string
  default = "blackhole_private"
}

#Private
variable "firewall_private_route_table" {
  type        = string
  description = "Route table name for firewall private subnet"
  default     = "firewall_private_subnet_route_table"
}

variable "private_to_management_route_name" {
  type    = string
  default = "blackhole_management"
}

variable "private_to_public_route_name" {
  type    = string
  default = "blackhole_public"
}

variable "private_to_jump_subnet_route_name" {
  type    = string
  default = "private_to_jump_subnet"
}

variable "private_to_hub_vnet_route_name" {
  type    = string
  default = "private_to_hub_vnet"
}

variable "private_default_route_name" {
  type    = string
  default = "udr_default"
}

#Jump
variable "hub_jump_subnet_route_table" {
  type        = string
  description = "Route table name for hub jump subnet"
  default     = "hub_jump_subnet_route_table"
}

variable "jump_to_hub_vnet_route_name" {
  type    = string
  default = "hub_vnet_via_lb"
}

variable "jump_to_rfc1918_classa_route_name" {
  type    = string
  default = "rfc1918_classa_via_lb"
}

variable "jump_to_rfc1918_classb_route_name" {
  type    = string
  default = "rfc1918_classb_via_lb"
}

variable "jump_to_rfc1918_classc_route_name" {
  type    = string
  default = "rfc1918_classc_via_lb"
}

############################################################################################
# FIREWALL VARIABLES
############################################################################################

### Palo Alto
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

############################################################################################
# COMMON VM VARIABLES
############################################################################################

variable "vm_sizes" {
  type = map
  default = {
    standardf2 = "Standard_F2"
  }
}

variable "disk_caching_option" {
  type    = string
  default = "ReadWrite"
}

variable "storage_account_types" {
  type = map
  default = {
    standardlrs = "Standard_LRS"
  }
}

############################################################################################
# WINDOWS JUMP SERVER VARIABLES
############################################################################################
/*
variable "create_public_ip" {
  type        = bool
  description = "Variable to control the creation of public IP for VM"
  default     = true
}
*/
variable "windows_jumpserver_public_ip_name" {
  type    = string
  default = "windows_jumpserver_public_ip"
}

variable "windows_jumpserver_domain_name_label" {
  type    = string
  default = "iac-wins-jumpserver"
}

variable "windows_jumpserver_network_interface_name" {
  type    = string
  default = "windows_jumserver_nic"
}

variable "windows_jumpserver_ip_config_name" {
  type    = string
  default = "windows_jumserver_ipconfig"
}

variable "windows_jumpserver_vm_name" {
  type    = string
  default = "win-jumpserver"
}

variable "windows_publisher" {
  type    = string
  default = "MicrosoftWindowsServer"
}

variable "windows_offer" {
  type    = string
  default = "WindowsServer"
}

variable "windows_sku" {
  type    = string
  default = "2016-Datacenter"
}

variable "windows_version" {
  type    = string
  default = "latest"
}

############################################################################################
# WINDOWS VM VARIABLES
############################################################################################

variable "windows_vm_network_interface_name" {
  type    = string
  default = "windows_vm_nic"
}

variable "windows_vm_ip_config_name" {
  type    = string
  default = "windows_vm_ipconfig"
}

variable "windows_vm_name" {
  type    = string
  default = "winvm1"
}

