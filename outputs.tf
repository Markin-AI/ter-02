output "web" {
  value = {
    instance_name = yandex_compute_instance.platform-web.name
    external_ip   = yandex_compute_instance.platform-web.network_interface.0.nat_ip_address
    fqdn          = yandex_compute_instance.platform-web.fqdn
  }
}

output "db" {
  value = {
    instance_name = yandex_compute_instance.platform-db.name
    external_ip   = yandex_compute_instance.platform-db.network_interface.0.nat_ip_address
    fqdn          = yandex_compute_instance.platform-db.fqdn
  }
}