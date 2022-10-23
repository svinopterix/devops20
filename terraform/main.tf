resource "yandex_compute_instance" "vm-1" {
  name = "${terraform.workspace}-vm${format("%02d", count.index+1)}"

  count = local.count_map[terraform.workspace]

  resources {
    cores  = local.cores_map[terraform.workspace]
    memory = local.memory_map[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      image_id = "fd81hgrcv6lsnkremf32"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "vagrant:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm-2" {

  for_each = local.vm_2_instances

  name = "${terraform.workspace}-vm-${each.key}"


  resources {
    cores  = each.value[0]
    memory = each.value[1]
  }

  boot_disk {
    initialize_params {
      image_id = "fd81hgrcv6lsnkremf32"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "vagrant:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name = "subnet1"
  #  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

