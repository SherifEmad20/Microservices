# GitHub Runner Azure Infrastructure with Terraform

This directory contains modular Terraform scripts to provision Azure infrastructure for hosting self-hosted GitHub runners. The infrastructure includes all necessary Azure resources to deploy a virtual machine that can run GitHub Actions workflows.

## **1. Overview**

This Terraform configuration creates a complete Azure environment for GitHub runners, including networking, security, and compute resources. The modular design allows for easy customization and reusability across different environments.

## **2. Prerequisites**

Before deploying this infrastructure, ensure you have:

- **Azure CLI** installed and configured (`az login`)
- **Terraform** installed (version 1.0+)
- **Azure subscription** with appropriate permissions
- **Resource creation permissions** in the target subscription

---

## **3. Architecture Overview**

The infrastructure creates the following Azure resources:

```tree
├── Resource Group
├── Virtual Network (VNet)
│   └── Subnet
├── Public IP Address
├── Network Interface Card (NIC)
├── Network Security Group (NSG)
│   └── SSH Access Rule
└── Linux Virtual Machine (Ubuntu 22.04 LTS)
    ├── Docker Engine
    ├── k3s Kubernetes Cluster
```

---

## **4. Module Structure**

The Terraform configuration is organized into reusable modules:

### **Core Modules**

| Module                        | Description          | Resources Created                    |
| ----------------------------- | -------------------- | ------------------------------------ |
| `rg`                          | Resource Group       | Azure Resource Group with tags       |
| `networks/vnet`               | Virtual Network      | VNet with configurable address space |
| `networks/subnets`            | Subnet               | Subnet within the VNet               |
| `networks/pip`                | Public IP            | Static public IP address             |
| `networks/nic`                | Network Interface    | NIC with public and private IP       |
| `networks/security_group`     | Security Group       | NSG with SSH access rules            |
| `networks/nic_sg_association` | Security Association | Links NIC to NSG                     |
| `virtual_machine`             | Virtual Machine      | Ubuntu VM with automated setup       |

### **Module Dependencies**

The modules have the following dependency chain:

1. **Resource Group** → Created first
2. **Virtual Network** → Depends on Resource Group
3. **Subnet** → Depends on VNet and Resource Group
4. **Public IP** → Depends on Resource Group
5. **Network Interface** → Depends on Subnet and Public IP
6. **Security Group** → Depends on Resource Group
7. **NIC-SG Association** → Depends on NIC and Security Group
8. **Virtual Machine** → Depends on Resource Group and NIC

---

## **5. Configuration**

### **Variables Configuration**

The `variables.tf` file contains all configurable parameters:

#### **Azure Configuration**

```hcl
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "f2df3cc0-75b8-4b87-8230-ab589470a407"
}

variable "location" {
  description = "The Azure location where resources will be created"
  type        = string
  default     = "UK West"
}
```

#### **Resource Group Configuration**

```hcl
variable "resource_group_name" {
  description = "The name of the Azure Resource Group"
  type        = string
  default     = "gh-runner-rg"
}

variable "environment" {
  description = "Environment tag for resources"
  type        = string
  default     = "Development"
}

variable "project" {
  description = "Project tag for resources"
  type        = string
  default     = "Github runner"
}
```

#### **Network Configuration**

```hcl
variable "runner_Vnet_name" {
  description = "The name of the Virtual Network"
  type        = string
  default     = "runner-vnet"
}

variable "address_space_list" {
  description = "The address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "The address prefixes for the Subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}
```

#### **Virtual Machine Configuration**

```hcl
variable "vm_size" {
  description = "The size of the Virtual Machine"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "The admin username for the Virtual Machine"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "The admin password for the Virtual Machine"
  type        = string
  default     = "p@ssw0rd1234!"
}
```

---

## **6. Deployment Instructions**

### **Step 1: Configure Azure Authentication**

```bash
# Login to Azure
az login

# Set the subscription (if needed)
az account set --subscription "your-subscription-id"
```

### **Step 2: Initialize and Deploy**

```bash
# Initialize Terraform
terraform init

# Review the execution plan
terraform plan

# Apply the configuration
terraform apply
```

### **Step 4: Verify Deployment**

```bash
# Check the outputs
terraform output

# Test SSH connection
ssh azureuser@<public_ip_address>
```

---

## **7. Post-Deployment Setup**

After the infrastructure is deployed, the VM will automatically have:

- **Docker Engine** installed and configured
- **k3s Kubernetes cluster** (single-node)
- **Basic tools** (curl, jq, git)

### **Connecting to the VM**

Use the SSH command provided in the outputs:

