resource "yandex_kubernetes_cluster" "k8s-infra" {
  name        = "k8s-infra"
  description = "k8s-infra"

  network_id = yandex_vpc_network.k8s-net.id

  master {
    version = "1.21"
    zonal {
      zone      = yandex_vpc_subnet.k8s-subnet-a.zone
      subnet_id = yandex_vpc_subnet.k8s-subnet-a.id
    }

    public_ip = true

    maintenance_policy {
      auto_upgrade = true
    }
  }

  service_account_id      = yandex_iam_service_account.instances.id
  node_service_account_id = yandex_iam_service_account.docker.id

  release_channel         = "RAPID"
  network_policy_provider = "CALICO"
}

resource "yandex_kubernetes_node_group" "infra-pool" {
  cluster_id = yandex_kubernetes_cluster.k8s-infra.id
  name       = "infra-pool"
  version    = "1.21"
  node_labels = {
    "pool" = "infra"
  }
  node_taints = ["node-role=infra:NoSchedule"]

  instance_template {
    platform_id = "standard-v2"
    network_interface {
      nat        = true
      subnet_ids = ["${yandex_vpc_subnet.k8s-subnet-a.id}"]
    }

    resources {
      memory = 8
      cores  = 4
    }

    boot_disk {
      type = "network-hdd"
      size = 50
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    location {
      zone = var.yc_zone
    }
  }

  maintenance_policy {
    auto_upgrade = false
    auto_repair  = true
  }
}

resource "yandex_kubernetes_node_group" "app-pool" {
  cluster_id = yandex_kubernetes_cluster.k8s-infra.id
  name       = "app-pool"
  version    = "1.21"
  node_labels = {
    "pool" = "app"
  }

  instance_template {
    platform_id = "standard-v2"
    network_interface {
      nat        = true
      subnet_ids = ["${yandex_vpc_subnet.k8s-subnet-a.id}"]
    }

    resources {
      memory = 8
      cores  = 4
    }

    boot_disk {
      type = "network-hdd"
      size = 50
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      min     = 2
      max     = 3
      initial = 2
    }
  }

  allocation_policy {
    location {
      zone = var.yc_zone
    }
  }

  maintenance_policy {
    auto_upgrade = false
    auto_repair  = true
  }
}

resource "yandex_vpc_network" "k8s-net" {
  name = "k8s-net"
}

resource "yandex_vpc_subnet" "k8s-subnet-a" {
  name           = "k8s-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.k8s-net.id
  v4_cidr_blocks = ["10.0.0.0/16"]
}


resource "yandex_iam_service_account" "docker" {
  name        = "docker"
  description = "service account to use container registry"
}

resource "yandex_iam_service_account" "instances" {
  name        = "instances"
  description = "service account to manage VMs"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.yc_folder_id

  role = "editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.instances.id}",
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "pusher" {
  folder_id = var.yc_folder_id

  role = "container-registry.images.pusher"

  members = [
    "serviceAccount:${yandex_iam_service_account.docker.id}",
  ]
}