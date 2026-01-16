resource "aws_s3_bucket" "bootstrap_bucket" {
  bucket        = "bucket-bootstrapping-devops-2"
  force_destroy = true

  tags = {
    Name = "devops-bootstrap-bucket"
  }
}

# TODO: use SSM 
# resource "aws_s3_object" "pkey" {
#   bucket = aws_s3_bucket.bootstrap_bucket.id
#   key    = "pkey.pem"
#   source = "${path.module}/../ansible/pkey.pem"
#   etag   = filemd5("${path.module}/../ansible/pkey.pem")

#   depends_on = [aws_nat_gateway.nat]
# }

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

resource "aws_s3_object" "docker_yml" {
  bucket = aws_s3_bucket.bootstrap_bucket.id
  key    = "docker.yml"
  source = "${path.module}/../ansible/docker.yml"
  etag   = filemd5("${path.module}/../ansible/docker.yml")

  depends_on = [local_file.ansible_private_key]
}

resource "aws_s3_object" "webserver_yml" {
  bucket = aws_s3_bucket.bootstrap_bucket.id
  key    = "webserver.yml"
  source = "${path.module}/../ansible/webserver.yml"
  etag   = filemd5("${path.module}/../ansible/webserver.yml")

  depends_on = [local_file.ansible_private_key]
}



