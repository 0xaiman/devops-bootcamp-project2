resource "tls_private_key" "ansible" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ansible" {
  key_name   = "pkey"
  public_key = tls_private_key.ansible.public_key_openssh
}

resource "local_file" "ansible_private_key" {
  filename        = "${path.module}/../ansible/pkey.pem"
  content         = tls_private_key.ansible.private_key_pem
  file_permission = "0600"
}


