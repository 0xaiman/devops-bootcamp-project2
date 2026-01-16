resource "aws_ssm_association" "upload_pem" {
  name = "AWS-RunShellScript"

  targets {
    key    = "InstanceIds"
    values = [aws_instance.controller.id]
  }

  parameters = {
    commands = "aws s3 cp ./pkey.pem s3://bucket-bootstrapping-devops-2/pkey.pem"
  }

  depends_on = [local_file.ansible_private_key]

}
