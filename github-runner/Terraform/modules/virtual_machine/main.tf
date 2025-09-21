resource "azurerm_linux_virtual_machine" "this" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  network_interface_ids = [var.network_interface_id]

  admin_username      = var.admin_username
  admin_password      = var.admin_password

  disable_password_authentication = false

  # Ubuntu 22.04 LTS Gen2
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 64
  }
  
  # Plain bash (no cloud-config). Must be base64-encoded.
  custom_data = base64encode(<<-BASH
#!/usr/bin/env bash
set -euxo pipefail

ADMIN_USER="${var.admin_username}"

export DEBIAN_FRONTEND=noninteractive
apt update -y
apt upgrade -y
apt install -y curl jq git apt-transport-https ca-certificates gnupg lsb-release

# --- Docker (no sudo for your user) ---

apt install -y docker.io
chmod 666 /var/run/docker.sock


# --- k3s single-node (uses containerd; Docker will be separate) ---
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode=644" sh -

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml


BASH
)
}