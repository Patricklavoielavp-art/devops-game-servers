output "vm_name" {
  value       = virtualbox_vm.game_server.name
  description = "Name of the VM"
}

output "vm_ip" {
  value       = virtualbox_vm.game_server.network_adapter[0].ip_address
  description = "VM IP address (host-only)"
}
