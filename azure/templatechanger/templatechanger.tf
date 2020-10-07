//WORK IN PROGRESS
/*
############################################################################################
# TEMPLATE AND TEMPLATE STACK ARE CONFIGURED MANUALLY VIA PANORAMA GUI BEFORE BOOTSTRAPING
############################################################################################

############################################################################################
# CONFIGURE PANOS PROVIDER AND NULL PROVIDER
############################################################################################

# Configure the panos provider
provider "panos" {
  version  = "~> 1.6"
  hostname = var.hostname
  username = var.username
  password = var.password
  api_key  = var.apikey
}

# Configure the null provider
provider "null" {
  version = "~> 2.1"
}

############################################################################################
# ADD ETHERNET INTERFACES
############################################################################################

resource "panos_panorama_ethernet_interface" "public" {
  name       = var.template_public_interface.name
  comment    = var.template_public_interface.comment
  vsys       = var.template_public_interface.vsys
  mode       = var.template_public_interface.mode
  static_ips = var.template_public_interface.static_ips
  template   = var.template_public_interface.template
  #enable_dhcp               = true
  #create_dhcp_default_route = true
}

resource "panos_panorama_ethernet_interface" "private" {
  name     = var.template_private_interface.name
  comment  = var.template_private_interface.comment
  vsys     = var.template_private_interface.vsys
  mode     = var.template_private_interface.mode
  template = panos_panorama_template.common_template.name
  #enable_dhcp = true
}

############################################################################################
# ADD VIRTUAL ROUTERS AND ROUTES
############################################################################################

// Virtual router
resource "panos_panorama_virtual_router" "default" {
  name = var.virtual_router1_name
  interfaces = [
    panos_panorama_ethernet_interface.template_public_interface.name,
    panos_panorama_ethernet_interface.template_private_interface.name
  ]
  template = panos_panorama_template.common_template.name
}

//Define default gateway address object
resource "panos_panorama_address_object" "default_gateway" {
  name        = var.default_gateway_object.name
  value       = var.default_gateway_object.value
  description = var.default_gateway_object.description
  tags        = var.tags
}

// Static routes for Azure
resource "panos_panorama_static_route_ipv4" "default_route" {
  name           = var.default_route_name
  virtual_router = panos_panorama_virtual_router.default.name
  destination    = "0.0.0.0/0"
  interface      = panos_panorama_ethernet_interface.public.name
  next_hop       = panos_panorama_address_object.default_gateway.value
  template       = panos_panorama_template.common_template.name
}

############################################################################################
# ADD SECURITY ZONES
############################################################################################

resource "panos_panorama_zone" "untrust" {
  name       = "untrust-zone"
  mode       = "layer3"
  interfaces = [panos_panorama_ethernet_interface.untrust.name]
  template   = panos_panorama_template.common_template.name
}

############################################################################################
# ADD COMMIT NULL RESOURCE
############################################################################################

resource "null_resource" "commit_panorama" {
  provisioner "local-exec" {
    command = "./commit"
  }
  depends_on = [
    module.template.public_zone,
    module.template.private_zone,
    module.template.public_interface,
    module.template.private_interface,
  ]
}
*/
