# we use the module by using the name of the folder
# module "vpc" {
#   source = "../modules/vpc"
#   private_subnets_cidr = var.private_subnets_cidr
#   public_subnets_cidr = var.public_subnets_cidr
# }

module "networking" {
  source = "../modules/networking"
  private_subnets = var.private_subnets_cidr
  public_subnets = var.public_subnets_cidr
  env = var.env
  public_route_table_cidr_block = "0.0.0.0/0"
  region = "us-east-1"
  vpc_cidr_block = "10.0.0.0/16"
}

module "bastion"{
  source = "../modules/bastion"
  public_subnets = var.public_subnets_cidr
  public_subnet_id = module.networking.public_subnets
}

# module "eks"{
#   source = "../modules/eks"
#   vpc_id     = module.vpc.vpc_id
#   subnet_ids = module.vpc.private_subnets
# }