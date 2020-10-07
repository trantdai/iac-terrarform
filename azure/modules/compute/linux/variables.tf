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
  type = string
}

variable "domain_name_label" {
  type = string
}

variable "public_address_allocation_method" {
  type = string
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

variable "interface_private_ip_address" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "publisher" {
  type    = string
  default = "Canonical"
}

variable "offer" {
  type    = string
  default = "UbuntuServer"
}

variable "sku" {
  type    = string
  default = "16.04-LTS"
}

variable "version" {
  type    = string
  default = "latest"
}
/*
variable "storage_os_disk_name" {
  type = string
}
*/
variable "os_disk_name" {
  type    = string
  default = null
}

variable "disk_caching_option" {
  type = string
}

variable "storage_account_type" {
  type    = string
  default = "Standard_LRS"
}
/*
variable "disk_create_option" {
  type = string
}

variable "managed_disk_type" {
  type = string
}
*/
variable "admin_credentials" {
  type = map
  default = {
    username = "username"
    password = "password"
  }
}

variable "disable_password_authentication" {
  type    = boolean
  default = false
}
























### Terraform version
variable "terraform_version" {
  type    = string
  default = "2.17"
}

variable "common_prefix" {
  type        = string
  default     = "iac_firewall_"
  description = "Prefix for common resources"
}

### Subscription ID
variable "subscription_id" {
  type = string
}

### Tenant ID
variable "tenant_id" {
  type = string
}

###Region
variable "location" {
  type = map
  default = {
    us_east1 = "eastus1"
    us_east2 = "eastus2"
    aus_east = "australiaeast"
  }
}

variable "azure_sku" {
  type    = string
  default = "Standard"
}

### Resource Group
variable "firewall_resource_group" {
  type    = string
  default = "iac_firewall_resource_group"
}

### Tag
variable "tags" {
  type = map
  default = {
    cr          = "99999999"
    owner       = "tpe-ics-ens-nss"
    environment = "cnb"
    application = "firewall"
    vendor      = "pan"
  }
}

### Networking
variable "all_ipv4_networks" {
  type    = string
  default = "0.0.0.0/0"
}

variable "hub_virtual_network" {
  type    = string
  default = "hub_firewall_vnet"
}

variable "subnet_private_name" {
  type    = string
  default = "private"
}

variable "subnet_public_name" {
  type    = string
  default = "public"
}

variable "subnet_managment_name" {
  type    = string
  default = "management"
}

variable "hub_vnet_ipv4_address_space" {
  type    = list(string)
  default = ["10.251.0.0/16"]
}
#Management interface (DHCP) = 10.251.1.5
#Public interface = 10.251.2.4 (a) 10.251.2.5 (b)
#Private interface = 10.251.3.4 (a) 10.251.3.5 (b)
#lb_frontend_private_ip_address = "10.251.3.21"
variable "hub_subnets" {
  type = map
  default = {
    management = ["10.251.1.0/24"]
    public     = ["10.251.2.0/24"]
    private    = ["10.251.3.0/24"]
  }
}

variable "source_address_prefix" {
  type    = string
  default = "*"
}

variable "permitted_source" {
  type    = string
  default = "1.43.54.136"
}

variable "destination_address_prefix" {
  type    = string
  default = "*"
}

variable "address_allocation_methods" {
  type = map
  default = {
    static  = "Static"
    dynamic = "Dynamic"
  }
}

### Spoke Networking
variable "spoke1_vnet_name" {
  type    = string
  default = "spoke1_vnet"
}

variable "spoke_vnet_ipv4_address_spaces" {
  type = map
  default = {
    spoke1 = ["10.252.0.0/24"]
  }
}

variable "spoke1_subnets" {
  type = map
  default = {
    subnet1 = ["10.252.0.0/26"]
    subnet2 = ["10.252.0.64/26"]
    subnet3 = ["10.252.0.128/26"]
  }
}

variable "spoke1_subnet_name_prefix" {
  type    = string
  default = "spoke1_subnet"
}

### VNET Peering
variable "hub_to_spoke_peering_name_prefix" {
  type    = string
  default = "hub_to_spoke"
}

variable "spoke1_to_hub" {
  type    = string
  default = "spoke1_to_hub"
}

### Network Security Group
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
    all      = "*"
    https    = "443"
    ssh      = "22"
    rdp      = "3389"
    port8443 = "8443"
  }
}

### Palo Alto
variable "availability_set" {
  type = string
  #default = "${var.common_prefix}availability_set"
  default = "iac_firewall_availability_set"
}

variable "panos_version" {
  type    = string
  default = "9.1.2"
}

