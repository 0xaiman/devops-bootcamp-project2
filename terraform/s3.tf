resource "aws_s3_bucket" "bootstrap_bucket" {
  bucket        = "bucket-bootstrapping-devops-2"
  force_destroy = true

  tags = {
    Name = "devops-bootstrap-bucket"
  }
}

# TODO: use SSM 
resource "aws_s3_object" "pkey" {
  bucket = aws_s3_bucket.bootstrap_bucket.id
  key    = "pkey.pem"
  source = "${path.module}/../ansible/pkey.pem"
  etag   = filemd5("${path.module}/../ansible/pkey.pem")

  depends_on = [local_file.ansible_private_key]
}

resource "aws_s3_object" "inventory_ini" {
  bucket = aws_s3_bucket.bootstrap_bucket.id
  key    = "inventory.ini"
  source = "${path.module}/../ansible/inventory.ini"
  etag   = filemd5("${path.module}/../ansible/inventory.ini")

  depends_on = [local_file.ansible_private_key]
}

resource "aws_s3_object" "ansible_cfg" {
  bucket = aws_s3_bucket.bootstrap_bucket.id
  key    = "ansible.cfg"
  source = "${path.module}/../ansible/ansible.cfg"
  etag   = filemd5("${path.module}/../ansible/ansible.cfg")

  depends_on = [local_file.ansible_private_key]
}
