# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create AWS VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.env}-vpc"
    Environment = "${var.env}"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.env}-igw"
    Environment = "${var.env}"
  }
}

# public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.public_route_table_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.env}-public-route-table"
    Environment = "${var.env}"
  }
}

# create 3 public subnets
# each in different availability zones in the same region as the VPC
resource "aws_subnet" "public_subnets" {
  map_public_ip_on_launch = true
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.available_zones.names[count.index % length(data.aws_availability_zones.available_zones.names)]


  tags = {
    Name        = "${var.env}-public-subnet-${count.index}"
    Environment = "${var.env}"
  }
}
# associate public subnets with the public route table
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Create 3 private subnets
# each in different availability zones in the same region as the VPC
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available_zones.names[count.index % length(data.aws_availability_zones.available_zones.names)]

  tags = {
    Name        = "${var.env}-private-subnet-${count.index}"
    Environment = "${var.env}"
  }
}

//private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.env} - private route table"
  }
}

//private subnet association
resource "aws_route_table_association" "private_subnet_association" {
  count = length(var.private_subnets)

  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id
  tags = {
    Name = "nat-gateway"
  }
}



