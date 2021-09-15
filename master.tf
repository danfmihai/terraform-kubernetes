resource "proxmox_vm_qemu" "k8_master" {
  count       = var.count_master
  desc        = "Terraform master(s) provision for PROXMOX"
  agent       = 1
  os_type     = "cloud-init"
  name        = "k8-master-${var.img_type}-${count.index + 1}"
  target_node = var.proxmox_host
  clone       = "${var.img_type}-cloudinit-template"
  full_clone  = true
  cores       = var.cores_master
  memory      = var.memory_master
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
  ipconfig0 = "ip=${var.ip_master}${count.index + 1}/24,gw=${var.gw}"
  #os_network_config =  <<EOF
  #auto eth0
  #iface eth0 inet dhcp
  #EOF
  sshkeys = <<EOF
  ${var.ssh_key1}
  EOF

}