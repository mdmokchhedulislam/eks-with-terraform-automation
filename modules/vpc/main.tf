provider "aws" {
  region = var.region
}

# ----------------------
# VPC
# ----------------------
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name                                = "${var.project_name}-vpc"
    "kubernetes.io/cluster/${var.project_name}" = "shared"
    Environment                         = var.environment
  }
}

# ----------------------
# Internet Gateway
# ----------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# ----------------------
# Public Subnets
# ----------------------
resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, index(keys(var.public_subnets), each.key))
  availability_zone       = each.value
  map_public_ip_on_launch = true

  tags = {
    Name                              = "${var.project_name}-${each.key}"
    "kubernetes.io/role/elb"          = "1"
    "kubernetes.io/cluster/${var.project_name}" = "shared"
    Environment                       = var.environment
  }
}

# ----------------------
# Private Subnets
# ----------------------
resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, index(keys(var.private_subnets), each.key) + length(var.public_subnets))
  availability_zone = each.value

  tags = {
    Name                              = "${var.project_name}-${each.key}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.project_name}" = "shared"
    Environment                       = var.environment
  }
}

# ----------------------
# NAT Gateway
# ----------------------
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public["public_1"].id

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.this]
}

# ----------------------
# Route Tables
# ----------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

# ----------------------
# Route Table Associations
# ----------------------
resource "aws_route_table_association" "public" {
  for_each      = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each      = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
