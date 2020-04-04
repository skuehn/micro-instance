locals {
  instance_type      = "t2.micro"
  user_name          = "microinstance"
  key_name           = "microinstance_key"
  key_filename       = "${path.module}/.tmp-key.pem"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.0.0/24"
}

variable "aws_region" {
  description = "Region hosting the micro instance"
  default     = "us-east-1"
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
  instance_type               = local.instance_type
  vpc_security_group_ids      = [aws_security_group.sec.id]
  subnet_id                   = aws_subnet.micro_subnet.id
  associate_public_ip_address = true
  source_dest_check           = false
  key_name                    = aws_key_pair.user_ssh_key.key_name
}

output "instance_hostname" {
  value = aws_instance.micro_host.public_dns
}

output "ssh_key" {
  value = local_file.private_key_pem.filename
}
