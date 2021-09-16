output "master_id" {
  value       = proxmox_vm_qemu.k8_master.*.id
  description = "The id of the master."
}

output "master_ip" {
    value = "${var.ip_master}${var.count_master}" 
} 

output "node_id" {
  value       = proxmox_vm_qemu.k8_node.*.id
  
  description = "The id of the master."
}

output "node_ip" {
    value = proxmox_vm_qemu.k8_node[*].ipconfig0
} 