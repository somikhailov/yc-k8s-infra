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
      helmfile sync
      terraform -chdir=terraform/dns-layer apply -auto-approve
    EOT
  }

  depends_on = [
    module.yc-k8s-infra,
  ]
}