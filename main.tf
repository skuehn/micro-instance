variable "aws_region" {
  description = "Region hosting the micro instance"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "micro_host" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.micro_security_group.id]
  subnet_id                   = aws_subnet.micro_subnet.id
  associate_public_ip_address = true
  source_dest_check           = false
  key_name                    = aws_key_pair.key_pair.key_name
}

output "instance_hostname" {
  value = aws_instance.micro_host.public_dns
}

output "ssh_key" {
  value = local_file.private_key_pem.filename
}
