module "runner_rg" {
  source              = "./modules/rg"
  resource_group_name = var.resource_group_name
  location            = var.location
  environment         = var.environment
  project             = var.project
}

module "runner-vnet" {
  source              = "./modules/networks/vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  environment         = var.environment
  project             = var.project
  virtual_network_name = var.runner_Vnet_name
  address_space_list   = var.address_space_list
  
  depends_on = [
    module.runner_rg
  ]
}

module "runner-subnet" {
  source               = "./modules/networks/subnets"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.runner_Vnet_name
  subnet_name          = var.subnet_name
  address_prefixes     = var.subnet_address_prefixes
  
  depends_on = [
    module.runner_rg,
    module.runner-vnet
  ]
}

module "runner-pip" {
    source              = "./modules/networks/pip"
    resource_group_name = var.resource_group_name
    location            = var.location
    public_ip_name      = var.public_ip_name
    
    depends_on = [
      module.runner_rg
    ]
}

module "runner-nic" {
    source              = "./modules/networks/nic"
    nic_name            = var.nic_name
    location            = var.location
    resource_group_name = var.resource_group_name

    ip_configuration_name = var.ip_configuration_name
    subnet_id           = module.runner-subnet.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    public_ip_address_id = module.runner-pip.public_ip_id
    
    depends_on = [
      module.runner_rg,
      module.runner-subnet,
      module.runner-pip
    ]
}

module "runner-sg" {
    source              = "./modules/networks/security_group"
    security_group_name = var.runner_rg_name
    location            = var.location
    resource_group_name = var.resource_group_name
    allowed_ssh_cidr    = var.allowed_ssh_cidr
    
    depends_on = [
      module.runner_rg
    ]
}

module "runner-nic-sg-association" {
    source                    = "./modules/networks/nic_sg_association"
    network_interface_id      = module.runner-nic.nic_id
    network_security_group_id = module.runner-sg.security_group_id
    
    depends_on = [
      module.runner-nic,
      module.runner-sg
    ]
}

module "runner-vm" {
  source              = "./modules/virtual_machine"
  vm_name             = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_id = module.runner-nic.nic_id
  
  depends_on = [
    module.runner_rg,
    module.runner-nic
  ]
}