resource "helm_release" "ingress-nginx" {
  name = "ingress-nginx"

  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  wait             = true
}

data "kubernetes_service" "ingress-nginx-controller" {

  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }

  depends_on = [
    helm_release.ingress-nginx,
  ]
}

resource "helm_release" "cert-manager" {
  name = "ingress-nginx"

  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  version          = "v1.8.0"
  create_namespace = true
  wait             = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "kubectl_manifest" "acme-issuer" {
  yaml_body = <<YAML
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt
      namespace: cert-manager
    spec:
      acme:
        server: https://acme-v02.api.letsencrypt.org/directory
        email: ${var.email}
        privateKeySecretRef:
          name: letsencrypt
        solvers:
        - http01:
            ingress:
              class: nginx
YAML

  depends_on = [
    helm_release.cert-manager,
  ]
}