terraform {
  required_providers {
    virtualbox = {
      source  = "terra-farm/virtualbox"
      version = ">=0.3.2"
    }
  }
}

provider "virtualbox" {}

resource "virtualbox_vm" "game_server" {
  name   = var.vm_name
  cpus   = var.cpus
  memory = var.memory

  vram           = 128
  os_type        = "Ubuntu_64"
  iso_image      = "C:/ISOs/ubuntu-22.04.3-live-server-amd64.iso"
  disk_size      = var.disk_size
  disk_interface = "sata"

  network_adapter {
    type           = "hostonly"
    host_interface = "vboxnet0"
  }

  cloud_init = file("${path.module}/cloud-init.yaml")
}
