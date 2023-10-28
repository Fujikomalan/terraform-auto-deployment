resource "aws_security_group" "webserver" {

  name        = "webserver-${var.project_name}-${var.project_env}"
  description = "webserver-${var.project_name}-${var.project_env}"


  ingress {

    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {

    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {

    Name    = "webserver-${var.project_name}-${var.project_env}"
    project = var.project_name
    env     = var.project_env
  }

}


resource "aws_instance" "webserver" {

  ami                    = "ami-067c21fb1979f0b27"
  instance_type          = "t2.micro"
  key_name               = "zomato-project"
  vpc_security_group_ids = [aws_security_group.webserver.id]
  user_data              = file("setup.sh")
  tags = {

    Name    = "webserver-${var.project_name}-${var.project_env}"
    project = var.project_name
    env     = var.project_env
  }
}


resource "aws_eip" "frontend" {
  instance = aws_instance.webserver.id
  domain   = "vpc"
}

resource "aws_route53_record" "fronend" {
  zone_id = "${var.hosted_zone}"
  name    = "${var.hostname}.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.frontend.public_ip]
}
