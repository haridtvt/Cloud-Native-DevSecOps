# SETUP VPC, SUBNET, IGATEWAY, 4 EIP

resource "aws_vpc" "VPC" {
  cidr_block = var.cidr_block
  tags = {
    terraform = "true",
    Name = "VPC_devsecops"
  }
}

resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "IG_devsecops",
    terraform = "true"
  }
}

resource "aws_subnet" "SUBNET" {
  vpc_id = aws_vpc.VPC.id
  cidr_block = var.cidr_block_public
  availability_zone = var.zone
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet_ec2_devsecops",
    terraform = "true"
  }
}

resource "aws_route_table" "ROUTE" {
  vpc_id = aws_vpc.VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }
  tags = {
    terraform = "true",
    Name = "Public_RT_DevSecOps"
  }
}

resource "aws_route_table_association" "RTASSOC" {
  subnet_id      = aws_subnet.SUBNET.id
  route_table_id = aws_route_table.ROUTE.id
}

resource "aws_eip" "JENS" {
  domain = "vpc"
  tags = {
    Name = "ip_jenkins_server",
    terraform = "true"
  }
}
resource "aws_eip" "APP" {
  domain = "vpc"
  tags = {
    Name = "ip_application_server",
    terraform = "true"
  }
}
resource "aws_eip" "SEC" {
  domain = "vpc"
  tags = {
    Name = "ip_security_server",
    terraform = "true"
  }
}
resource "aws_eip" "MOR" {
  domain = "vpc"
  tags = {
    Name = "ip_monitoring_server",
    terraform = "true"
  }
}