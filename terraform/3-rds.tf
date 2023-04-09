module "rds" {
  source = "terraform-aws-modules/rds/aws"
  version = "5.6.0"

  identifier = "${local.name}-psql"

  create_db_parameter_group = false
  create_db_option_group    = false
  create_random_password    = false

  engine               = "postgres"
  engine_version       = "14"
  family               = "postgres14"
  major_engine_version = "14"
  instance_class       = "db.m5.large"

  allocated_storage     = 5

  db_name  = "faceit"
  username = "faceit"
  password = "xmowwux!!3QpMj"
  port     = 5432

  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.security_group.security_group_id]

  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]

  tags = local.tags
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"

  name        = "${local.name}-psql-sg"
  description = "Psql security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "psql within vpc"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = local.tags
}