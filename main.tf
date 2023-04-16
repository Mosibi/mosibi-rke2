terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

variable "installation_image" {
  type = string
  default = "/home/richard/meuk/Rocky-8-GenericCloud-Base.latest.x86_64.qcow2"
}

variable "domain" {
  type = string
  default = "example.com"
}

variable "master_count" {
  type = number
  default = 1
}

variable "worker_count" {
  type = number
  default = 3
}

###
# rke2-masters
###
data "template_file" "rke2_master" {
  count    = var.master_count
  template = file("${path.module}/cloud-init.cfg")
  vars = {
    hostname = "rke2-master${count.index + 1}"
    domain   = var.domain
  }
}

resource "libvirt_cloudinit_disk" "rke2_master" {
  count     = var.master_count
  name      = "rke2_master${count.index + 1}.iso"
  user_data = data.template_file.rke2_master[count.index].rendered
  pool      = "default"
}

resource "libvirt_volume" "rke2_master" {
  count  = var.master_count
  name   = "rke2-master${count.index + 1}.qcow2"
  pool   = "default"
  source = var.installation_image
  format = "qcow2"
}

resource "libvirt_domain" "rke2_master" {
  count  = var.master_count
  name   = "rke2-master${count.index + 1}"
  memory = "4096"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.rke2_master[count.index].id

  disk {
    volume_id = libvirt_volume.rke2_master[count.index].id
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }

  network_interface {
    network_name = "default"
    wait_for_lease = true
  }
}

###
# rke2-workers
###
data "template_file" "rke2_worker" {
  count    = var.worker_count
  template = file("${path.module}/cloud-init.cfg")
  vars = {
    hostname = "rke2-worker${count.index + 1}"
    domain = var.domain
  }
}

resource "libvirt_cloudinit_disk" "rke2_worker" {
  count    = var.worker_count
  name      = "rke2_worker${count.index + 1}.iso"
  user_data = data.template_file.rke2_worker[count.index].rendered
  pool      = "default"
}

resource "libvirt_volume" "rke2_worker" {
  count    = var.worker_count
  name = "rke2-worker${count.index + 1}.qcow2"
  pool = "default"
  source = var.installation_image
  format = "qcow2"
}

resource "libvirt_domain" "rke2_worker" {
  count    = var.worker_count
  name   = "rke2-worker${count.index + 1}"
  memory = "4096"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.rke2_worker[count.index].id

  disk {
    volume_id = libvirt_volume.rke2_worker[count.index].id
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }

  network_interface {
    network_name = "default"
    wait_for_lease = true
  }
}

output "masters_data" {
  description = "Masters information"
  value       = libvirt_domain.rke2_master.*
}

output "workers_data" {
  description = "Worker information"
  value       = libvirt_domain.rke2_worker.*
}
