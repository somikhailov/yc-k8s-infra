module "yc-k8s-infra" {
  source = "./terraform/modules/yc_k8s_infra"

  yc_token     = var.yc_token
  yc_cloud_id  = var.yc_cloud_id
  yc_folder_id = var.yc_folder_id
  yc_zone      = "ru-central1-a"
}

resource "null_resource" "yc-kubeconfig" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      yc managed-kubernetes cluster get-credentials --id ${module.yc-k8s-infra.k8s_cluster_id} --external --force
    EOT
  }
}

module "k8s_services" {
  source = "./terraform/modules/k8s_services"

  depends_on = [
    null_resource.yc-kubeconfig,
  ]
}

data "yandex_dns_zone" "somikhailov_fun" {
  name = "somikhailov-fun"
}

resource "yandex_dns_recordset" "app" {
  zone_id = data.yandex_dns_zone.somikhailov_fun.id
  name    = "app"
  type    = "A"
  ttl     = 200
  data    = [module.k8s_services.external_ip]
}