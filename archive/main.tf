resource "aws_vpc" "main" {
  cidr_block = "10.30.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = ""
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = {
    Name = "Private Route Table"
  }
  depends_on = [ aws_nat_gateway.main ]
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.30.1.0/24"
  availability_zone = var.availability_zone
  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.30.2.0/24"
  availability_zone = var.availability_zone
  tags = {
    Name = "Public Subnet"
  }
  depends_on = [aws_vpc.main]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  route {
    cidr_block = "10.40.0.0/26"
    vpc_peering_connection_id = "pcx-0b20c69354d8dcf2b"
  }
  tags = {
    Name = "Public Route Table"
  }
  depends_on = [aws_vpc.main,
                aws_internet_gateway.main]
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
  depends_on = [aws_vpc.main,
                aws_subnet.private,
                aws_subnet.public,
                aws_route_table.public]
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  depends_on = [ aws_route_table_association.public ]
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public.id
  tags = {
    Name = "NAT Gateway"
  }
  depends_on = [aws_eip.nat_eip]
}