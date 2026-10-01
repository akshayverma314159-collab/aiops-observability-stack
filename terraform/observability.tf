resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true

  depends_on = [module.eks]
}

resource "helm_release" "k8sgpt_operator" {
  name             = "k8sgpt-operator"
  repository       = "https://charts.k8sgpt.ai/" #
  chart            = "k8sgpt-operator"
  namespace        = "k8sgpt-operator-system"
  create_namespace = true

  depends_on = [module.eks]
}
