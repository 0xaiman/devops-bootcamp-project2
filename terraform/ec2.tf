resource "aws_instance" "web" {
  ami                         = "ami-0827b3068f1548bf6"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.public.id]
  private_ip                  = "10.0.0.5"
  iam_instance_profile        = aws_iam_instance_profile.ssm.name
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ansible.key_name

  tags = {
    Name = "devops-web-server"
  }


  user_data = templatefile("${path.module}/inits/web.yml", {})

}

resource "aws_eip" "web_eip" {
  instance = aws_instance.web.id
  domain   = "vpc"

  tags = {
    Name = "devops-web-eip"
  }
}

resource "aws_instance" "controller" {
  ami                    = "ami-0827b3068f1548bf6"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private.id]
  private_ip             = "10.0.0.135"
  iam_instance_profile   = aws_iam_instance_profile.ssm.name
  key_name               = aws_key_pair.ansible.key_name

  user_data = templatefile("${path.module}/inits/controller.yml", {})


  depends_on = [aws_nat_gateway.nat, aws_iam_role_policy_attachment.ssm]

  tags = {
    Name = "devops-controller-server"
  }

}

resource "aws_instance" "monitoring" {
  ami                    = "ami-0827b3068f1548bf6"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private.id]
  private_ip             = "10.0.0.136"
  iam_instance_profile   = aws_iam_instance_profile.ssm.name
  key_name               = aws_key_pair.ansible.key_name

  user_data = templatefile("${path.module}/inits/monitor.yml", {})


  depends_on = [aws_nat_gateway.nat, aws_iam_role_policy_attachment.ssm]

  tags = {
    Name = "devops-monitor-server"
  }

}
