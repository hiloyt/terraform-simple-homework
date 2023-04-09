module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "19.12.0"

  cluster_name                   = "${local.name}-eks-fg"
  cluster_version                = local.cluster_version
  cluster_endpoint_public_access = true

  cluster_addons = {
    kube-proxy = {}
    vpc-cni    = {}
    coredns = {
      configuration_values = jsonencode({
        computeType = "Fargate"
      })
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  fargate_profile_defaults = {
    iam_role_additional_policies = {
      additional = aws_iam_policy.additional.arn
    }
  }

  fargate_profiles = merge(
    {
      faceit = {
        name = "faceit"
        selectors = [
          {
            namespace = "app-*"
            labels = {
              app = "faceit"
            }
          }
        ]

        subnet_ids = [module.vpc.private_subnets[1]]

        tags = {
          Owner = "secondary"
        }

        timeouts = {
          create = "20m"
          delete = "20m"
        }
      }
    },
    {
      devops = {
        name = "devops"
        selectors = [
          {
            namespace = "devops-*"
          }
        ]

        subnet_ids = [module.vpc.private_subnets[1]]

        tags = {
          Owner = "secondary"
        }

        timeouts = {
          create = "20m"
          delete = "20m"
        }
      }
    },
    { for i in range(3) :
      "kube-system-${element(split("-", local.azs[i]), 2)}" => {
        selectors = [
          { namespace = "kube-system" }
        ]
        subnet_ids = [element(module.vpc.private_subnets, i)]
      }
    }
  )

  tags = local.tags
}

resource "aws_iam_policy" "additional" {
  name = "${local.name}-additional"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}