data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"
  azs             = data.aws_availability_zones.available.names
#   count      = length(var.private_subnets_cidr)
  private_subnets = var.private_subnets_cidr
  public_subnets  = var.public_subnets_cidr

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    Name = "public-subnet"
  }

  private_subnet_tags ={
    Name = "private-subnet"
}
}