```bash
# Get the SSH command
terraform output ssh_command

# Connect to the VM
ssh azureuser@<public_ip_address>
```

### **Installing GitHub Runner**

Once connected to the VM, you can use the k3s cluster installed to deploy the GitHub runner:

```bash
# Create runner namespace
kubectl create ns gh-runner-namespace

# Copy the deployment manifest
scp k8s.yaml azureuser@<public_ip_address>:/home/azureuser

# Apply the deployment manifest
kubectl apply -f k8s.yaml -n gh-runner-namespace
```

---

## **8. Module Documentation**

### **Resource Group Module (`modules/rg`)**

**Purpose**: Creates an Azure Resource Group with appropriate tags.

**Inputs**:

- `resource_group_name`: Name of the resource group
- `location`: Azure region
- `environment`: Environment tag
- `project`: Project tag

**Outputs**:

- `resource_group_name`: Name of the created resource group
- `resource_group_id`: ID of the created resource group

### **Virtual Network Module (`modules/networks/vnet`)**

**Purpose**: Creates a Virtual Network with configurable address space.

**Inputs**:

- `virtual_network_name`: Name of the VNet
- `address_space_list`: List of address spaces
- `location`: Azure region
- `resource_group_name`: Resource group name

**Outputs**:

- `vnet_id`: ID of the Virtual Network
- `vnet_name`: Name of the Virtual Network

### **Subnet Module (`modules/networks/subnets`)**

**Purpose**: Creates a subnet within the Virtual Network.

**Inputs**:

- `subnet_name`: Name of the subnet
- `virtual_network_name`: Parent VNet name
- `address_prefixes`: Address prefixes for the subnet
- `resource_group_name`: Resource group name

**Outputs**:

- `subnet_id`: ID of the subnet
- `subnet_name`: Name of the subnet

### **Public IP Module (`modules/networks/pip`)**

**Purpose**: Creates a static public IP address.

**Inputs**:

- `public_ip_name`: Name of the public IP
- `location`: Azure region
- `resource_group_name`: Resource group name

**Outputs**:

- `public_ip_id`: ID of the public IP
- `public_ip_address`: IP address value
- `public_ip_fqdn`: Fully qualified domain name

### **Network Interface Module (`modules/networks/nic`)**

**Purpose**: Creates a network interface card with public and private IP configuration.

**Inputs**:

- `nic_name`: Name of the network interface
- `location`: Azure region
- `resource_group_name`: Resource group name
- `subnet_id`: ID of the subnet
- `public_ip_address_id`: ID of the public IP

**Outputs**:

- `nic_id`: ID of the network interface
- `nic_private_ip_address`: Private IP address
- `nic_name`: Name of the network interface

### **Security Group Module (`modules/networks/security_group`)**

**Purpose**: Creates a Network Security Group with SSH access rules.

**Inputs**:

- `security_group_name`: Name of the security group
- `location`: Azure region
- `resource_group_name`: Resource group name
- `allowed_ssh_cidr`: CIDR block for SSH access

**Outputs**:

- `security_group_id`: ID of the security group
- `security_group_name`: Name of the security group

### **Virtual Machine Module (`modules/virtual_machine`)**

**Purpose**: Creates an Ubuntu VM with automated setup for Docker and k3s.

**Inputs**:

- `vm_name`: Name of the virtual machine
- `location`: Azure region
- `resource_group_name`: Resource group name
- `vm_size`: Size of the VM
- `admin_username`: Admin username
- `admin_password`: Admin password
- `network_interface_id`: ID of the network interface

**Features**:

- Ubuntu 22.04 LTS
- Automated Docker installation
- k3s Kubernetes cluster setup
- Essential development tools

---

## **9. Outputs**

The configuration provides the following outputs:

```hcl
# Resource Group Information
output "resource_group_name" - Name of the resource group
output "resource_group_id" - ID of the resource group

# Network Information
output "vnet_id" - Virtual Network ID
output "subnet_id" - Subnet ID
output "public_ip_address" - Public IP address
output "nic_private_ip_address" - Private IP address

# Security Information
output "security_group_id" - Security Group ID

# Connection Information
output "ssh_command" - Ready-to-use SSH command
```

---

## **10. References**

- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Virtual Machines Documentation](https://docs.microsoft.com/en-us/azure/virtual-machines/)
- [GitHub Actions Self-hosted Runners](https://docs.github.com/en/actions/hosting-your-own-runners)
- [k3s Documentation](https://k3s.io/)
- [Docker Installation Guide](https://docs.docker.com/engine/install/ubuntu/)
