resource "aws_security_group" "web" {
  name        = "${var.component_name}_web"
  description = "Allow ssh inbound traffic from Philo"
  vpc_id      = local.vpc_id

  ingress {
    description = "http traffic from port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "http traffic from port 80"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "http traffic from port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    "Name" = "${var.component_name}_web"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "web_server" {
  name        = "${var.component_name}_web_server"
  description = "Allow shh inbound traffic from ${aws_security_group.web.id}"
  vpc_id      = local.vpc_id

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["71.163.242.34/32"]
  }
  ingress {
    description     = "http from VPC"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["71.163.242.34/32"]
    security_groups = [aws_security_group.web.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.component_name}_web_server"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "app_sg" {
  name        = "${var.component_name}_lb_sg"
  description = "Allow inbound traffic from everywhere"
  vpc_id      = local.vpc_id

  ingress {
    description     = "http from everywhere"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  ingress {
    description     = "22 from web sg"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_server.id]
  }
  ingress {
    description     = "22 from web sg"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.web_server.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${var.component_name}_app_sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}
