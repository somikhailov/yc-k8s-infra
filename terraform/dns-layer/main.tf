data "kubernetes_service" "ingress-nginx-controller" {

  metadata {
    name      = "ingress-nginx-nginx-ingress-controller"
    namespace = "ingress-nginx"
  }
}

data "yandex_dns_zone" "somikhailov_fun" {
  name = "somikhailov-fun"
}

resource "yandex_dns_recordset" "app" {
  zone_id = data.yandex_dns_zone.somikhailov_fun.id
  name    = "app"
  type    = "A"
  ttl     = 200
  data    = [data.kubernetes_service.ingress-nginx-controller.status.0.load_balancer.0.ingress.0.ip]
}

resource "yandex_dns_recordset" "prometheus" {
  zone_id = data.yandex_dns_zone.somikhailov_fun.id
  name    = "prometheus"
  type    = "A"
  ttl     = 200
  data    = [data.kubernetes_service.ingress-nginx-controller.status.0.load_balancer.0.ingress.0.ip]
}

resource "yandex_dns_recordset" "grafana" {
  zone_id = data.yandex_dns_zone.somikhailov_fun.id
  name    = "grafana"
  type    = "A"
  ttl     = 200
  data    = [data.kubernetes_service.ingress-nginx-controller.status.0.load_balancer.0.ingress.0.ip]
}

resource "yandex_dns_recordset" "alertmanager" {
  zone_id = data.yandex_dns_zone.somikhailov_fun.id
  name    = "alertmanager"
  type    = "A"
  ttl     = 200
  data    = [data.kubernetes_service.ingress-nginx-controller.status.0.load_balancer.0.ingress.0.ip]
}

resource "yandex_dns_recordset" "kibana" {
  zone_id = data.yandex_dns_zone.somikhailov_fun.id
  name    = "kibana"
  type    = "A"
  ttl     = 200
  data    = [data.kubernetes_service.ingress-nginx-controller.status.0.load_balancer.0.ingress.0.ip]
}
