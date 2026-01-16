resource "aws_s3_bucket" "bootstrap_bucket" {
  bucket        = "bucket-bootstrapping-devops-2"
  force_destroy = true

  tags = {
    Name = "devops-bootstrap-bucket"
  }
}

resource "aws_s3_object" "pkey" {
  bucket = aws_s3_bucket.bootstrap_bucket.id
  key    = "pkey.pem"
  source = "${path.module}/../ansible/pkey.pem"
  etag   = filemd5("${path.module}/../ansible/pkey.pem")

  depends_on = [local_file.ansible_private_key]
}
