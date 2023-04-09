locals {
  region = "eu-west-2"
  region2 = "eu-west-1"
  name   = "faceit-homework"
  profile = "default"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  cluster_version = 1.25

  tags = {
    Name       = "faceit-infra"
    Type       = "homework"
  }
}