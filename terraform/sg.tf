

resource "aws_security_group" "public" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }

  ingress {
    description = "ANY"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Prometheus node_exporter (from monitoring)"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }



  tags = {
    Name = "devops-public-sg"
  }
}



resource "aws_security_group" "private" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"] # VPC CIDR, or just web server IP 10.0.0.5
  }




  tags = {
    Name = "devops-private-sg"
  }
}

resource "aws_security_group" "monitoring" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.5/32"] # web server
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-monitoring-sg"
  }
}



resource "aws_security_group_rule" "allow_monitoring_to_web_node_exporter" {
  type                     = "ingress"
  from_port                = 9100
  to_port                  = 9100
  protocol                 = "tcp"
  security_group_id        = aws_security_group.public.id
  source_security_group_id = aws_security_group.monitoring.id
  description              = "Allow Prometheus (monitoring) to scrape node_exporter on web instances"
}

resource "aws_security_group_rule" "allow_monitoring_to_controller_node_exporter" {
  type                     = "ingress"
  from_port                = 9100
  to_port                  = 9100
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private.id
  source_security_group_id = aws_security_group.monitoring.id
  description              = "Allow Prometheus (monitoring) to scrape node_exporter on controller instances"
}



resource "aws_security_group_rule" "allow_web_to_monitor_prometheus" {
  type                     = "ingress"
  from_port                = 9090
  to_port                  = 9090
  protocol                 = "tcp"
  security_group_id        = aws_security_group.monitoring.id
  source_security_group_id = aws_security_group.public.id
  description              = "Allow web (nginx) to access Prometheus on monitoring instances"
}

