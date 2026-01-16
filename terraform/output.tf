output "ssm_commands" {
  description = "SSM start-session commands for instances (copy-paste)"
  value = {
    web_server = "aws ssm start-session --target ${aws_instance.web.id}"
    controller = "aws ssm start-session --target ${aws_instance.controller.id}"


  }
}

output "bootstrap_bucket_name" {
  description = "Name of the bootstrap S3 bucket"
  value       = aws_s3_bucket.bootstrap_bucket.bucket
}

output "key_push_ssm_association_id" {
  description = "SSM association ID for PEM key upload via SSM"
  value       = aws_ssm_association.upload_pem.id
}
