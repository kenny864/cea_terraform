
provider "aws" {
    region = "us-east-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Write Code
# Init
# Plan
# Apply
# Destroy

# VPC
resource "aws_vpc" "MyTerraformVPC" {
  cidr_block = "90.3.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "MyTerraformVPC"
  }
}

# Public Subnet 1A
resource "aws_subnet" "TPublicSubnet1A" {
  vpc_id = aws_vpc.MyTerraformVPC.id
  cidr_block = "90.3.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "TPublicSubnet1A"
  }
}

# Private Subnet 1A
resource "aws_subnet" "TAppSubnet1A" {
  vpc_id = aws_vpc.MyTerraformVPC.id
  cidr_block = "90.3.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "TAppSubnet1A"
  }
}

# Private Subnet 1B
resource "aws_subnet" "TAppSubnet1B" {
  vpc_id = aws_vpc.MyTerraformVPC.id
  cidr_block = "90.3.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "TAppSubnet1B"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "InternetGateway" {
  vpc_id = aws_vpc.MyTerraformVPC.id
  tags = {
    Name = "T_VPC_GW"
  }
}

# Route Table
resource "aws_route_table" "My_T_RouteTable" {
  vpc_id = aws_vpc.MyTerraformVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.InternetGateway.id
  }

  tags = {
    Name = "Public_Route_Table"
  }
}

# Route Table Association Public Subnet 1A
resource "aws_route_table_association" "PublicSubnet1ARouteTableAssociation" {
  subnet_id = aws_subnet.TPublicSubnet1A.id
  route_table_id = aws_route_table.My_T_RouteTable.id
}
