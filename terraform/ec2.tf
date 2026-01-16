resource "aws_instance" "web" {
  ami                         = "ami-00d8fc944fb171e29"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.public.id]
  private_ip                  = "10.0.0.5"
  iam_instance_profile        = aws_iam_instance_profile.ssm.name
  associate_public_ip_address = true

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
  ami                    = "ami-00d8fc944fb171e29"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private.id]
  private_ip             = "10.0.0.135"
  iam_instance_profile   = aws_iam_instance_profile.ssm.name

  depends_on = [aws_nat_gateway.nat]

  tags = {
    Name = "devops-private-server"
  }

}
