output "ssm_commands" {
  description = "SSM start-session commands for instances (copy-paste)"
  value = {
    web_server = "aws ssm start-session --target ${aws_instance.web.id}"
    controller = "aws ssm start-session --target ${aws_instance.controller.id}"


  }
}



