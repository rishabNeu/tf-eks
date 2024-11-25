output "region" {
  value = var.region
}

output "env" {
  value = var.env
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnets" {
  value = aws_subnet.private_subnets[*].id
}

output "igw_id" {
  value = aws_internet_gateway.igw
}

