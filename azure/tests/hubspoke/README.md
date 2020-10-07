# Collapsed Design: Everything Is In Hub

This Terraform code make uses for various modules in the modules folder to deploy the following:
- Resource group
- Hub that has:
  - Virtual network
  - Three subnets: management, public, and private
  - Availability sets
  - Data and management interface network security groups
  - Two active/active PAN firewalls
  - Internal load balancer
  - Public load balancer
  - Route tables and user defined routes
  - 1 Windows jump server in private subnet
  - 1 Windows VM in private subnet

This code is used to create everthing for full end-to-end traffic flow testing. The tfstate file is stored locally.
