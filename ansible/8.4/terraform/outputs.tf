output "external_ip_address_vms" {
  value = { 
    for vm in yandex_compute_instance.vms : vm.name => vm.network_interface.0.nat_ip_address 
  }
}