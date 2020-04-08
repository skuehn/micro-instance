resource "aws_vpc" "micro_vpc" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "micro_gateway" {
  vpc_id = aws_vpc.micro_vpc.id
}

resource "aws_subnet" "micro_subnet" {
  vpc_id     = aws_vpc.micro_vpc.id
  cidr_block = "10.0.0.0/27"
}

resource "aws_route_table" "micro_route_table" {
  vpc_id = aws_vpc.micro_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.micro_gateway.id
  }
}

resource "aws_route_table_association" "micro_route_table_association" {
  subnet_id      = aws_subnet.micro_subnet.id
  route_table_id = aws_route_table.micro_route_table.id
}

resource "aws_security_group" "micro_security_group" {
  name = "vpc_web"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.micro_vpc.id
}
