module "yc-k8s-infra" {
  source = "./terraform/modules/yc_k8s_infra"

  yc_token     = var.yc_token
  yc_cloud_id  = var.yc_cloud_id
  yc_folder_id = var.yc_folder_id
  yc_zone      = "ru-central1-a"
}