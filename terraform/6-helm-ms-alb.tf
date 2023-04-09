resource "helm_release" "metrics-server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "devops-monitoring"
  create_namespace = true
  version    = "3.9.0"
  wait = true
  timeout = 1200  

  values = [
    "${file("ms-values.yaml")}"
  ]

  depends_on = [
    module.eks
  ]
}

resource "helm_release" "aws-load-balancer-controller" {
  name = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "devops-ingress"
  create_namespace = true
  version    = "1.4.8"
  wait = true
  timeout = 1200 

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.aws_load_balancer_controller.arn
  }

  set {
    name  = "region"
    value = local.region
  }

  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }

  depends_on = [
    module.eks
  ]
}