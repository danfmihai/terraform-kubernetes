resource "proxmox_vm_qemu" "k8_node" {
  count       = var.count_node
  desc        = "Terraform k8s node(s) provision for PROXMOX"
  agent       = 1
  os_type     = "cloud-init"
  name        = "k8-node-${var.img_type}-${count.index + 1}"
  target_node = var.proxmox_host
  clone       = "${var.img_type}-cloudinit-template"
  full_clone  = true
  cores       = var.cores_node
  memory      = var.memory_node
  cpu         = "host"
  boot        = "c"
  bootdisk    = "scsi0"
  scsihw      = "virtio-scsi-pci"
  
  disk {
    slot         = 0
    size         = "10G"
    type         = "scsi"
    storage      = "nvme"
    # storage_type = "scsi"
    iothread     = 1
  }
  
  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # Cloud Init Settings
  ipconfig0 = "ip=${var.ip_node}${count.index + 1}/24,gw=${var.gw}"
  #os_network_config =  <<EOF
  #auto eth0
  #iface eth0 inet dhcp
  #EOF
  sshkeys = <<EOF
  ${var.ssh_key1}
  EOF

}