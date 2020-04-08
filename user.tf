resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "microinstance_key"
  public_key = tls_private_key.key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  sensitive_content = tls_private_key.key.private_key_pem
  filename          = "${path.module}/.tmp-key.pem"
  file_permission   = "0600"
}
