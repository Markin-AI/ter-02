resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

resource "yandex_vpc_subnet" "develop_b" {
  name           = var.vpc_name_b
  zone           = var.default_zone_b
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr_b
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform-web" {
  name        = local.db_name
  platform_id = var.vm_web_platform_id
  metadata    = var.vm_metadata
  zone        = var.default_zone_b
  resources {
    cores         = var.vm_resources.web.cores
    memory        = var.vm_resources.web.memory
    core_fraction = var.vm_resources.web.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
}
data "yandex_compute_image" "ubuntu2" {
  family = var.vm_db_family
}

resource "yandex_compute_instance" "platform-db" {
  name        = local.db_name
  platform_id = var.vm_db_platform_id
  metadata    = var.vm_metadata
  zone        = var.default_zone_b
  resources {
    cores         = var.vm_resources.db.cores
    memory        = var.vm_resources.db.memory
    core_fraction = var.vm_resources.db.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_b.id
    nat       = true
  }
}