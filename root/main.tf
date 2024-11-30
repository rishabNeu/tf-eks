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
  vpc_id = module.networking.vpc_id
}

module "eks"{
  source = "../modules/eks"
  vpc_id     = module.networking.vpc_id
  bastion_sg_id = module.bastion.bastion_sg_id
  private_subnet_ids = module.networking.private_subnets
}