module "ecr" {
  source = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  repository_name = local.name

  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  create_lifecycle_policy           = false
  attach_repository_policy          = false
  tags                              = local.tags
}