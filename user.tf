resource "aws_iam_user" "micro_instance_user" {
  name = local.user_name
}

resource "aws_iam_user_policy_attachment" "ec2-policy-attach" {
  user       = aws_iam_user.micro_instance_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "user_ssh_key" {
  key_name   = local.key_name
  public_key = tls_private_key.key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  sensitive_content = tls_private_key.key.private_key_pem
  filename          = local.key_filename
  file_permission   = "0600"
}