variable "pa_vm_sizes" {
  type = map
  default = {
    standard_d3v2 = "Standard_D3_v2"
    standard_d4v2 = "Standard_D4_v2"
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

# License options: byol bundle1 bundle2
variable "pan_license_types" {
  type = map
  default = {
    byol    = "byol"
    bundle1 = "bundle1"
    bundle2 = "bundle2"
  }
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

variable "firewall_data_network_security_group" {
  type    = string
  default = "data_interface_security_group"
}

variable "firewall_management_network_security_group" {
  type    = string
  default = "mgmt_interface_security_group"
}

# Currently makes 2 FWs and adds a or b to name
variable "azure_firewall_name_prefix" {
  type    = string
  default = "azrfwp300"
}

# Not used
variable "firewall_username" {
  type    = string
  default = "panadmin"
}
# Not used
variable "firewall_password" {
  type    = string
  default = "Changeme!@#456"
}

variable "management_private_ips" {
  type = map
  default = {
    fwa = "10.251.1.5"
    fwb = "10.251.1.6"
  }
}

variable "public_interface_private_ips" {
  type = map
  default = {
    fwa = "10.251.2.5"
    fwb = "10.251.2.6"
  }
}

variable "private_interface_private_ips" {
  type = map
  default = {
    fwa = "10.251.3.5"
    fwb = "10.251.3.6"
  }
}

variable "firewall_management_gateway" {
  type    = string
  default = "10.251.1.1"
}

###Load Balancer
variable "public_load_balancer_domain_name" {
  type    = string
  default = "iac-public"
}
variable "load_balancer_names" {
  type = map
  default = {
    private = "azr_private_load_balancer"
    public  = "azr_public_load_balancer"
  }
}

variable "load_balancer_public_ip_name" {
  type    = string
  default = "load_balancer_public_ip"
}

variable load_balancer_frontend_ip_names {
  type = map
  default = {
    private = "lb_private_front_end_ip"
    public  = "lb_public_front_end_ip"
  }
}

variable lb_frontend_private_ip_address {
  type    = string
  default = ""
}

variable lb_probe_names {
  type = map
  default = {
    private = "private_firewall_probe"
    public  = "public_firewall_probe"
  }
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

variable lb_ports {
  type = map
  default = {
    all      = 0
    port22   = 22
    port443  = 443
    port8443 = 8443
    port3389 = 3389
  }
}

variable lb_probe_interval {
  type    = number
  default = 10
}

variable lb_probe_unhealthy_threshold {
  type    = number
  default = 3
}

variable lb_pool_names {
  type = map
  default = {
    private = "private_firewall_pool"
    public  = "public_firewall_pool"
  }
}

variable lb_rule_names {
  type = map
  default = {
    private_all      = "all_ports_to_all"
    tcp_443_to_8443  = "tcp_443_to_8443"
    tcp_22_to_22     = "tcp_22_to_22"
    tcp_443_to_443   = "tcp_443_to_443"
    tcp_3389_to_3389 = "tcp_3389_to_3389"
  }

}

variable load_distribution_options {
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

### VM settings
# Windows VM in subnet2
variable subnet2_windows_vm_ip {
  type    = string
  default = "10.252.0.68"
}

# Linux VM in subnet3
variable subnet3_linux_vm_ip {
  type    = string
  default = "10.252.0.132"
}


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

variable public_to_peerednet_route_name {
  type    = string
  default = "blackhole_peerednet"
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

### Route tables and user defined routes in spokes
# Spoke 1 & subnet1
variable spoke1_subnet1_route_table {
  type        = string
  description = "Route table name for subnet1 in spoke1"
  default     = "spoke1_subnet1_route_table"
}

variable spoke1_subnet1_default_route_name {
  type    = string
  default = "spoke1_subnet1_default"
}

variable spoke1_subnet1_to_firewall_public_route_name {
  type    = string
  default = "spoke1_subnet1_to_firewall_public"
}
# Spoke 1 & subnet2
variable spoke1_subnet2_route_table {
  type        = string
  description = "Route table name for subnet2 in spoke1"
  default     = "spoke1_subnet2_route_table"
}

variable spoke1_subnet2_default_route_name {
  type    = string
  default = "spoke1_subnet2_default"
}

variable spoke1_subnet2_to_firewall_public_route_name {
  type    = string
  default = "spoke1_subnet2_to_firewall_public"
}

variable spoke1_subnet2_to_subnet3_route_name {
  type    = string
  default = "spoke1_subnet2_to_subnet3"
}

variable spoke1_subnet2_to_firewall_management_route_name {
  type    = string
  default = "spoke1_subnet2_to_firewall_management"
}

# Spoke 1 & subnet3
variable spoke1_subnet3_route_table {
  type        = string
  description = "Route table name for subnet3 in spoke1"
  default     = "spoke1_subnet3_route_table"
}

variable spoke1_subnet3_default_route_name {
  type    = string
  default = "spoke1_subnet3_default"
}

variable spoke1_subnet3_to_firewall_public_route_name {
  type    = string
  default = "spoke1_subnet3_to_firewall_public"
}

variable spoke1_subnet3_to_subnet2_route_name {
  type    = string
  default = "spoke1_subnet3_to_subnet2"
}

variable spoke1_intra_subnet3_route_name {
  type    = string
  default = "poke1_intra_subnet3"
}

variable spoke1_subnet3_to_firewall_management_route_name {
  type    = string
  default = "spoke1_subnet3_to_firewall_management"
}

# VMs setting
variable vm_sizes {
  type = map
  default = {
    standardf2 = "Standard_F2"
  }
}

variable storage_disk_types {
  type = map
  default = {
    standardlrs = "Standard_LRS"
  }
}

variable admin_credentials {
  type = map
  default = {
    username = "iacadmin"
    password = "I@C123$%^"
  }
}

variable idle_timeout_in_minutes {
  type    = number
  default = 120
}
