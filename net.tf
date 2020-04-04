resource "aws_vpc" "default" {
  cidr_block           = local.vpc_cidr
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

resource "aws_subnet" "micro_subnet" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = local.public_subnet_cidr
  availability_zone = "${var.aws_region}a"
}

resource "aws_route_table" "micro_route_table" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
}

resource "aws_route_table_association" "micro_route_table_association" {
  subnet_id      = aws_subnet.micro_subnet.id
  route_table_id = aws_route_table.micro_route_table.id
}

resource "aws_security_group" "sec" {
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

  vpc_id = aws_vpc.default.id
}
