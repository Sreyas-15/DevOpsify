#custom tagging as per project and envname will be attached to every resource
locals {
  name_prefix = "${var.project}-${var.environment}"
}


# VPC creation with dns support as application is multitier including db and other microservices

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}


# PUBLIC SUBNETS  (one per AZ) 
# Using the looping mechanism over the list of variables decalred in vars like az's, cidr blocks
# Auto assign public ip is turned on as this is public subnet
resource "aws_subnet" "public" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-public-${var.azs[count.index]}-subnet"
    Tier = "public"
  })
}

    
# PRIVATE SUBNETS  (one per AZ)

resource "aws_subnet" "private" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-private-${var.azs[count.index]}-subnet"
    Tier = "private"
  })
}

    
# INTERNET GATEWAY (IGW)
    
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-igw"
  })
}

    
# ELASTIC IPs for NAT GATEWAYS

resource "aws_eip" "nat" {
  count  = length(var.azs)
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-nat-eip-${var.azs[count.index]}"
  })

  depends_on = [aws_internet_gateway.this]
}

    
# NAT GATEWAYS  (placed in PUBLIC subnets, one per AZ)
# Two seperate NAT gateways for two provate subnets
resource "aws_nat_gateway" "this" {
  count         = length(var.azs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-nat-${var.azs[count.index]}"
  })

  depends_on = [aws_internet_gateway.this]
}

    
# PUBLIC ROUTE TABLE  
# (single, shared by both public subnets) routes any internet facing traffic to IGW
    
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-public-rt"
  })
}

#These are two associations one for each public subnet

resource "aws_route_table_association" "public" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

    
# PRIVATE ROUTE TABLES  
#(one per AZ, each pointing to its own NAT)
# Routes any outbound internet facing traffic to NAT gateway which does network address translation
resource "aws_route_table" "private" {
  count  = length(var.azs)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[count.index].id
  }

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-private-rt-${var.azs[count.index]}"
  })
}

#These are two associations one for each private  subnet


resource "aws_route_table_association" "private" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
